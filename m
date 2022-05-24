Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3785C532E2C
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiEXQB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 12:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239321AbiEXQA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 12:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F28B9D4FD;
        Tue, 24 May 2022 09:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA3BC61766;
        Tue, 24 May 2022 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4306FC34116;
        Tue, 24 May 2022 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408015;
        bh=cBNge5pbPFNpjc3yYWweALItim0uRV+wmebu8g7bA2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atltLFXempL6x/KsznXjHI61bZ+fC/LFl6WxxmOoaH9GEL8cZDTo8l5EyLg1SGqex
         72w3xxkv2WxgbTIl9KPFdMry56ayIQBSkd2QY7VceQAgpeln7Rcw1EinghXRokPeNA
         QIACpjTkB0iMG66KQ0yWAy4WG3YpqoZX91cSm/ekvNPizJz32O+/2nQa/8LR0lpwlT
         Izv04cAQLGtGIIYFrAVP7aifZ3Av18AkOW74vKm82dO8/7PHLSHjz3khIVDw+Jt0S/
         s0Iu2n2lSXC7xDRv1rdsp0sMGRwU9dAVKJK+QVNSXT2v+7A2cfjHZkJ6xVjBVkKNkn
         aEFH6niC+tKyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.15 03/10] KVM: arm64: Don't hypercall before EL2 init
Date:   Tue, 24 May 2022 12:00:00 -0400
Message-Id: <20220524160009.826957-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160009.826957-1-sashal@kernel.org>
References: <20220524160009.826957-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Quentin Perret <qperret@google.com>

[ Upstream commit 2e40316753ee552fb598e8da8ca0d20a04e67453 ]

Will reported the following splat when running with Protected KVM
enabled:

[    2.427181] ------------[ cut here ]------------
[    2.427668] WARNING: CPU: 3 PID: 1 at arch/arm64/kvm/mmu.c:489 __create_hyp_private_mapping+0x118/0x1ac
[    2.428424] Modules linked in:
[    2.429040] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.18.0-rc2-00084-g8635adc4efc7 #1
[    2.429589] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
[    2.430286] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    2.430734] pc : __create_hyp_private_mapping+0x118/0x1ac
[    2.431091] lr : create_hyp_exec_mappings+0x40/0x80
[    2.431377] sp : ffff80000803baf0
[    2.431597] x29: ffff80000803bb00 x28: 0000000000000000 x27: 0000000000000000
[    2.432156] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[    2.432561] x23: ffffcd96c343b000 x22: 0000000000000000 x21: ffff80000803bb40
[    2.433004] x20: 0000000000000004 x19: 0000000000001800 x18: 0000000000000000
[    2.433343] x17: 0003e68cf7efdd70 x16: 0000000000000004 x15: fffffc81f602a2c8
[    2.434053] x14: ffffdf8380000000 x13: ffffcd9573200000 x12: ffffcd96c343b000
[    2.434401] x11: 0000000000000004 x10: ffffcd96c1738000 x9 : 0000000000000004
[    2.434812] x8 : ffff80000803bb40 x7 : 7f7f7f7f7f7f7f7f x6 : 544f422effff306b
[    2.435136] x5 : 000000008020001e x4 : ffff207d80a88c00 x3 : 0000000000000005
[    2.435480] x2 : 0000000000001800 x1 : 000000014f4ab800 x0 : 000000000badca11
[    2.436149] Call trace:
[    2.436600]  __create_hyp_private_mapping+0x118/0x1ac
[    2.437576]  create_hyp_exec_mappings+0x40/0x80
[    2.438180]  kvm_init_vector_slots+0x180/0x194
[    2.458941]  kvm_arch_init+0x80/0x274
[    2.459220]  kvm_init+0x48/0x354
[    2.459416]  arm_init+0x20/0x2c
[    2.459601]  do_one_initcall+0xbc/0x238
[    2.459809]  do_initcall_level+0x94/0xb4
[    2.460043]  do_initcalls+0x54/0x94
[    2.460228]  do_basic_setup+0x1c/0x28
[    2.460407]  kernel_init_freeable+0x110/0x178
[    2.460610]  kernel_init+0x20/0x1a0
[    2.460817]  ret_from_fork+0x10/0x20
[    2.461274] ---[ end trace 0000000000000000 ]---

Indeed, the Protected KVM mode promotes __create_hyp_private_mapping()
to a hypercall as EL1 no longer has access to the hypervisor's stage-1
page-table. However, the call from kvm_init_vector_slots() happens after
pKVM has been initialized on the primary CPU, but before it has been
initialized on secondaries. As such, if the KVM initcall procedure is
migrated from one CPU to another in this window, the hypercall may end up
running on a CPU for which EL2 has not been initialized.

Fortunately, the pKVM hypervisor doesn't rely on the host to re-map the
vectors in the private range, so the hypercall in question is in fact
superfluous. Skip it when pKVM is enabled.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
[maz: simplified the checks slightly]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220513092607.35233-1-qperret@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0b2f684cd8ca..a30c036577a3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1458,7 +1458,8 @@ static int kvm_init_vector_slots(void)
 	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	if (kvm_system_needs_idmapped_vectors() && !has_vhe()) {
+	if (kvm_system_needs_idmapped_vectors() &&
+	    !is_protected_kvm_enabled()) {
 		err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
 					       __BP_HARDEN_HYP_VECS_SZ, &base);
 		if (err)
-- 
2.35.1

