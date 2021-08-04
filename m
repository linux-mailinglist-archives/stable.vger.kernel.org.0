Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B563DFE1B
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 11:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhHDJh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 05:37:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237090AbhHDJhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 05:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628069862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K7GiN8GAhFqidnlxumxy327KJdvl+R/HW14HWrxH9/E=;
        b=gM7tIdm3RX6nLUavl1vVqKnfLiUYkggUHKmgKLNrde0HWt8u76IyI8Cd8/dG3ENE31JkKo
        PFG81blwXW/ft89LmHyyhuTpz6D2orwElQumwa2kXF1gOfOS2+NgcDPl0XPvVCOk94kW9L
        BZPfbckCTD/5VN9sGBg41HDBXKtmrDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-1X5qspqTOt-y-88AB8yFaQ-1; Wed, 04 Aug 2021 05:37:41 -0400
X-MC-Unique: 1X5qspqTOt-y-88AB8yFaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8146D101AFB5;
        Wed,  4 Aug 2021 09:37:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F57060C9F;
        Wed,  4 Aug 2021 09:37:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] KVM: Do not leak memory for duplicate debugfs directories
Date:   Wed,  4 Aug 2021 05:37:37 -0400
Message-Id: <20210804093737.2536206-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

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
-- 
2.27.0

