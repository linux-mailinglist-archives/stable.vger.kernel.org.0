Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FE73E7F49
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhHJRjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhHJRhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:37:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A92C60F11;
        Tue, 10 Aug 2021 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616966;
        bh=Vp727FYbvVTJmQTjmUT3YYRd/B/lgEGQLoRJdbtCGGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFUKstZiFqimqK4zylHdQBG++Q8JtqEwtSTjomN46g/jTqODCCCYJ6hnSBZ7eSJYw
         E1GmM43L6OU2FI/E3ChsObB2MyLwLlF4ze49aHvyGNDM6hr1NDPGLm1rjKUnykHfdx
         ICBnVE8n5ya2IiwxZDI6WFZ3AL7JkoZZ+Qi7cTGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 71/85] KVM: Do not leak memory for duplicate debugfs directories
Date:   Tue, 10 Aug 2021 19:30:44 +0200
Message-Id: <20210810172950.639666479@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
@@ -635,6 +635,8 @@ static void kvm_destroy_vm_debugfs(struc
 
 static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 {
+	static DEFINE_MUTEX(kvm_debugfs_lock);
+	struct dentry *dent;
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	struct kvm_stats_debugfs_item *p;
@@ -643,8 +645,20 @@ static int kvm_create_vm_debugfs(struct
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
@@ -4367,7 +4381,7 @@ static void kvm_uevent_notify_change(uns
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (!IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
+	if (kvm->debugfs_dentry) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
 		if (p) {


