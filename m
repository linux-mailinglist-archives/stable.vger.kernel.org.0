Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2EDAF740
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 09:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfIKHw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 03:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbfIKHw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 03:52:28 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4E55316E536;
        Wed, 11 Sep 2019 07:52:27 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq.redhat.com (dell-r430-03.lab.eng.brq.redhat.com [10.37.153.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AD0B6012A;
        Wed, 11 Sep 2019 07:52:23 +0000 (UTC)
From:   Igor Mammedov <imammedo@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        frankja@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] KVM: s390: kvm_s390_vm_start_migration: check dirty_bitmap before using it as target for memset()
Date:   Wed, 11 Sep 2019 03:52:18 -0400
Message-Id: <20190911075218.29153-1-imammedo@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 11 Sep 2019 07:52:27 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If userspace doesn't set KVM_MEM_LOG_DIRTY_PAGES on memslot before calling
kvm_s390_vm_start_migration(), kernel will oops with:

  Unable to handle kernel pointer dereference in virtual kernel address space
  Failing address: 0000000000000000 TEID: 0000000000000483
  Fault in home space mode while using kernel ASCE.
  AS:0000000002a2000b R2:00000001bff8c00b R3:00000001bff88007 S:00000001bff91000 P:000000000000003d
  Oops: 0004 ilc:2 [#1] SMP
  ...
  Call Trace:
  ([<001fffff804ec552>] kvm_s390_vm_set_attr+0x347a/0x3828 [kvm])
   [<001fffff804ecfc0>] kvm_arch_vm_ioctl+0x6c0/0x1998 [kvm]
   [<001fffff804b67e4>] kvm_vm_ioctl+0x51c/0x11a8 [kvm]
   [<00000000008ba572>] do_vfs_ioctl+0x1d2/0xe58
   [<00000000008bb284>] ksys_ioctl+0x8c/0xb8
   [<00000000008bb2e2>] sys_ioctl+0x32/0x40
   [<000000000175552c>] system_call+0x2b8/0x2d8
  INFO: lockdep is turned off.
  Last Breaking-Event-Address:
   [<0000000000dbaf60>] __memset+0xc/0xa0

due to ms->dirty_bitmap being NULL, which might crash the host.

Make sure that ms->dirty_bitmap is set before using it or
return -ENIVAL otherwise.

Fixes: afdad61615cc ("KVM: s390: Fix storage attributes migration with memory slots")
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
Cc: stable@vger.kernel.org # v4.19+

v2:
   - remove not true anym 'warning' clause in commit message
v2:
   - drop WARN()

 arch/s390/kvm/kvm-s390.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f329dcb3f44c..2a40cd3e40b4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1018,6 +1018,8 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 	/* mark all the pages in active slots as dirty */
 	for (slotnr = 0; slotnr < slots->used_slots; slotnr++) {
 		ms = slots->memslots + slotnr;
+		if (!ms->dirty_bitmap)
+			return -EINVAL;
 		/*
 		 * The second half of the bitmap is only used on x86,
 		 * and would be wasted otherwise, so we put it to good
-- 
2.18.1

