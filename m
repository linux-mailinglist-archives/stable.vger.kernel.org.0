Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9050F10BD28
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfK0VCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbfK0VCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B512D20862;
        Wed, 27 Nov 2019 21:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888523;
        bh=t6h2MdHKYMubMCHj2hQ1lpKMgX+mo2ybIpeMq9ud7/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z69TRZIaM/U+SCYjEfsm0iUCzXgAOsUK+2gJPxzzPZeVA3Mts4VKqCBbApjbdD0CZ
         e/sz+vRkogs6StMUyVpVsArA9zPtmlB932tAeWD7q3tekj2nDKHqdteiDreTO2Y0eI
         /0rC0gNDToWAJFZZWWCAHoEw20modlDE5aKNSVAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Yury Norov <ynorov@caviumnetworks.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/306] linux/bitmap.h: handle constant zero-size bitmaps correctly
Date:   Wed, 27 Nov 2019 21:30:17 +0100
Message-Id: <20191127203127.614192983@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 7275b097851a5e2e0dd4da039c7e96b59ac5314e ]

The static inlines in bitmap.h do not handle a compile-time constant
nbits==0 correctly (they dereference the passed src or dst pointers,
despite only 0 words being valid to access).  I had the 0-day buildbot
chew on a patch [1] that would cause build failures for such cases without
complaining, suggesting that we don't have any such users currently, at
least for the 70 .config/arch combinations that was built.  Should any
turn up, make sure they use the out-of-line versions, which do handle
nbits==0 correctly.

This is of course not the most efficient, but it's much less churn than
teaching all the static inlines an "if (zero_const_nbits())", and since we
don't have any current instances, this doesn't affect existing code at
all.

[1] lkml.kernel.org/r/20180815085539.27485-1-linux@rasmusvillemoes.dk

Link: http://lkml.kernel.org/r/20180818131623.8755-3-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitmap.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index acf5e8df3504f..a9805bacbd7ca 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -204,8 +204,13 @@ extern int bitmap_print_to_pagebuf(bool list, char *buf,
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1)))
 #define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
 
+/*
+ * The static inlines below do not handle constant nbits==0 correctly,
+ * so make such users (should any ever turn up) call the out-of-line
+ * versions.
+ */
 #define small_const_nbits(nbits) \
-	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG && (nbits) > 0)
 
 static inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
 {
-- 
2.20.1



