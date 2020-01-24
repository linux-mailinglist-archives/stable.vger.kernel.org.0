Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FB2148494
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388890AbgAXLNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:13:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389259AbgAXLNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:09 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5593F20708;
        Fri, 24 Jan 2020 11:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864389;
        bh=5RiNq3ChLXcE2MqyxudXObIACzuPAqKPoCbvjSzOPl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0duFemPRkzZU927IjsupFt57D2pnvvRB74lb2CrDw301rlcGU9hxMv0qk05WH4BI
         Y5Xdk8jVlSMeYEoMCv2yHvoFAymk6A/17pTxwc9Kujz9AFGYDmsG+QRs0iG5YJRpfB
         1/9FAAeowxVmnMPBrafKy3J+y3ZbApG+TuntM2Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 238/639] ARM: 8849/1: NOMMU: Fix encodings for PMSAv8s PRBAR4/PRLAR4
Date:   Fri, 24 Jan 2020 10:26:48 +0100
Message-Id: <20200124093116.635947062@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit d410a8a49e3e00e07d43037e90f776d522b25a6a ]

To access PRBARn, where n is referenced as a binary number:

MRC p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0] ; Read PRBARn into Rt
MCR p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0] ; Write Rt into PRBARn

To access PRLARn, where n is referenced as a binary number:

MRC p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]+1 ; Read PRLARn into Rt
MCR p15, 0, <Rt>, c6, c8+n[3:1], 4*n[0]+1 ; Write Rt into PRLARn

For PR{B,L}AR4, n is 4, n[0] is 0, n[3:1] is 2, while current encoding
done with n[0] set to 1 which is wrong. Use proper encoding instead.

Fixes: 046835b4aa22b9ab6aa0bb274e3b71047c4b887d ("ARM: 8757/1: NOMMU: Support PMSAv8 MPU")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head-nommu.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index 326a97aa3ea0c..22efcf48604cd 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -441,8 +441,8 @@ M_CLASS(str	r6, [r12, #PMSAv8_RLAR_A(3)])
 	str	r5, [r12, #PMSAv8_RBAR_A(0)]
 	str	r6, [r12, #PMSAv8_RLAR_A(0)]
 #else
-	mcr	p15, 0, r5, c6, c10, 1			@ PRBAR4
-	mcr	p15, 0, r6, c6, c10, 2			@ PRLAR4
+	mcr	p15, 0, r5, c6, c10, 0			@ PRBAR4
+	mcr	p15, 0, r6, c6, c10, 1			@ PRLAR4
 #endif
 #endif
 	ret	lr
-- 
2.20.1



