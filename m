Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3359A3D3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354194AbiHSQwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354298AbiHSQu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:50:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFA261B3B;
        Fri, 19 Aug 2022 09:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D451361639;
        Fri, 19 Aug 2022 16:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36CEC433B5;
        Fri, 19 Aug 2022 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925556;
        bh=2/YALaMmrtWmw+s05ln27A5qnqtodnnGoEfuqoTYaEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thzEO7z5gYzzb382p8tCldX3Vwh+YdrG4HaWsdNpGBz0Y2bLCzD78uBM8HelDgAdZ
         3IeTWwn1pUGbKvcyQU6UI6nxKdYDRXBdWCeaH4/dMD3jYXkTJZ/eabkQvv3K5g8QsH
         TBc3Q74uNwLlzb4+wZ4x/tyXhBlQ2HwWdovmhjJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 528/545] KVM: Add infrastructure and macro to mark VM as bugged
Date:   Fri, 19 Aug 2022 17:44:58 +0200
Message-Id: <20220819153853.192788258@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 0b8f11737cffc1a406d1134b58687abc29d76b52 upstream

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <3a0998645c328bf0895f1290e61821b70f048549.1625186503.git.isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[SG: Adjusted context for kernel version 5.10]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |   28 +++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      |   10 +++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -146,6 +146,7 @@ static inline bool is_error_page(struct
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -505,6 +506,7 @@ struct kvm {
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
+	bool vm_bugged;
 };
 
 #define kvm_err(fmt, ...) \
@@ -533,6 +535,31 @@ struct kvm {
 #define vcpu_err(vcpu, fmt, ...)					\
 	kvm_err("vcpu%i " fmt, (vcpu)->vcpu_id, ## __VA_ARGS__)
 
+bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
+static inline void kvm_vm_bugged(struct kvm *kvm)
+{
+	kvm->vm_bugged = true;
+	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_BUGGED);
+}
+
+#define KVM_BUG(cond, kvm, fmt...)				\
+({								\
+	int __ret = (cond);					\
+								\
+	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
+		kvm_vm_bugged(kvm);				\
+	unlikely(__ret);					\
+})
+
+#define KVM_BUG_ON(cond, kvm)					\
+({								\
+	int __ret = (cond);					\
+								\
+	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
+		kvm_vm_bugged(kvm);				\
+	unlikely(__ret);					\
+})
+
 static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
 {
 	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
@@ -850,7 +877,6 @@ void *kvm_mmu_memory_cache_alloc(struct
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
-bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except);
 bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3264,7 +3264,7 @@ static long kvm_vcpu_ioctl(struct file *
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
@@ -3470,7 +3470,7 @@ static long kvm_vcpu_compat_ioctl(struct
 	void __user *argp = compat_ptr(arg);
 	int r;
 
-	if (vcpu->kvm->mm != current->mm)
+	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3536,7 +3536,7 @@ static long kvm_device_ioctl(struct file
 {
 	struct kvm_device *dev = filp->private_data;
 
-	if (dev->kvm->mm != current->mm)
+	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
 		return -EIO;
 
 	switch (ioctl) {
@@ -3755,7 +3755,7 @@ static long kvm_vm_ioctl(struct file *fi
 	void __user *argp = (void __user *)arg;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
@@ -3960,7 +3960,7 @@ static long kvm_vm_compat_ioctl(struct f
 	struct kvm *kvm = filp->private_data;
 	int r;
 
-	if (kvm->mm != current->mm)
+	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT


