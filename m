Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2C64D8109
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbiCNLim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239449AbiCNLiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:38:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BC542EE0;
        Mon, 14 Mar 2022 04:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9E1C61129;
        Mon, 14 Mar 2022 11:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C330EC340E9;
        Mon, 14 Mar 2022 11:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257806;
        bh=NAE/jrntuLBZjsuZFCoWtWePh6W77x6Eb4oniNrpQE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOzqo1pJaGAo90Wcco8e6EXdKaz2VCw+5xnJS8n3PSQyIU6ZYiEP0XcpbeSmrsw4b
         XepbqFF59MYwpyh3a3oaXeT1VM7PBbo9nN8UbCYuDWqFaSfRPTjO89mlLdYUfRUc66
         lIrtaHyHc6b42ZUdATRpw3+tE2t0emRroIjMlbH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 18/23] KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU
Date:   Mon, 14 Mar 2022 12:34:31 +0100
Message-Id: <20220314112731.584887676@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.050583127@linuxfoundation.org>
References: <20220314112731.050583127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

The logic in commit 2a5f1b67ec57 "KVM: arm64: Don't access PMCR_EL0 when no
PMU is available" relies on an empty reset handler being benign.  This was
not the case in earlier kernel versions, so the stable backport of this
patch is causing problems.

KVMs behaviour in this area changed over time. In particular, prior to commit
03fdfb269009 ("KVM: arm64: Don't write junk to sysregs on reset"), an empty
reset handler will trigger a warning, as the guest registers have been
poisoned.
Prior to commit 20589c8cc47d ("arm/arm64: KVM: Don't panic on failure to
properly reset system registers"), this warning was a panic().

Instead of reverting the backport, make it write 0 to the sys_reg[] array.
This keeps the reset logic happy, and the dodgy value can't be seen by
the guest as it can't request the emulation.

The original bug was accessing the PMCR_EL0 register on CPUs that don't
implement that feature. There is no known silicon that does this, but
v4.9's ACPI support is unable to find the PMU, so triggers this code:

| Kernel panic - not syncing: Didn't reset vcpu_sys_reg(24)
| CPU: 1 PID: 3055 Comm: lkvm Not tainted 4.9.302-00032-g64e078a56789 #13476
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Jul 30 2018
| Call trace:
| [<ffff00000808b4b0>] dump_backtrace+0x0/0x1a0
| [<ffff00000808b664>] show_stack+0x14/0x20
| [<ffff0000088f0e18>] dump_stack+0x98/0xb8
| [<ffff0000088eef08>] panic+0x118/0x274
| [<ffff0000080b50e0>] access_actlr+0x0/0x20
| [<ffff0000080b2620>] kvm_reset_vcpu+0x5c/0xac
| [<ffff0000080ac688>] kvm_arch_vcpu_ioctl+0x3e4/0x490
| [<ffff0000080a382c>] kvm_vcpu_ioctl+0x5b8/0x720
| [<ffff000008201e44>] do_vfs_ioctl+0x2f4/0x884
| [<ffff00000820244c>] SyS_ioctl+0x78/0x9c
| [<ffff000008083a9c>] __sys_trace_return+0x0/0x4

Cc: <stable@vger.kernel.org> # < v5.3 with 2a5f1b67ec57 backported
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -471,8 +471,10 @@ static void reset_pmcr(struct kvm_vcpu *
 	u64 pmcr, val;
 
 	/* No PMU available, PMCR_EL0 may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
+	if (!kvm_arm_support_pmu_v3()) {
+		vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
 		return;
+	}
 
 	pmcr = read_sysreg(pmcr_el0);
 	/*


