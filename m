Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1F013F66A
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbgAPRCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388295AbgAPRCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9FC2073A;
        Thu, 16 Jan 2020 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194132;
        bh=pOkluVnHUm+ELhjKzSD++0rgASEdiCKf2x3XTdb8Res=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1nfaltul760cPgg8VJtXsxkPdbBE4H/6pEQ6OfBkPjQPwrOlv3xtCfH/7SxhCbNF
         Z2ATpoVEiWFYm8s6aKTOeLEYata1f+Vn+vEWL7ibqpZsTILx/hQBfiJBUjHWSHkz0q
         Am9H8eJxuXQu3agEyYA1PAYIcO5vD+G0VzjzWcgk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 222/671] ARM: 8849/1: NOMMU: Fix encodings for PMSAv8's PRBAR4/PRLAR4
Date:   Thu, 16 Jan 2020 11:52:11 -0500
Message-Id: <20200116165940.10720-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 326a97aa3ea0..22efcf48604c 100644
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

