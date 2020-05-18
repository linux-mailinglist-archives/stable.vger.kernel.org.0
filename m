Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3841D8128
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgERRp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbgERRp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D8EC20674;
        Mon, 18 May 2020 17:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823927;
        bh=fSRau1pAiWHNJbmlUH/uhaszxFG174FpSD9tnHCsz6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWFwuKQTfTGhSuTDM4cJLNl4DkviQDsovAnMBu7gA/WMYVTmT67FaXyFmz9GeFh1W
         Po0/mgCs7H509nJ/ruVL+TfS2h+iJvuKYhhxGI1SDDnao0Sly04CxeMzmuo63FYCYy
         8B6lYQ9pS1vKVed19N0D56NEtMs83VU1kokpMYo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 67/90] gcc-10: disable restrict warning for now
Date:   Mon, 18 May 2020 19:36:45 +0200
Message-Id: <20200518173504.854092505@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit adc71920969870dfa54e8f40dac8616284832d02 upstream.

gcc-10 now warns about passing aliasing pointers to functions that take
restricted pointers.

That's actually a great warning, and if we ever start using 'restrict'
in the kernel, it might be quite useful.  But right now we don't, and it
turns out that the only thing this warns about is an idiom where we have
declared a few functions to be "printf-like" (which seems to make gcc
pick up the restricted pointer thing), and then we print to the same
buffer that we also use as an input.

And people do that as an odd concatenation pattern, with code like this:

    #define sysfs_show_gen_prop(buffer, fmt, ...) \
        snprintf(buffer, PAGE_SIZE, "%s"fmt, buffer, __VA_ARGS__)

where we have 'buffer' as both the destination of the final result, and
as the initial argument.

Yes, it's a bit questionable.  And outside of the kernel, people do have
standard declarations like

    int snprintf( char *restrict buffer, size_t bufsz,
                  const char *restrict format, ... );

where that output buffer is marked as a restrict pointer that cannot
alias with any other arguments.

But in the context of the kernel, that 'use snprintf() to concatenate to
the end result' does work, and the pattern shows up in multiple places.
And we have not marked our own version of snprintf() as taking restrict
pointers, so the warning is incorrect for now, and gcc picks it up on
its own.

If we do start using 'restrict' in the kernel (and it might be a good
idea if people find places where it matters), we'll need to figure out
how to avoid this issue for snprintf and friends.  But in the meantime,
this warning is not useful.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -802,6 +802,9 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-overflow)
 
+# Another good warning that we'll want to enable eventually
+KBUILD_CFLAGS += $(call cc-disable-warning, restrict)
+
 # Enabled with W=2, disabled by default as noisy
 KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
 


