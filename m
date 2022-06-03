Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3925453D03A
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346057AbiFCSBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346972AbiFCSAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EBBA468;
        Fri,  3 Jun 2022 10:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D312AB82419;
        Fri,  3 Jun 2022 17:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4994BC385B8;
        Fri,  3 Jun 2022 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279015;
        bh=9zj7v1rHX8IEL130KgzECn4tAv637z1ax2CPmS3v65I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1Mafr2YmEeaca2aYxNNDowY1WRYnqwLjCttqoVxHLx90n00hP2gKaa93IVm4pLIX
         8z5a29VuADlvo3ObyeWxkTeilUoXFh1c0TqDWRgZ4z8tagszR/NeONaD4wFay4+9t9
         4HcG/4cU578KAMOS7Xz8QGxgyrPGRhcCHSDgdAhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 25/67] KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest
Date:   Fri,  3 Jun 2022 19:43:26 +0200
Message-Id: <20220603173821.450667939@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
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

From: Yanfei Xu <yanfei.xu@intel.com>

commit ffd1925a596ce68bed7d81c61cb64bc35f788a9d upstream.

When kernel handles the vm-exit caused by external interrupts and NMI,
it always sets kvm_intr_type to tell if it's dealing an IRQ or NMI. For
the PMI scenario, it could be IRQ or NMI.

However, intel_pt PMIs are only generated for HARDWARE perf events, and
HARDWARE events are always configured to generate NMIs.  Use
kvm_handling_nmi_from_guest() to precisely identify if the intel_pt PMI
came from the guest; this avoids false positives if an intel_pt PMI/NMI
arrives while the host is handling an unrelated IRQ VM-Exit.

Fixes: db215756ae59 ("KVM: x86: More precisely identify NMI from guest when handling PMI")
Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
Message-Id: <20220523140821.1345605-1-yanfei.xu@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7856,7 +7856,7 @@ static unsigned int vmx_handle_intel_pt_
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
-	if (!kvm_arch_pmi_in_guest(vcpu))
+	if (!vcpu || !kvm_handling_nmi_from_guest(vcpu))
 		return 0;
 
 	kvm_make_request(KVM_REQ_PMI, vcpu);


