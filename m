Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EB03E4415
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhHIKpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234600AbhHIKp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 06:45:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A45061055;
        Mon,  9 Aug 2021 10:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628505907;
        bh=BmlGLuaWsR9xvAGjRDS1BUzg1jGMlmqqS0hMQNWJ9II=;
        h=Subject:To:Cc:From:Date:From;
        b=LSOLWDgsUZHasR5HEPMknBJoUos71Ky2zvr7GAHycUN2UKyvvr7JqXxNbRQvMPryv
         T21vIHVj2M/uTsXDN1H6GSwe317ceD5VITHbxAhT1eCfYeRND8UVgZ9K+I0uEoMkGu
         /IvD+AU6T98hQMTmTmqkfr9T5nM1EVmxl+6w4/q0=
Subject: FAILED: patch "[PATCH] KVM: Do not leak memory for duplicate debugfs directories" failed to apply to 4.14-stable tree
To:     pbonzini@redhat.com, aik@ozlabs.ru, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 12:44:57 +0200
Message-ID: <1628505897233183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85cd39af14f498f791d8aab3fbd64cd175787f1a Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 4 Aug 2021 05:28:52 -0400
Subject: [PATCH] KVM: Do not leak memory for duplicate debugfs directories

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

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d20fba0fc290..b50dbe269f4b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -892,6 +892,8 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 
 static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 {
+	static DEFINE_MUTEX(kvm_debugfs_lock);
+	struct dentry *dent;
 	char dir_name[ITOA_MAX_LEN * 2];
 	struct kvm_stat_data *stat_data;
 	const struct _kvm_stats_desc *pdesc;
@@ -903,8 +905,20 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
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
@@ -5201,7 +5215,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (!IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
+	if (kvm->debugfs_dentry) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
 		if (p) {

