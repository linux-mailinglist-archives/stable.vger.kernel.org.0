Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749D460E422
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiJZPIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiJZPIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5539125009
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83B39B822F6
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF58AC433C1;
        Wed, 26 Oct 2022 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796926;
        bh=GqH8CU5wDH7rWNLUjAwkgas/nIoAC6beJK24Im8xtcg=;
        h=Subject:To:Cc:From:Date:From;
        b=ZK3HDPCFo6M+ymzGJsxhYPTufp1/DUwadYq5hL41cqHoRmHyxvk/LX82j4cLgO87Q
         ctXxfkfhnKyO/DV58uwqRVv5MczLYJDHfmjHumbvNW4V60HLc6JA+3gLDMKoLK4O55
         qaa0+6Y/ekU6eaMyteKu85EHT3HLXOKhVpmGmAjw=
Subject: FAILED: patch "[PATCH] KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER" failed to apply to 5.10-stable tree
To:     graf@amazon.com, pbonzini@redhat.com, randrianasulu@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:08:41 +0200
Message-ID: <1666796921121176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1739c7017fb1 ("KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER")
7d62874f69d7 ("kvm: x86: implement KVM PM-notifier")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1739c7017fb1d759965dcbab925ff5980a5318cb Mon Sep 17 00:00:00 2001
From: Alexander Graf <graf@amazon.com>
Date: Mon, 17 Oct 2022 20:45:41 +0200
Subject: [PATCH] KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER

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

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 78f779f0264b..9cf1ba865562 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6489,6 +6489,62 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
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

