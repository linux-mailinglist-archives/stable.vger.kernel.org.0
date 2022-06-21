Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52924553DBD
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356210AbiFUV00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356200AbiFUVZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8884D31221;
        Tue, 21 Jun 2022 14:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD57615A2;
        Tue, 21 Jun 2022 21:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE30BC341C7;
        Tue, 21 Jun 2022 21:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655846503;
        bh=lcJLfVikcE6BacjIKIxR+IhMbmizwJdM94yRO897bBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uez8YM1ln22OYz0aHQ2hEy/wmpNO94ML4wViGAC2CYOGSh4PYVAW4RMj0mHadWUSW
         DcJfRBIo7srRV+QEeDvE+M+6jtx22tLVF3Ey9pi4rr6UctQEV4pqiam3F414+ErcJ/
         g4nO0zvrR9ttRyypn0BBs0OHGoAd+nWqO1XV0y1E0RYL3BhaSIyD6Gv9YiFDEYAPBn
         aQtXy2uMaJyIx/Y4C6qRlP9aPAARNjoY+AQ56wgu17AREr6lcnWY1nmkEMzuAV/t5y
         R+KLTLhfAxFYdilFB7K4xi9X1bFpS1vbIDiPxo9hr9yFF8F8LMRrePn1D8eQsQ4DI2
         HlnNwgyBnFS/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 2/3] KVM: x86: disable preemption around the call to kvm_arch_vcpu_{un|}blocking
Date:   Tue, 21 Jun 2022 17:21:38 -0400
Message-Id: <20220621212139.251808-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621212139.251808-1-sashal@kernel.org>
References: <20220621212139.251808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 717ee1b2e058..8f88f168012e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3305,9 +3305,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.generic.blocking = 1;
 
+	preempt_disable();
 	kvm_arch_vcpu_blocking(vcpu);
-
 	prepare_to_rcuwait(wait);
+	preempt_enable();
+
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -3317,9 +3319,11 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
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

