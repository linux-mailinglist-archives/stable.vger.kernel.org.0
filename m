Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D28945C5EB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349384AbhKXOCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355903AbhKXOAb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87495613E8;
        Wed, 24 Nov 2021 13:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759338;
        bh=w5jAJJkSTSBbRbh88MBCFu0YOlDTVe2QE1prIhZGWw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO29NCRx8ATyfqh8w4eBfX96i0MqtMkTR1BUFNqyVT23MFWE7uYJ5wjfV9bTlGYDB
         eirh1S4l5r4wshmNzRmGzuPRUUH6SInInG5clWPHDtIJxhXUdzub0hRF06LOcfkT3K
         isN7ifgp+NO0sr8vwgPnJmuM15rt7B3k3O3yVdho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Finn Thain <fthain@linux-m68k.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 5.15 208/279] powerpc/signal32: Fix sigset_t copy
Date:   Wed, 24 Nov 2021 12:58:15 +0100
Message-Id: <20211124115725.924491978@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 5499802b2284331788a440585869590f1bd63f7f upstream.

The conversion from __copy_from_user() to __get_user() by
commit d3ccc9781560 ("powerpc/signal: Use __get_user() to copy
sigset_t") introduced a regression in __get_user_sigset() for
powerpc/32. The bug was subsequently moved into
unsafe_get_user_sigset().

The bug is due to the copied 64 bit value being truncated to
32 bits while being assigned to dst->sig[0]

The regression was reported by users of the Xorg packages distributed in
Debian/powerpc --

    "The symptoms are that the fb screen goes blank, with the backlight
    remaining on and no errors logged in /var/log; wdm (or startx) run
    with no effect (I tried logging in in the blind, with no effect).
    And they are hard to kill, requiring 'kill -KILL ...'"

Fix the regression by copying each word of the sigset, not only the
first one.

__get_user_sigset() was tentatively optimised to copy 64 bits at once
in order to minimise KUAP unlock/lock impact, but the unsafe variant
doesn't suffer that, so it can just copy words.

Fixes: 887f3ceb51cd ("powerpc/signal32: Convert do_setcontext[_tm]() to user access block")
Cc: stable@vger.kernel.org # v5.13+
Reported-by: Finn Thain <fthain@linux-m68k.org>
Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/99ef38d61c0eb3f79c68942deb0c35995a93a777.1636966353.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/signal.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/signal.h
+++ b/arch/powerpc/kernel/signal.h
@@ -25,8 +25,14 @@ static inline int __get_user_sigset(sigs
 
 	return __get_user(dst->sig[0], (u64 __user *)&src->sig[0]);
 }
-#define unsafe_get_user_sigset(dst, src, label) \
-	unsafe_get_user((dst)->sig[0], (u64 __user *)&(src)->sig[0], label)
+#define unsafe_get_user_sigset(dst, src, label) do {			\
+	sigset_t *__dst = dst;						\
+	const sigset_t __user *__src = src;				\
+	int i;								\
+									\
+	for (i = 0; i < _NSIG_WORDS; i++)				\
+		unsafe_get_user(__dst->sig[i], &__src->sig[i], label);	\
+} while (0)
 
 #ifdef CONFIG_VSX
 extern unsigned long copy_vsx_to_user(void __user *to,


