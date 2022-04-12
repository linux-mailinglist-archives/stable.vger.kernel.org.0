Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE6D4FD157
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351335AbiDLG6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351675AbiDLGyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:54:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8BA3818D;
        Mon, 11 Apr 2022 23:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1F49DCE1C07;
        Tue, 12 Apr 2022 06:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1F7C385A1;
        Tue, 12 Apr 2022 06:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745807;
        bh=2Lmy5BWtN6cg/yToOVXfhNfL68kEcVZK7xgZJjL4nco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYCW3yhBS5EyKcnJIBuqcu5+Oi5vqXETygRPVavx6FUZ724GH+60MjQPDlpYhtL3B
         N0Jp29dunjSZQZ8mXUovN3yBtTwaxXA/Ipj2eAY+N4oyzkW+YGI1AGs45YLtjbKff+
         7gAuVPcOOjVtYMmHcnp71/SqtDiK96mftr+y8Y5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/277] KVM: x86/emulator: Emulate RDPID only if it is enabled in guest
Date:   Tue, 12 Apr 2022 08:26:58 +0200
Message-Id: <20220412062942.478850015@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Upstream commit a836839cbfe60dc434c5476a7429cf2bae36415d ]

When RDTSCP is supported but RDPID is not supported in host,
RDPID emulation is available. However, __kvm_get_msr() would
only fail when RDTSCP/RDPID both are disabled in guest, so
the emulator wouldn't inject a #UD when RDPID is disabled but
RDTSCP is enabled in guest.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Message-Id: <1dfd46ae5b76d3ed87bde3154d51c64ea64c99c1.1646226788.git.houwenlong.hwl@antgroup.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c     | 4 +++-
 arch/x86/kvm/kvm_emulate.h | 1 +
 arch/x86/kvm/x86.c         | 6 ++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4cf0938a876b..3747a754a8e8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3514,8 +3514,10 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
 {
 	u64 tsc_aux = 0;
 
-	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
+	if (!ctxt->ops->guest_has_rdpid(ctxt))
 		return emulate_ud(ctxt);
+
+	ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux);
 	ctxt->dst.val = tsc_aux;
 	return X86EMUL_CONTINUE;
 }
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 68b420289d7e..fb09cd22cb7f 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -226,6 +226,7 @@ struct x86_emulate_ops {
 	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
+	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e606a6940dc..5e2983959f23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7393,6 +7393,11 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
 	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
 }
 
+static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
+{
+	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
+}
+
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
 	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
@@ -7475,6 +7480,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_long_mode = emulator_guest_has_long_mode,
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
+	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
-- 
2.35.1



