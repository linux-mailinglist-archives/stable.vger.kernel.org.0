Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780496ABD63
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCFKx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCFKx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:53:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112064496
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:53:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A008960DDC
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72B5C433D2;
        Mon,  6 Mar 2023 10:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678100006;
        bh=ayBRPqvaUtFOMYv9DWSgY8+FdqP8Gc2msC46CK7hp54=;
        h=Subject:To:Cc:From:Date:From;
        b=dAB5xWpf0893jOrzfHh++fZdCv7ITF0ZH0INRHRLUPMEd8Kt5UR83Y6EENnsnd37D
         6SddmlJBdUDBPmkH7PBQ1VdH9o8ezYBMvugQX8i3c3elr3RZue2U6hsDC3DPHuDCSQ
         er5vRWej5kUjq3jloAoV5cZnNjiJ4H//AI7vC0eI=
Subject: FAILED: patch "[PATCH] KVM: s390: disable migration mode when dirty tracking is" failed to apply to 5.15-stable tree
To:     nrb@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:53:23 +0100
Message-ID: <16781000032425@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x f2d3155e2a6bac44d16f04415a321e8707d895c6
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16781000032425@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

f2d3155e2a6b ("KVM: s390: disable migration mode when dirty tracking is disabled")
ec5c86976674 ("KVM: s390: Skip gfn/size sanity checks on memslot DELETE or FLAGS_ONLY")
cf5b486922dc ("KVM: s390: Use "new" memslot instead of userspace memory region")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f2d3155e2a6bac44d16f04415a321e8707d895c6 Mon Sep 17 00:00:00 2001
From: Nico Boehr <nrb@linux.ibm.com>
Date: Fri, 27 Jan 2023 15:05:32 +0100
Subject: [PATCH] KVM: s390: disable migration mode when dirty tracking is
 disabled

Migration mode is a VM attribute which enables tracking of changes in
storage attributes (PGSTE). It assumes dirty tracking is enabled on all
memslots to keep a dirty bitmap of pages with changed storage attributes.

When enabling migration mode, we currently check that dirty tracking is
enabled for all memslots. However, userspace can disable dirty tracking
without disabling migration mode.

Since migration mode is pointless with dirty tracking disabled, disable
migration mode whenever userspace disables dirty tracking on any slot.

Also update the documentation to clarify that dirty tracking must be
enabled when enabling migration mode, which is already enforced by the
code in kvm_s390_vm_start_migration().

Also highlight in the documentation for KVM_S390_GET_CMMA_BITS that it
can now fail with -EINVAL when dirty tracking is disabled while
migration mode is on. Move all the error codes to a table so this stays
readable.

To disable migration mode, slots_lock should be held, which is taken
in kvm_set_memory_region() and thus held in
kvm_arch_prepare_memory_region().

Restructure the prepare code a bit so all the sanity checking is done
before disabling migration mode. This ensures migration mode isn't
disabled when some sanity check fails.

Cc: stable@vger.kernel.org
Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migration mode")
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230127140532.230651-2-nrb@linux.ibm.com
Message-Id: <20230127140532.230651-2-nrb@linux.ibm.com>
[frankja@linux.ibm.com: fixed commit message typo, moved api.rst error table upwards]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index deb494f759ed..8cd7fd05d53b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4449,6 +4449,18 @@ not holding a previously reported uncorrected error).
 :Parameters: struct kvm_s390_cmma_log (in, out)
 :Returns: 0 on success, a negative value on error
 
+Errors:
+
+  ======     =============================================================
+  ENOMEM     not enough memory can be allocated to complete the task
+  ENXIO      if CMMA is not enabled
+  EINVAL     if KVM_S390_CMMA_PEEK is not set but migration mode was not enabled
+  EINVAL     if KVM_S390_CMMA_PEEK is not set but dirty tracking has been
+             disabled (and thus migration mode was automatically disabled)
+  EFAULT     if the userspace address is invalid or if no page table is
+             present for the addresses (e.g. when using hugepages).
+  ======     =============================================================
+
 This ioctl is used to get the values of the CMMA bits on the s390
 architecture. It is meant to be used in two scenarios:
 
@@ -4529,12 +4541,6 @@ mask is unused.
 
 values points to the userspace buffer where the result will be stored.
 
-This ioctl can fail with -ENOMEM if not enough memory can be allocated to
-complete the task, with -ENXIO if CMMA is not enabled, with -EINVAL if
-KVM_S390_CMMA_PEEK is not set but migration mode was not enabled, with
--EFAULT if the userspace address is invalid or if no page table is
-present for the addresses (e.g. when using hugepages).
-
 4.108 KVM_S390_SET_CMMA_BITS
 ----------------------------
 
diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 60acc39e0e93..147efec626e5 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -302,6 +302,10 @@ Allows userspace to start migration mode, needed for PGSTE migration.
 Setting this attribute when migration mode is already active will have
 no effects.
 
+Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
+dirty tracking is disabled on any memslot, migration mode is automatically
+stopped.
+
 :Parameters: none
 :Returns:   -ENOMEM if there is not enough free memory to start migration mode;
 	    -EINVAL if the state of the VM is invalid (e.g. no memory defined);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e4890e04b210..cb72f9a09fb3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5633,23 +5633,40 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
 
-	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
-		return 0;
+	if (change != KVM_MR_DELETE && change != KVM_MR_FLAGS_ONLY) {
+		/*
+		 * A few sanity checks. We can have memory slots which have to be
+		 * located/ended at a segment boundary (1MB). The memory in userland is
+		 * ok to be fragmented into various different vmas. It is okay to mmap()
+		 * and munmap() stuff in this slot after doing this call at any time
+		 */
 
-	/* A few sanity checks. We can have memory slots which have to be
-	   located/ended at a segment boundary (1MB). The memory in userland is
-	   ok to be fragmented into various different vmas. It is okay to mmap()
-	   and munmap() stuff in this slot after doing this call at any time */
+		if (new->userspace_addr & 0xffffful)
+			return -EINVAL;
 
-	if (new->userspace_addr & 0xffffful)
-		return -EINVAL;
+		size = new->npages * PAGE_SIZE;
+		if (size & 0xffffful)
+			return -EINVAL;
 
-	size = new->npages * PAGE_SIZE;
-	if (size & 0xffffful)
-		return -EINVAL;
+		if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
+			return -EINVAL;
+	}
 
-	if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
-		return -EINVAL;
+	if (!kvm->arch.migration_mode)
+		return 0;
+
+	/*
+	 * Turn off migration mode when:
+	 * - userspace creates a new memslot with dirty logging off,
+	 * - userspace modifies an existing memslot (MOVE or FLAGS_ONLY) and
+	 *   dirty logging is turned off.
+	 * Migration mode expects dirty page logging being enabled to store
+	 * its dirty bitmap.
+	 */
+	if (change != KVM_MR_DELETE &&
+	    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		WARN(kvm_s390_vm_stop_migration(kvm),
+		     "Failed to stop migration mode");
 
 	return 0;
 }

