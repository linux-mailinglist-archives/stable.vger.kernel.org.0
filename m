Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA253E81F0
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhHJSEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238081AbhHJSBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:01:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44F36613E6;
        Tue, 10 Aug 2021 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617641;
        bh=F5NLuY5cYUC4pSVKKOzoTdT9SeoUIXt3QoWU+t+O2io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1luMiBm0U1MktrQXSobE30hmYkxIUrzAKW0uoFMrESyms8lOAmTcbBO0wpeqob2ag
         QtvEEBi4JASrnS1P6g1x3ihyncc81k8Gz+OTCBMWoGyJft2/GuHBkFwauq+EPrWKwO
         uH/HLngYXHbcZdiVKLMIdfa2fB2er2fM3sLsNnFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 149/175] KVM: Do not leak memory for duplicate debugfs directories
Date:   Tue, 10 Aug 2021 19:30:57 +0200
Message-Id: <20210810173005.879888740@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 85cd39af14f498f791d8aab3fbd64cd175787f1a upstream.

KVM creates a debugfs directory for each VM in order to store statistics
about the virtual machine.  The directory name is built from the process
pid and a VM fd.  While generally unique, it is possible to keep a
file descriptor alive in a way that causes duplicate directories, which
manifests as these messages:

  [  471.846235] debugfs: Directory '20245-4' with parent 'kvm' already present!

Even though this should not happen in practice, it is more or less
expected in the case of KVM for testcases that call KVM_CREATE_VM and
close the resulting file descriptor repeatedly and in parallel.

When this happens, debugfs_create_dir() returns an error but
kvm_create_vm_debugfs() goes on to allocate stat data structs which are
later leaked.  The slow memory leak was spotted by syzkaller, where it
caused OOM reports.

Since the issue only affects debugfs, do a lookup before calling
debugfs_create_dir, so that the message is downgraded and rate-limited.
While at it, ensure kvm->debugfs_dentry is NULL rather than an error
if it is not created.  This fixes kvm_destroy_vm_debugfs, which was not
checking IS_ERR_OR_NULL correctly.

Cc: stable@vger.kernel.org
Fixes: 536a6f88c49d ("KVM: Create debugfs dir and stat files for each VM")
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -845,6 +845,8 @@ static void kvm_destroy_vm_debugfs(struc
 
 static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 {
+	static DEFINE_MUTEX(kvm_debugfs_lock);
+	struct dentry *dent;
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	struct kvm_stats_debugfs_item *p;
@@ -853,8 +855,20 @@ static int kvm_create_vm_debugfs(struct
 		return 0;
 
 	snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
-	kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
+	mutex_lock(&kvm_debugfs_lock);
+	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
+	if (dent) {
+		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
+		dput(dent);
+		mutex_unlock(&kvm_debugfs_lock);
+		return 0;
+	}
+	dent = debugfs_create_dir(dir_name, kvm_debugfs_dir);
+	mutex_unlock(&kvm_debugfs_lock);
+	if (IS_ERR(dent))
+		return 0;
 
+	kvm->debugfs_dentry = dent;
 	kvm->debugfs_stat_data = kcalloc(kvm_debugfs_num_entries,
 					 sizeof(*kvm->debugfs_stat_data),
 					 GFP_KERNEL_ACCOUNT);
@@ -4993,7 +5007,7 @@ static void kvm_uevent_notify_change(uns
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (!IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
+	if (kvm->debugfs_dentry) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
 		if (p) {


