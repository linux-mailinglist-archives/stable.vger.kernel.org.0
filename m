Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360015AECE7
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbiIFOKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbiIFOJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897BF86709;
        Tue,  6 Sep 2022 06:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB52A61542;
        Tue,  6 Sep 2022 13:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3E3C433D7;
        Tue,  6 Sep 2022 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471914;
        bh=svzu77QzBr7n+Z6FfX+gYDRJpyNzc5laxHxOlpe9jpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYL6ypgLeX+mAfwc7k6s1Zvqja64WcYD42vRX8u8bxlXxUlqMX6xfV3nod1oD+576
         yOuUar85YyGu255DwYsOn/lHD/AR6HXOfs76+8J7kS2gA4btYscXydP3TvlopNinLZ
         SgsTJFkF/+v/3vC7dDqsqE4NMQHonARvc/GYw0L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 083/155] KVM: VMX: Heed the msr argument in msr_write_intercepted()
Date:   Tue,  6 Sep 2022 15:30:31 +0200
Message-Id: <20220906132832.941238062@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
index 0aaea87a14597..b09a50e0af29d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -835,8 +835,7 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
-	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
-					 MSR_IA32_SPEC_CTRL);
+	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap, msr);
 }
 
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
-- 
2.35.1



