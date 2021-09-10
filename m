Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F043E40614D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhIJAmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhIJASG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 428E66115A;
        Fri, 10 Sep 2021 00:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233008;
        bh=+efzFw3+KZqGnrAyjhJhrMQqPbG/mKtLzbLkzhWQAug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp7mrYQ92cEIv+gmxZJQgMDiJhI2Y79L+EJMf2IG58cX1cSlrM0TtR6+VNWIO8NHJ
         lpgFJh91D0vSeB0YLok5fBN1JWy7Ljh4yJVEg1LqxlqJ+265Rwvc5rDUB3bpZPqx8j
         2Lcn+psKXLKm1VGbofd9fmLmiobdTE4QN3PWZ34m8G/MfxkxRhgSNKzdnIitMuQpXt
         GXyKgJlqaYBtGMWSeC6pUSxkcUZG2dsLKeD5EcwSjNXt2LMzEZNExn4vz61R4RFjMk
         2Dn1das43pJK9EF3kfAjV4aZpuWeZq9k5MCxvt/CifRYFKlGMnPANIhXdMtBecUZdN
         lsqsvDenPCgUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Wang <wangrui@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 35/99] MIPS: locking/atomic: Fix atomic{_64,}_sub_if_positive
Date:   Thu,  9 Sep 2021 20:14:54 -0400
Message-Id: <20210910001558.173296-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Wang <wangrui@loongson.cn>

[ Upstream commit cb95ea79b3fc772c5873a7a4532ab4c14a455da2 ]

This looks like a typo and that caused atomic64 test failed.

Signed-off-by: Rui Wang <wangrui@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/atomic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 95e1f7f3597f..a0b9e7c1e4fc 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -206,7 +206,7 @@ ATOMIC_OPS(atomic64, xor, s64, ^=, xor, lld, scd)
  * The function returns the old value of @v minus @i.
  */
 #define ATOMIC_SIP_OP(pfx, type, op, ll, sc)				\
-static __inline__ int arch_##pfx##_sub_if_positive(type i, pfx##_t * v)	\
+static __inline__ type arch_##pfx##_sub_if_positive(type i, pfx##_t * v)	\
 {									\
 	type temp, result;						\
 									\
-- 
2.30.2

