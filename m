Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92FE58DED4
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244994AbiHISYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245720AbiHISWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:22:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DD732058;
        Tue,  9 Aug 2022 11:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EDC3B818C9;
        Tue,  9 Aug 2022 18:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77044C433D7;
        Tue,  9 Aug 2022 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068451;
        bh=u9PreAMLfAZXPuhQcBjbpBtRZ/5+dZ+KdUmxs9Nagbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTTGWX0VU+cfqabt/vVcy48wvWLR2oV8DJorN+yrW2tBFtDplopKiocwUAdh3d/vu
         3ACRM5UOszyKVIkqKv9FlITnoNTWUF36FvlwR2XlEfHSh6eWKTxGsDzdGqydG2bq7Q
         C5IQrYH+fSFUDFsl3/RoZyZl+sW0Lohb3L/Luq34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 14/35] KVM: x86: disable preemption around the call to kvm_arch_vcpu_{un|}blocking
Date:   Tue,  9 Aug 2022 20:00:43 +0200
Message-Id: <20220809175515.577225397@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 18869f26df1a11ed11031dfb7392bc7d774062e8 ]

On SVM, if preemption happens right after the call to finish_rcuwait
but before call to kvm_arch_vcpu_unblocking on SVM/AVIC, it itself
will re-enable AVIC, and then we will try to re-enable it again
in kvm_arch_vcpu_unblocking which will lead to a warning
in __avic_vcpu_load.

The same problem can happen if the vCPU is preempted right after the call
to kvm_arch_vcpu_blocking but before the call to prepare_to_rcuwait
and in this case, we will end up with AVIC enabled during sleep -
Ooops.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220606180829.102503-7-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 24cb37d19c63..7f1d19689701 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3327,9 +3327,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.generic.blocking = 1;
 
+	preempt_disable();
 	kvm_arch_vcpu_blocking(vcpu);
-
 	prepare_to_rcuwait(wait);
+	preempt_enable();
+
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -3339,9 +3341,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		waited = true;
 		schedule();
 	}
-	finish_rcuwait(wait);
 
+	preempt_disable();
+	finish_rcuwait(wait);
 	kvm_arch_vcpu_unblocking(vcpu);
+	preempt_enable();
 
 	vcpu->stat.generic.blocking = 0;
 
-- 
2.35.1



