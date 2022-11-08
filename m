Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92148621460
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiKHOAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbiKHOAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:00:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3830968683
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:00:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE1F3B81AFB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07259C433C1;
        Tue,  8 Nov 2022 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916031;
        bh=qUxqSB/+vuYXRCbV+lIwH6RZXgs0lNmdw2afFdNDZsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AaN6IR4ELl7btcYlxTxt9sX+SCOchWJ1Of8szOu/NLpdQdXmncbUMGjXO8LNwG7q
         aPl60VuSZ3qhANPC3O3xwdY+EwEfooNKFiborzY67L8VTB4U6r03WlHFRkS3KdfBV4
         HNCjeRRZtBJRKHu/fdcm1ZtVryXIOawq8oRu+4hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andrew Randrianasulu <randrianasulu@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/144] KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER
Date:   Tue,  8 Nov 2022 14:38:09 +0100
Message-Id: <20221108133345.838488057@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

[ Upstream commit 1739c7017fb1d759965dcbab925ff5980a5318cb ]

The KVM_X86_SET_MSR_FILTER ioctls contains a pointer in the passed in
struct which means it has a different struct size depending on whether
it gets called from 32bit or 64bit code.

This patch introduces compat code that converts from the 32bit struct to
its 64bit counterpart which then gets used going forward internally.
With this applied, 32bit QEMU can successfully set MSR bitmaps when
running on 64bit kernels.

Reported-by: Andrew Randrianasulu <randrianasulu@gmail.com>
Fixes: 1a155254ff937 ("KVM: x86: Introduce MSR filtering")
Signed-off-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221017184541.2658-4-graf@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d165f793f44..ec2a37ba07e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5942,6 +5942,62 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	return 0;
 }
 
+#ifdef CONFIG_KVM_COMPAT
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range_compat {
+	__u32 flags;
+	__u32 nmsrs;
+	__u32 base;
+	__u32 bitmap;
+};
+
+struct kvm_msr_filter_compat {
+	__u32 flags;
+	struct kvm_msr_filter_range_compat ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
+
+#define KVM_X86_SET_MSR_FILTER_COMPAT _IOW(KVMIO, 0xc6, struct kvm_msr_filter_compat)
+
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct kvm *kvm = filp->private_data;
+	long r = -ENOTTY;
+
+	switch (ioctl) {
+	case KVM_X86_SET_MSR_FILTER_COMPAT: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter_compat filter_compat;
+		struct kvm_msr_filter filter;
+		int i;
+
+		if (copy_from_user(&filter_compat, user_msr_filter,
+				   sizeof(filter_compat)))
+			return -EFAULT;
+
+		filter.flags = filter_compat.flags;
+		for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
+			struct kvm_msr_filter_range_compat *cr;
+
+			cr = &filter_compat.ranges[i];
+			filter.ranges[i] = (struct kvm_msr_filter_range) {
+				.flags = cr->flags,
+				.nmsrs = cr->nmsrs,
+				.base = cr->base,
+				.bitmap = (__u8 *)(ulong)cr->bitmap,
+			};
+		}
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
+		break;
+	}
+	}
+
+	return r;
+}
+#endif
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 static int kvm_arch_suspend_notifier(struct kvm *kvm)
 {
-- 
2.35.1



