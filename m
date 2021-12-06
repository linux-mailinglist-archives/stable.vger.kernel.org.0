Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E60E469C93
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344835AbhLFPXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38838 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345164AbhLFPTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01AEA612DB;
        Mon,  6 Dec 2021 15:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5950C341C2;
        Mon,  6 Dec 2021 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803781;
        bh=BKJIY6la4EjbejNgntuX5jeB5u8bWyQ+xRnXcMK8FeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Te/zyq0bGWFSEXYzpu3k689m8newbJQ8aJZDINfJnfJHYL3Fv/v/K6hXtHKy9wq8+
         5AEcLR/hH6xM021V+1LAx1qI8ogAiyxWh3MKgCv6+PfQL6Bocpj2PLO69K8h5DZDE7
         iE57LR0E+2CiklHbeese/LOh/exkVXw618Agn9Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Chris January <Chris.January@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 045/130] KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1
Date:   Mon,  6 Dec 2021 15:56:02 +0100
Message-Id: <20211206145601.237522262@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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
@@ -83,7 +83,7 @@
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
-#define TCR_EL2_RES1		((1 << 31) | (1 << 23))
+#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
 #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
@@ -268,7 +268,7 @@
 #define CPTR_EL2_TFP_SHIFT 10
 
 /* Hyp Coprocessor Trap Register */
-#define CPTR_EL2_TCPAC	(1 << 31)
+#define CPTR_EL2_TCPAC	(1U << 31)
 #define CPTR_EL2_TAM	(1 << 30)
 #define CPTR_EL2_TTA	(1 << 20)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)


