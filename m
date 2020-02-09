Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8942B156ABE
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBINo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:44:59 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40217 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:44:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 507A1213BD;
        Sun,  9 Feb 2020 08:44:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:44:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lGQzpD
        f+X4qPqoAt2lAqYXQaG8WHS/5eFbsPxDH9dZI=; b=unHln/VxlcH+zJi9gKZt9w
        qPSn8S0y13fQOQzE1v5AqiMzCgM4NK5g4L3tkBAE2b0VWtWtnhrwUpzwBBL8sJUs
        Q8Rb0NmcQ28TTu+NvFW4IEEDATwrcRS2Kvz0BZdnDQOG179xyo1gyk1BNu3jJ5Xy
        09DQyHwhHXOxMnoI7P/GOOfdnzoMIl0iDvkyHvIOW5R7wHf5kElJP0kY99Gv3HKh
        0sWJLWP5anueEnt6a7Qr++MtnJTYG+khYM88Qw5dx+uuNvqpYjQHFPALkTNb7LtG
        eF1F/08aRJR6EGGa/r+7FGmOwXTh4oMTiyh96FW6yhVweC3dGhmAQJL2TRU3Daxw
        ==
X-ME-Sender: <xms:2gxAXuF_O_sFk-eKrgVINGqX9k2bvRmf-zfjls4PfWvmVPDceJbMwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeefkedrleekrdefjedrud
    efheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2gxAXpS5cVjiuqyzHfVrTsDqhCvavmurSR4j3vhQrzSHfBUR8FcuhA>
    <xmx:2gxAXuclwh8ceX7h88cUHD8p-uc5Cx1WkqeRBhCyY0quazjQ_l0fZQ>
    <xmx:2gxAXulDzvS-OT0apQvxJitU_-N35zkrDKAOe3bPGGNyYvH6K0vVpg>
    <xmx:2gxAXro2-LKNJmq3KvBmdw_j320sO0-rnM-mO4PqBRE0eqlnLJtPbQ>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id D75D33280063;
        Sun,  9 Feb 2020 08:44:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: s390: do not clobber registers during guest reset/store" failed to apply to 4.14-stable tree
To:     borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        frankja@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:37:35 +0100
Message-ID: <1581251855208101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 55680890ea78be0df5e1384989f1be835043c084 Mon Sep 17 00:00:00 2001
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Fri, 31 Jan 2020 05:02:00 -0500
Subject: [PATCH] KVM: s390: do not clobber registers during guest reset/store
 status

The initial CPU reset clobbers the userspace fpc and the store status
ioctl clobbers the guest acrs + fpr.  As these calls are only done via
ioctl (and not via vcpu_run), no CPU context is loaded, so we can (and
must) act directly on the sync regs, not on the thread context.

Cc: stable@kernel.org
Fixes: e1788bb995be ("KVM: s390: handle floating point registers in the run ioctl not in vcpu_put/load")
Fixes: 31d8b8d41a7e ("KVM: s390: handle access registers in the run ioctl not in vcpu_put/load")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20200131100205.74720-2-frankja@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d9e6bf3d54f0..876802894b35 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2860,9 +2860,7 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
 					CR14_UNUSED_33 |
 					CR14_EXTERNAL_DAMAGE_SUBMASK;
-	/* make sure the new fpc will be lazily loaded */
-	save_fpu_regs();
-	current->thread.fpu.fpc = 0;
+	vcpu->run->s.regs.fpc = 0;
 	vcpu->arch.sie_block->gbea = 1;
 	vcpu->arch.sie_block->pp = 0;
 	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
@@ -4351,7 +4349,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	switch (ioctl) {
 	case KVM_S390_STORE_STATUS:
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		r = kvm_s390_vcpu_store_status(vcpu, arg);
+		r = kvm_s390_store_status_unloaded(vcpu, arg);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	case KVM_S390_SET_INITIAL_PSW: {

