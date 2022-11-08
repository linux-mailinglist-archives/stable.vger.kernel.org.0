Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11C062139F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiKHNw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbiKHNwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF08623A1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4791EB81AA1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5E3C433D6;
        Tue,  8 Nov 2022 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915512;
        bh=lO9KHnR1eK+WhTOgc6hh6Zqv4KFXl7Z1YsOqHADkPc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwkUMIs+oOBzLJQT6ns2p4T8OXqG26uW1HgwntkVlpGasXow61Wox32I/Z9kmyiT9
         P7mxzfP3+d2KQn5JUOoGxUnNDHISIVml0HJvyJBsmrv1JCAyM7887FQ0NwZ6RPRav6
         0GM9cUBW2wOsA5KTCGSgBiJNHp49Qg4HDvbelvHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/118] KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()
Date:   Tue,  8 Nov 2022 14:38:09 +0100
Message-Id: <20221108133341.200767239@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Graf <graf@amazon.com>

[ Upstream commit 2e3272bc1790825c43d2c39690bf2836b81c6d36 ]

In the next patch we want to introduce a second caller to
set_msr_filter() which constructs its own filter list on the stack.
Refactor the original function so it takes it as argument instead of
reading it through copy_from_user().

Signed-off-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221017184541.2658-3-graf@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed8efd402d05..be4326b143e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5446,26 +5446,22 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	return r;
 }
 
-static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
+static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
+				       struct kvm_msr_filter *filter)
 {
-	struct kvm_msr_filter __user *user_msr_filter = argp;
 	struct kvm_x86_msr_filter *new_filter, *old_filter;
-	struct kvm_msr_filter filter;
 	bool default_allow;
 	bool empty = true;
 	int r = 0;
 	u32 i;
 
-	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
-		return -EFAULT;
-
-	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
+	if (filter->flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
-		empty &= !filter.ranges[i].nmsrs;
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++)
+		empty &= !filter->ranges[i].nmsrs;
 
-	default_allow = !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
+	default_allow = !(filter->flags & KVM_MSR_FILTER_DEFAULT_DENY);
 	if (empty && !default_allow)
 		return -EINVAL;
 
@@ -5473,8 +5469,8 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (!new_filter)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
-		r = kvm_add_msr_filter(new_filter, &filter.ranges[i]);
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++) {
+		r = kvm_add_msr_filter(new_filter, &filter->ranges[i]);
 		if (r) {
 			kvm_free_msr_filter(new_filter);
 			return r;
@@ -5803,9 +5799,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
-	case KVM_X86_SET_MSR_FILTER:
-		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
+	case KVM_X86_SET_MSR_FILTER: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter filter;
+
+		if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
+			return -EFAULT;
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
 		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
-- 
2.35.1



