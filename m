Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFCFFEE90
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbfKPPw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730199AbfKPPw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:52:26 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 983342084B;
        Sat, 16 Nov 2019 15:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919545;
        bh=RO3NcGmMVyAPo8SoPW9CsQgCU3aD96mHNIyXuVrwtxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rj2RYEtDcL7nZ6AEyceb4ImsUufyxnmkTkRhgOvvqTOHoeZiXTOJDq2uu2fio2ohz
         Owe0Fuf07Lg4UBBkNNq99RFuIeX4WhlaHvQ/Tq+BtL3tlnGc9xMF1pHN+knh597V+3
         81MYAxm5eWcv8WKD7rcpDDwv7CoH/nskbixK8rlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <ynorov@caviumnetworks.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 58/99] linux/bitmap.h: fix type of nbits in bitmap_shift_right()
Date:   Sat, 16 Nov 2019 10:50:21 -0500
Message-Id: <20191116155103.10971-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit d9873969fa8725dc6a5a21ab788c057fd8719751 ]

Most other bitmap API, including the OOL version __bitmap_shift_right,
take unsigned nbits.  This was accidentally left out from 2fbad29917c98.

Link: http://lkml.kernel.org/r/20180818131623.8755-5-linux@rasmusvillemoes.dk
Fixes: 2fbad29917c98 ("lib: bitmap: change bitmap_shift_right to take unsigned parameters")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Yury Norov <ynorov@caviumnetworks.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index dc56304ac829f..dec03c0dbc214 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -321,7 +321,7 @@ static __always_inline int bitmap_weight(const unsigned long *src, unsigned int
 }
 
 static inline void bitmap_shift_right(unsigned long *dst, const unsigned long *src,
-				unsigned int shift, int nbits)
+				unsigned int shift, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> shift;
-- 
2.20.1

