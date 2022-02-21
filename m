Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EB14BE5C6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348975AbiBUJX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350189AbiBUJWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:22:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3421B37A9E;
        Mon, 21 Feb 2022 01:09:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3C9660B23;
        Mon, 21 Feb 2022 09:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A636FC36AE7;
        Mon, 21 Feb 2022 09:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434575;
        bh=o5gkH2Xv/3W6KkrbX56TKpiDHWD1wxf42jM4NdYGyi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dotv4y9wwu5uCCDgdqbUZSXvPTH+pChaP25DrUOZLK1wdSh7VTXfNFPmeYuuSHf/Y
         1E0+Tsu5xIdlQZfulpOTNPIxZjUsCFEjqID5XWLaRFRlgeUdvqLnPzzjHDIL0cYr0k
         uvgT2gFYXJA+l+xED04VWch7a4wdVSbMmZAbmRdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 056/196] KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM
Date:   Mon, 21 Feb 2022 09:48:08 +0100
Message-Id: <20220221084932.808896029@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 759cbd59674a6c0aec616a3f4f0740ebd3f5fbef upstream.

While RSM induced VM entries are not full VM entries,
they still need to be followed by actual VM entry to complete it,
unlike setting the nested state.

This patch fixes boot of hyperv and SMM enabled
windows VM running nested on KVM, which fail due
to this issue combined with lack of dirty bit setting.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Message-Id: <20220207155447.840194-5-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    5 +++++
 arch/x86/kvm/vmx/vmx.c |    1 +
 2 files changed, 6 insertions(+)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4388,6 +4388,11 @@ static int svm_leave_smm(struct kvm_vcpu
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
 
+	if (ret)
+		goto unmap_save;
+
+	svm->nested.nested_run_pending = 1;
+
 unmap_save:
 	kvm_vcpu_unmap(vcpu, &map_save, true);
 unmap_map:
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7532,6 +7532,7 @@ static int vmx_leave_smm(struct kvm_vcpu
 		if (ret)
 			return ret;
 
+		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
 	return 0;


