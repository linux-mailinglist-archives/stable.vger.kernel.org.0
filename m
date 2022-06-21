Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028E9553DBC
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356498AbiFUV0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356371AbiFUVZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFD830F79;
        Tue, 21 Jun 2022 14:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBD50615B2;
        Tue, 21 Jun 2022 21:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B21C341C8;
        Tue, 21 Jun 2022 21:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655846496;
        bh=lA4cyhfT4WUz1YeN3u1XI6CDz0PBEt6aK1piNZIeHX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg774vFbzk1wYIMavp9/wfOk527BAZSDUkJY24T8EonsNGADY6Ff+eWav+aUcuI1T
         e/m/Eds+31Dr+qSxWBwMXnYGmXq8OD+VHzx6nHWfMboMD4OeFm6c86EDijzU4sTJV/
         K16cV0sxP3BZS+ojVnSgn0tnuGVXv+N4JwHrnwkAKb0Em0IlD6H3jyNJInwXRokiKI
         JE263Xd09eFAyl5/NvxQ6WWVpN9kZxNJsHZh0fItsq7nwqj7dPzYOvaHxSpmmKAe7p
         W3B/+ZWC9zLYGE/CiZNlKsYhInIZokbOxW1clUCnNaoGIS9ZZ6dGoy+TkxuDyUlwwC
         t8tgOWkCwy/yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.18 2/3] KVM: x86: disable preemption around the call to kvm_arch_vcpu_{un|}blocking
Date:   Tue, 21 Jun 2022 17:21:31 -0400
Message-Id: <20220621212132.251759-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621212132.251759-1-sashal@kernel.org>
References: <20220621212132.251759-1-sashal@kernel.org>
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
index 5ab12214e18d..a11a1df2b71f 100644
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

