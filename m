Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F31531813
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241482AbiEWRd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241594AbiEWRa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB453D4AA;
        Mon, 23 May 2022 10:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEE7611E3;
        Mon, 23 May 2022 17:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E3BC385A9;
        Mon, 23 May 2022 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326777;
        bh=9Zc0Kphv2aqH1+IbNRUj/srjFNT98FwAZCJBJ81hjug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tr13yZS+C/ZAva/zTTtphrpAv3rXq5HlgLzM8Pgn7lVEhWcufrhxGbCvvLgNq9QtE
         oI/p+y6L69jx8+B05FcSwzAwDdbyW2u8Lc9udRbGHCRie1vJGWUM3xvery8hcCTEit
         6hQKYv2JT3pIR38bjoqC6De9/NRGzk6EA0NZH8aY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH 5.17 055/158] KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC
Date:   Mon, 23 May 2022 19:03:32 +0200
Message-Id: <20220523165839.913337649@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 5163373af195f10e0d99a8de3465c4ed36bdc337 upstream.

When adding support for the slightly wonky Apple M1, we had to
populate ID_AA64PFR0_EL1.GIC==1 to present something to the guest,
as the HW itself doesn't advertise the feature.

However, we gated this on the in-kernel irqchip being created.
This causes some trouble for QEMU, which snapshots the state of
the registers before creating a virtual GIC, and then tries to
restore these registers once the GIC has been created.  Obviously,
between the two stages, ID_AA64PFR0_EL1.GIC has changed value,
and the write fails.

The fix is to actually emulate the HW, and always populate the
field if the HW is capable of it.

Fixes: 562e530fd770 ("KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reported-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Oliver Upton <oupton@google.com>
Link: https://lore.kernel.org/r/20220503211424.3375263-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1080,8 +1080,7 @@ static u64 read_id_reg(const struct kvm_
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
-		if (irqchip_in_kernel(vcpu->kvm) &&
-		    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
 		}


