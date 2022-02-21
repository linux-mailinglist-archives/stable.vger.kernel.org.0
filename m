Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3C84BDED5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbiBUJth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352950AbiBUJsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C435BC80;
        Mon, 21 Feb 2022 01:21:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E3E60B1E;
        Mon, 21 Feb 2022 09:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27D5C340F0;
        Mon, 21 Feb 2022 09:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435303;
        bh=rB4nAhkTCwWmazNpxyjwfP2TsWxjP1bB4Ig9i3tECL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUuf/EvHe12phvrKvBhvFXxIr+cuogU2japC9DLu+Dh1c40I1VF9UNrv7bpB04ihD
         MQSu3AzT9CcgWqvRXWvNc7a9++A0tY5aNspRC3pbz3rmT26H3TNObMsasKq72bK02c
         KvmLsyhs4Tk8VqvbshQ+M46REcQzc5w2hLXazP2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 074/227] KVM: x86: nSVM: fix potential NULL derefernce on nested migration
Date:   Mon, 21 Feb 2022 09:48:13 +0100
Message-Id: <20220221084937.327978665@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

commit e1779c2714c3023e4629825762bcbc43a3b943df upstream.

Turns out that due to review feedback and/or rebases
I accidentally moved the call to nested_svm_load_cr3 to be too early,
before the NPT is enabled, which is very wrong to do.

KVM can't even access guest memory at that point as nested NPT
is needed for that, and of course it won't initialize the walk_mmu,
which is main issue the patch was addressing.

Fix this for real.

Fixes: 232f75d3b4b5 ("KVM: nSVM: call nested_svm_load_cr3 on nested state load")
Cc: stable@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220207155447.840194-3-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1389,18 +1389,6 @@ static int svm_set_nested_state(struct k
 	    !nested_vmcb_valid_sregs(vcpu, save))
 		goto out_free;
 
-	/*
-	 * While the nested guest CR3 is already checked and set by
-	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
-	 * thus MMU might not be initialized correctly.
-	 * Set it again to fix this.
-	 */
-
-	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
-				  nested_npt_enabled(svm), false);
-	if (WARN_ON_ONCE(ret))
-		goto out_free;
-
 
 	/*
 	 * All checks done, we can enter guest mode. Userspace provides
@@ -1426,6 +1414,20 @@ static int svm_set_nested_state(struct k
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
+
+	/*
+	 * While the nested guest CR3 is already checked and set by
+	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
+	 * thus MMU might not be initialized correctly.
+	 * Set it again to fix this.
+	 */
+
+	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
+				  nested_npt_enabled(svm), false);
+	if (WARN_ON_ONCE(ret))
+		goto out_free;
+
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:


