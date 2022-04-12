Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1914FD8E3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356103AbiDLHeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355300AbiDLH1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD1C49250;
        Tue, 12 Apr 2022 00:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBDC5B81A8F;
        Tue, 12 Apr 2022 07:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E16C385A1;
        Tue, 12 Apr 2022 07:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747244;
        bh=o4f5gXCbaB4CQFduw7VkVXm88MSd43BcGFbgkllltIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDt0lbraaGJc8atbTu4YI5M2N9nKrkrdJuxi6rTCWkzsLaJQjV7Bir70/kCVZmT0O
         G0HmwDUTF0SIKVfgP3rn0KyMufLA9ns+fWX9XOKsblZb0HE4yrqYB3IYtbvGT8ihM/
         cWJSl6viH33xX3l3wnbznJRJg5+yxxXeyDWvmOUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 010/343] KVM: x86/emulator: Emulate RDPID only if it is enabled in guest
Date:   Tue, 12 Apr 2022 08:27:08 +0200
Message-Id: <20220412062951.402249565@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
index 02d061a06aa1..de9d8a27387c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3523,8 +3523,10 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
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
index 39eded2426ff..a2a7654d8ace 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -226,6 +226,7 @@ struct x86_emulate_ops {
 	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
+	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6166348c94..c81ec70197fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7675,6 +7675,11 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
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
@@ -7757,6 +7762,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_long_mode = emulator_guest_has_long_mode,
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
+	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
-- 
2.35.1



