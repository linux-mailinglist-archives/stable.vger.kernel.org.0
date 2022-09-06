Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D664F5AEACB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbiIFNub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238860AbiIFNss (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:48:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172B4DFD;
        Tue,  6 Sep 2022 06:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1EC3CE1784;
        Tue,  6 Sep 2022 13:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F79EC433D7;
        Tue,  6 Sep 2022 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471506;
        bh=i98bJPSeOuw8uj/R1OlKRdizQGOKmkgeHdQdCv/tCFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJJcv3ZQaH9g7+nax+aA4gotUnDXvab3LNZCpmICWRRKGmpP0/nDoBq684b/bXyhl
         1mepQNbMYvBEHCK/UimMXC63uX0WPQCHFrS4h5ecpU2zYbaZIAaughLtyNqb6VRMJW
         Y+VCbLy4+GE2KSkvPvC9FT+WZKEym15yNmhZ6Ib0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/107] KVM: VMX: Heed the msr argument in msr_write_intercepted()
Date:   Tue,  6 Sep 2022 15:30:30 +0200
Message-Id: <20220906132823.919723954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 020dac4187968535f089f83f376a72beb3451311 ]

Regardless of the 'msr' argument passed to the VMX version of
msr_write_intercepted(), the function always checks to see if a
specific MSR (IA32_SPEC_CTRL) is intercepted for write.  This behavior
seems unintentional and unexpected.

Modify the function so that it checks to see if the provided 'msr'
index is intercepted for write.

Fixes: 67f4b9969c30 ("KVM: nVMX: Handle dynamic MSR intercept toggling")
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220810213050.2655000-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cfb3a5c809f2e..e5584e974c774 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -831,8 +831,7 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
-	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
-					 MSR_IA32_SPEC_CTRL);
+	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap, msr);
 }
 
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
-- 
2.35.1



