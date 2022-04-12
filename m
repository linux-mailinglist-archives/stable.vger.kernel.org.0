Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FA84FD4A2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355691AbiDLH3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352874AbiDLHOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6757F3137A;
        Mon, 11 Apr 2022 23:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0656FB81B43;
        Tue, 12 Apr 2022 06:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50978C385A1;
        Tue, 12 Apr 2022 06:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746512;
        bh=79S49V6b0/rMojkpv1DYVKJ96IF3SgOqW38WP5Qw2YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lz1ds3huSHQmBgyPbPrEEw2+Z53gFXUPo+R6IfzhqeN+IsbdnSxbRYTeSw5dmaMNm
         lTkoh/DdSLUb0Xweplb/Z7yLuH5DrcE7E+X/4k1vqOp/Da2tAw7hq/MgutKFIYQ90e
         knAcB0816R71QJqE051JCcVlk8OlCQ3TkSnNGoVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 008/285] KVM: x86/emulator: Emulate RDPID only if it is enabled in guest
Date:   Tue, 12 Apr 2022 08:27:45 +0200
Message-Id: <20220412062943.915528084@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
index 5705446c1213..769ba8ffd700 100644
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
index ff181a6c1005..08522041df59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7466,6 +7466,11 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
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
@@ -7548,6 +7553,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_long_mode = emulator_guest_has_long_mode,
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
+	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
-- 
2.35.1



