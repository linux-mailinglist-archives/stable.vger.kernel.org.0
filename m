Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCE71D3C56
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgENSxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbgENSxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E18E520675;
        Thu, 14 May 2020 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482381;
        bh=PrtCpeIcIF14jX/Sm959d5MO6mu76YUu8reG4jm9w3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xw+6W/nZJkLGf0+YlZ3yW9rDAQOeuDbk2RSXOl6lKZkAKwJXX1kMzGVSRQWMIoXXs
         et6AX03wZSW3LlpjjSQvzkrtO2erCkLUfFbcINepiVEEr1PtU9HbE2NwjxLT4xcTDr
         7+CBRVvQGADeTXt7UQ78cPMdnbnyuEmRnJt+Hpy4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 58/62] gcc-10: disable 'restrict' warning for now
Date:   Thu, 14 May 2020 14:51:43 -0400
Message-Id: <20200514185147.19716-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit adc71920969870dfa54e8f40dac8616284832d02 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index dde725d9c17d2..c679a260f8ad3 100644
--- a/Makefile
+++ b/Makefile
@@ -863,6 +863,9 @@ KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
 KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-overflow)
 
+# Another good warning that we'll want to enable eventually
+KBUILD_CFLAGS += $(call cc-disable-warning, restrict)
+
 # Enabled with W=2, disabled by default as noisy
 KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
 
-- 
2.20.1

