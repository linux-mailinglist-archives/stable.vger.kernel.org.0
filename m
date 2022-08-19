Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDFD59A387
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353667AbiHSQrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353895AbiHSQp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FC712A1D0;
        Fri, 19 Aug 2022 09:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C535617A5;
        Fri, 19 Aug 2022 16:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3779FC433D7;
        Fri, 19 Aug 2022 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925475;
        bh=eAffu8N50aZ802sur6aZXX3bo42whdSLVlky8njxA/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCqbwwu6hsHsyVUItzDJDqwtF5NOuOFFGAwE/vRjGip0fs7Q4DwwjMhB5cVBkHCS+
         CE0DUWMLxaBkCwAdh/E4kX/jyE4td2+MoIrGb/dGkSN8DTDOXsckij9z0VxY53AD3q
         5qbnftVpfCiJUhKPDt7Aw1neI90ZPCViLVftd6Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/545] KVM: SVM: Drop VMXE check from svm_set_cr4()
Date:   Fri, 19 Aug 2022 17:44:31 +0200
Message-Id: <20220819153851.904128084@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 311a06593b9a3944a63ed176b95cb8d857f7c83b ]

Drop svm_set_cr4()'s explicit check CR4.VMXE now that common x86 handles
the check by incorporating VMXE into the CR4 reserved bits, via
kvm_cpu_caps.  SVM obviously does not set X86_FEATURE_VMX.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20201007014417.29276-4-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 184e68e7eedf..9bc166a5d453 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1697,9 +1697,6 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
 	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
 
-	if (cr4 & X86_CR4_VMXE)
-		return 1;
-
 	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
 		svm_flush_tlb(vcpu);
 
-- 
2.35.1



