Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135EF521B28
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244869AbiEJOIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242960AbiEJOFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:05:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D012E1830;
        Tue, 10 May 2022 06:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20970B81038;
        Tue, 10 May 2022 13:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE01C385A6;
        Tue, 10 May 2022 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190049;
        bh=Mlz60deRt36HdXJ7XN/igo+0gnVNPamU0Zlo9kbZ+Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TevuN/KiGMwxP5XpVf5ienSCEMN/XwCgaJXkYUHmdGpSVXzcHv7jh1zlEa14l3SZc
         klm4aYeoEC8I+471aUL4iHQaSd9FIBo/HxmlRTrIdGbUNzLMGb9QT265fS/ZvJ53w6
         pYtTaeb3fxj4Oy7zPB4FKamuZEzvqBJBvgi4yHko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 112/140] KVM: VMX: Exit to userspace if vCPU has injected exception and invalid state
Date:   Tue, 10 May 2022 15:08:22 +0200
Message-Id: <20220510130744.805207869@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 053d2290c0307e3642e75e0185ddadf084dc36c1 ]

Exit to userspace with an emulation error if KVM encounters an injected
exception with invalid guest state, in addition to the existing check of
bailing if there's a pending exception (KVM doesn't support emulating
exceptions except when emulating real mode via vm86).

In theory, KVM should never get to such a situation as KVM is supposed to
exit to userspace before injecting an exception with invalid guest state.
But in practice, userspace can intervene and manually inject an exception
and/or stuff registers to force invalid guest state while a previously
injected exception is awaiting reinjection.

Fixes: fc4fad79fc3d ("KVM: VMX: Reject KVM_RUN if emulation is required with pending exception")
Reported-by: syzbot+cfafed3bb76d3e37581b@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220502221850.131873-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef63cfd57029..267d6dc4b818 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5473,7 +5473,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	return vmx->emulation_required && !vmx->rmode.vm86_active &&
-	       vcpu->arch.exception.pending;
+	       (vcpu->arch.exception.pending || vcpu->arch.exception.injected);
 }
 
 static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
-- 
2.35.1



