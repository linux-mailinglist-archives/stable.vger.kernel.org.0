Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F59D4A4345
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377475AbiAaLUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47934 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349652AbiAaLP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:15:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F56A6114C;
        Mon, 31 Jan 2022 11:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF7AC340E8;
        Mon, 31 Jan 2022 11:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627757;
        bh=441R/jm3tYCTGZzotX4hO7aA2iBf47g9b1wx6mfIyA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbxbN2F3MO2ZlOk+5k8nLXILiwCEbxqKaOd2U4mNEW8OxWHyQCtJIVWsS1VlIc6XL
         A4LJ/GUdm6qn5vvhI9XenIDyN9mi9i2LRozhcjss3NlM19kqyxmiBc1rxabG1bvggS
         9Cz04GXD/uEE7X2Dyovp83D9GvIOTKc7riofM8W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.16 016/200] KVM: arm64: vgic-v3: Restrict SEIS workaround to known broken systems
Date:   Mon, 31 Jan 2022 11:54:39 +0100
Message-Id: <20220131105234.109561547@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit d11a327ed95dbec756b99cbfef2a7fd85c9eeb09 upstream.

Contrary to what df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3
locally generated SErrors") was asserting, there is at least one other
system out there (Cavium ThunderX2) implementing SEIS, and not in
an obviously broken way.

So instead of imposing the M1 workaround on an innocent bystander,
let's limit it to the two known broken Apple implementations.

Fixes: df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors")
Reported-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220122103912.795026-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c |    3 +++
 arch/arm64/kvm/vgic/vgic-v3.c   |   17 +++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -983,6 +983,9 @@ static void __vgic_v3_read_ctlr(struct k
 	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
 	/* IDbits */
 	val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
+	/* SEIS */
+	if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK)
+		val |= BIT(ICC_CTLR_EL1_SEIS_SHIFT);
 	/* A3V */
 	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -609,6 +609,18 @@ static int __init early_gicv4_enable(cha
 }
 early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 
+static const struct midr_range broken_seis[] = {
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
+	{},
+};
+
+static bool vgic_v3_broken_seis(void)
+{
+	return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) &&
+		is_midr_in_range_list(read_cpuid_id(), broken_seis));
+}
+
 /**
  * vgic_v3_probe - probe for a VGICv3 compatible interrupt controller
  * @info:	pointer to the GIC description
@@ -676,9 +688,10 @@ int vgic_v3_probe(const struct gic_kvm_i
 		group1_trap = true;
 	}
 
-	if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) {
-		kvm_info("GICv3 with locally generated SEI\n");
+	if (vgic_v3_broken_seis()) {
+		kvm_info("GICv3 with broken locally generated SEI\n");
 
+		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_SEIS_MASK;
 		group0_trap = true;
 		group1_trap = true;
 		if (ich_vtr_el2 & ICH_VTR_TDS_MASK)


