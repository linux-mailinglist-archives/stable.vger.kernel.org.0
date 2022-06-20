Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0557F551D49
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348324AbiFTNuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349207AbiFTNsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AF92F03C;
        Mon, 20 Jun 2022 06:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B677CB811D3;
        Mon, 20 Jun 2022 13:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B197C3411B;
        Mon, 20 Jun 2022 13:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730232;
        bh=GD3PVsNA3YlhsK3Y2k4Oij5ixJFDcOnzgl9lnBFqP4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T61GLVhl68nLt5XHQeByzyb3jSg0nNIfkx9D26YFbvslKHTXBP9eWLimCMGNIhQ2g
         /xEibKATX2wpqBgjGRijlL58Y/H5J2WoH4HRMX4POJwgKFVZHnlcMkQYl0X+CJBYt1
         l8u1kcGwloKwM/tEje6+nScRDxV+zJqT7BCvf8yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 74/84] KVM: x86: Account a variety of miscellaneous allocations
Date:   Mon, 20 Jun 2022 14:51:37 +0200
Message-Id: <20220620124723.078679722@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit eba04b20e4861d9bdbd8470a13c0c6e824521a36 upstream.

Switch to GFP_KERNEL_ACCOUNT for a handful of allocations that are
clearly associated with a single task/VM.

Note, there are a several SEV allocations that aren't accounted, but
those can (hopefully) be fixed by using the local stack for memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210331023025.2485960-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    4 ++--
 arch/x86/kvm/svm/sev.c    |    2 +-
 arch/x86/kvm/vmx/vmx.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1198,8 +1198,8 @@ static int svm_set_nested_state(struct k
 		return -EINVAL;
 
 	ret  = -ENOMEM;
-	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
-	save = kzalloc(sizeof(*save), GFP_KERNEL);
+	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL_ACCOUNT);
+	save = kzalloc(sizeof(*save), GFP_KERNEL_ACCOUNT);
 	if (!ctl || !save)
 		goto out_free;
 
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -537,7 +537,7 @@ static int sev_launch_measure(struct kvm
 		}
 
 		ret = -ENOMEM;
-		blob = kmalloc(params.len, GFP_KERNEL);
+		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			goto e_free;
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -619,7 +619,7 @@ static int hv_enable_direct_tlbflush(str
 	 * evmcs in singe VM shares same assist page.
 	 */
 	if (!*p_hv_pa_pg)
-		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 
 	if (!*p_hv_pa_pg)
 		return -ENOMEM;


