Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D933469D87
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386859AbhLFPaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:30:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60924 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356672AbhLFP1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:27:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CD89B81132;
        Mon,  6 Dec 2021 15:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75635C341C2;
        Mon,  6 Dec 2021 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804251;
        bh=jqslwsQPGSajih9VRKlGKbUSejD3b2XWing09UphHiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esJzXdp9z4nMn7X8A+eccT38pZL67tDA4EhSMtyLSSBGuOMHwdRnmLMDiQOJqaQYL
         jI1d3eXF9blqrVWkLvfkbTQRfzjcOrLdQh8G0NfEjTDeirezNmFbACAfuqQBgg9SH1
         BYOf9JveaNCoVZxMGv0njuQIxUnN207pGD3oKa3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Chris January <Chris.January@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 081/207] KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1
Date:   Mon,  6 Dec 2021 15:55:35 +0100
Message-Id: <20211206145613.049942838@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit 1f80d15020d7f130194821feb1432b67648c632d upstream.

Having a signed (1 << 31) constant for TCR_EL2_RES1 and CPTR_EL2_TCPAC
causes the upper 32-bit to be set to 1 when assigning them to a 64-bit
variable. Bit 32 in TCR_EL2 is no longer RES0 in ARMv8.7: with FEAT_LPA2
it changes the meaning of bits 49:48 and 9:8 in the stage 1 EL2 page
table entries. As a result of the sign-extension, a non-VHE kernel can
no longer boot on a model with ARMv8.7 enabled.

CPTR_EL2 still has the top 32 bits RES0 but we should preempt any future
problems

Make these top bit constants unsigned as per commit df655b75c43f
("arm64: KVM: Avoid setting the upper 32 bits of VTCR_EL2 to 1").

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Chris January <Chris.January@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211125152014.2806582-1-catalin.marinas@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_arm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -91,7 +91,7 @@
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
-#define TCR_EL2_RES1		((1 << 31) | (1 << 23))
+#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
 #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
@@ -276,7 +276,7 @@
 #define CPTR_EL2_TFP_SHIFT 10
 
 /* Hyp Coprocessor Trap Register */
-#define CPTR_EL2_TCPAC	(1 << 31)
+#define CPTR_EL2_TCPAC	(1U << 31)
 #define CPTR_EL2_TAM	(1 << 30)
 #define CPTR_EL2_TTA	(1 << 20)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)


