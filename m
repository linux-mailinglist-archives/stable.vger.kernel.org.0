Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1DE150C2B
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgBCQd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730696AbgBCQd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:57 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8166D2087E;
        Mon,  3 Feb 2020 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747637;
        bh=cVb0S88UCjPdrHSeJvHEcWnD2n4qSAj8xxjn56lrqBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVcHCEP2S6GunQI+Pp0BNeuGSV+MSZ75Lcszrlw4rlG+pfFnNx7iJ2nwcico/R/dk
         QAPhalRpo/hZ+Y3wTNN6Uae7UNZ/GwOLI2Royc4ZIIgkwkjkf1mMw8ai1pMaZvPPzv
         ewFJQODQzBVPWLOO8x2zZuP040OESWwys0WCUH/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 58/70] ARM: 8955/1: virt: Relax arch timer version check during early boot
Date:   Mon,  3 Feb 2020 16:20:10 +0000
Message-Id: <20200203161920.632026854@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 6849b5eba1965ceb0cad3a75877ef4569dd3638e ]

Updates to the Generic Timer architecture allow ID_PFR1.GenTimer to
have values other than 0 or 1 while still preserving backward
compatibility. At the moment, Linux is quite strict in the way it
handles this field at early boot and will not configure arch timer if
it doesn't find the value 1.

Since here use ubfx for arch timer version extraction (hyb-stub build
with -march=armv7-a, so it is safe)

To help backports (even though the code was correct at the time of writing)

Fixes: 8ec58be9f3ff ("ARM: virt: arch_timers: enable access to physical timers")
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/hyp-stub.S | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 82a942894fc04..83e463c05dcdb 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -159,10 +159,9 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
 #if !defined(ZIMAGE) && defined(CONFIG_ARM_ARCH_TIMER)
 	@ make CNTP_* and CNTPCT accessible from PL1
 	mrc	p15, 0, r7, c0, c1, 1	@ ID_PFR1
-	lsr	r7, #16
-	and	r7, #0xf
-	cmp	r7, #1
-	bne	1f
+	ubfx	r7, r7, #16, #4
+	teq	r7, #0
+	beq	1f
 	mrc	p15, 4, r7, c14, c1, 0	@ CNTHCTL
 	orr	r7, r7, #3		@ PL1PCEN | PL1PCTEN
 	mcr	p15, 4, r7, c14, c1, 0	@ CNTHCTL
-- 
2.20.1



