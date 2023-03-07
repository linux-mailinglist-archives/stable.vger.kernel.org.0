Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327D76AF557
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbjCGTYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbjCGTYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B999B2561
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:09:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B73CB818C4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5B0C433D2;
        Tue,  7 Mar 2023 19:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216181;
        bh=EjNU+yaRlZDe8Dtf8jxfZBGEXcBfivUTDgjP1lIT77U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTWwAQYLq9YSx0sbqZnIJbaAwz2HTu0K0OEAeMe55RXE0jf1fIDGYIH8gSD+FWxd5
         z+HCLYq84qaj/IpQ2bPVFVOE0EvATjYdf0/PnBjTFPUSp8ifT4WhE5mW6aVrrXwMdv
         KwY/5Yc2HV/dQfljxlCnaDCzRuaXLo+hGT0eyJwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.15 470/567] KVM: s390: disable migration mode when dirty tracking is disabled
Date:   Tue,  7 Mar 2023 18:03:26 +0100
Message-Id: <20230307165926.256086594@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

commit f2d3155e2a6bac44d16f04415a321e8707d895c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/api.rst        |   18 ++++++++++++------
 Documentation/virt/kvm/devices/vm.rst |    4 ++++
 arch/s390/kvm/kvm-s390.c              |   17 +++++++++++++++++
 3 files changed, 33 insertions(+), 6 deletions(-)

--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4117,6 +4117,18 @@ not holding a previously reported uncorr
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
 
@@ -4197,12 +4209,6 @@ mask is unused.
 
 values points to the userspace buffer where the result will be stored.
 
-This ioctl can fail with -ENOMEM if not enough memory can be allocated to
-complete the task, with -ENXIO if CMMA is not enabled, with -EINVAL if
-KVM_S390_CMMA_PEEK is not set but migration mode was not enabled, with
--EFAULT if the userspace address is invalid or if no page table is
-present for the addresses (e.g. when using hugepages).
-
 4.108 KVM_S390_SET_CMMA_BITS
 ----------------------------
 
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -302,6 +302,10 @@ Allows userspace to start migration mode
 Setting this attribute when migration mode is already active will have
 no effects.
 
+Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
+dirty tracking is disabled on any memslot, migration mode is automatically
+stopped.
+
 :Parameters: none
 :Returns:   -ENOMEM if there is not enough free memory to start migration mode;
 	    -EINVAL if the state of the VM is invalid (e.g. no memory defined);
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5066,6 +5066,23 @@ int kvm_arch_prepare_memory_region(struc
 	/* When we are protected, we should not change the memory slots */
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
+
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
+	    !(mem->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		WARN(kvm_s390_vm_stop_migration(kvm),
+		     "Failed to stop migration mode");
+
 	return 0;
 }
 


