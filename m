Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0171D86B0
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgERS0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729847AbgERRpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:45:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 592B620715;
        Mon, 18 May 2020 17:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823902;
        bh=dfVQR4veVC0esrH3yIaUeif+5yaaxqOggWhhT+OkLVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrpqngwMb10LhYtSce77MpW1M/KK10zC8Vqi5o9Ny0AtmLjA3t7gbKiGo+EdDr1GE
         MRcOeBjeUavqHnvuMi8OY4NywlUIHV+ynkSB0RmeHWDU6jArTVEsjhmsdEeIf55JDO
         wcPVCt10OcUhFlE2Je5olCbkDzykV1t76ha9IjxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 65/90] gcc-10: disable array-bounds warning for now
Date:   Mon, 18 May 2020 19:36:43 +0200
Message-Id: <20200518173504.341089242@linuxfoundation.org>
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

commit 44720996e2d79e47d508b0abe99b931a726a3197 upstream.

This is another fine warning, related to the 'zero-length-bounds' one,
but hitting the same historical code in the kernel.

Because C didn't historically support flexible array members, we have
code that instead uses a one-sized array, the same way we have cases of
zero-sized arrays.

The one-sized arrays come from either not wanting to use the gcc
zero-sized array extension, or from a slight convenience-feature, where
particularly for strings, the size of the structure now includes the
allocation for the final NUL character.

So with a "char name[1];" at the end of a structure, you can do things
like

       v = my_malloc(sizeof(struct vendor) + strlen(name));

and avoid the "+1" for the terminator.

Yes, the modern way to do that is with a flexible array, and using
'offsetof()' instead of 'sizeof()', and adding the "+1" by hand.  That
also technically gets the size "more correct" in that it avoids any
alignment (and thus padding) issues, but this is another long-term
cleanup thing that will not happen for 5.7.

So disable the warning for now, even though it's potentially quite
useful.  Having a slew of warnings that then hide more urgent new issues
is not an improvement.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -799,6 +799,7 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 
 # We'll want to enable this eventually, but it's not going away for 5.7 at least
 KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
+KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
 
 # Enabled with W=2, disabled by default as noisy
 KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)


