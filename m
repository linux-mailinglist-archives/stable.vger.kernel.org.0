Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80266AC574
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 16:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjCFPfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 10:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjCFPeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 10:34:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28209366A7
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:34:08 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326EnSmN022144
        for <stable@vger.kernel.org>; Mon, 6 Mar 2023 15:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=EBy8ERUw0EOyggvTnhxwn+PxXcJYr4gkl6B4A8bUwwU=;
 b=Vmlo9f47FnkRa8ppWTj9yLTpKIqSEAgC+UOOnNNlUbxw2JWEljTcQhiESs6lJi7Ll/23
 /eA6VzDA1mW3TPGQuSCPWKpXRx5Q2ibnXisrMb1MOaUHdKvFBMVmizWYGzKi1t5+iwAi
 /Z+3H6vr5g91uCTHyvKXe+eQSFzoWME1zw6dxkEWAw1DjkbpNuL84tKubu5ybmfWa3pj
 UwROE7AABdXft6e4ggLDODz/GzEx/V1RzXgl2gaCfilUpu6LlDutit4icIQPldau/vmh
 Gtp93uh+VXTA/eKqd+HnBhgZJLjWgAXjaQzk0EmCavOaUquTFVgIusbBDP3+7cqaqYEe tA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4uaem647-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 15:33:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 326BgUmZ005927
        for <stable@vger.kernel.org>; Mon, 6 Mar 2023 15:33:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3p418ctwka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 15:33:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326FXGGi60621274
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 15:33:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 776A52004B;
        Mon,  6 Mar 2023 15:33:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FB4920040;
        Mon,  6 Mar 2023 15:33:16 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Mar 2023 15:33:16 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 5.10.y] KVM: s390: disable migration mode when dirty tracking is disabled
Date:   Mon,  6 Mar 2023 16:33:16 +0100
Message-Id: <20230306153316.1829-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <16781000053227@kroah.com>
References: <16781000053227@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0h9F8B7GJw263XykKWRlrfk6cHCkwnYK
X-Proofpoint-ORIG-GUID: 0h9F8B7GJw263XykKWRlrfk6cHCkwnYK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_08,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=894 clxscore=1015
 phishscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
(cherry picked from commit f2d3155e2a6bac44d16f04415a321e8707d895c6)
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst        | 18 ++++++++++++------
 Documentation/virt/kvm/devices/vm.rst |  4 ++++
 arch/s390/kvm/kvm-s390.c              | 17 +++++++++++++++++
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b4b64797191..08295f488d05 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4031,6 +4031,18 @@ not holding a previously reported uncorrected error).
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
 
@@ -4111,12 +4123,6 @@ mask is unused.
 
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
index 59db85fb63e1..7ffc73ba220f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5012,6 +5012,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
 
-- 
2.39.1

