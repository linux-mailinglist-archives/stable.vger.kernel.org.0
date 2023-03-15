Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27756BB21B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjCOMdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbjCOMcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA26D9BA4D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1296A61D3E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F218C4339C;
        Wed, 15 Mar 2023 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883512;
        bh=07NYLGJawFW259QlfQ/h3/9ExKNxMJaP24sNumloQ2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zu8BKpjMWPBGPHev2F49I7SRCxJvsQlGm1xrhfrB6pJc1LCiFMb4lhhGVgGFsCFjo
         qoOFLpcvJ8A5bLw1LoMs0Eq08Xe9koYyQJqYqW/M+oPFVtsKW5/s+i7IJ/DC0PDuq4
         rnWuePzSZ+K0cM2LRrJiv0yMklogrZ9VQHnqSajE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/143] KVM: VMX: Dont bother disabling eVMCS static key on module exit
Date:   Wed, 15 Mar 2023 13:11:53 +0100
Message-Id: <20230315115741.334374554@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit da66de44b01e9b7fa09731057593850394bf32e4 ]

Don't disable the eVMCS static key on module exit, kvm_intel.ko owns the
key so there can't possibly be users after the kvm_intel.ko is unloaded,
at least not without much bigger issues.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221130230934.1014142-12-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 87874b22ba4bf..d3d84563a7f9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8465,10 +8465,6 @@ static void vmx_exit(void)
 
 	kvm_exit();
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs))
-		static_branch_disable(&enable_evmcs);
-#endif
 	vmx_cleanup_l1d_flush();
 
 	allow_smaller_maxphyaddr = false;
-- 
2.39.2



