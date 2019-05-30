Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0272F397
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfE3EaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbfE3DN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 540EC24578;
        Thu, 30 May 2019 03:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186036;
        bh=bZizr1t6BzbjwN0yJ7fX+f7uZ1SGbNSRud942rvWzQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkef39TsEaXQ4ABaJpIkRDUFRK+2zno4guKQtj1QFdX3XYSOmrO7/SV57oXSjh+1b
         f5ORPpp8lA0rPXqsWXoIurhz7Wx6qqxwfgA1Ieqvv5kR84gex9ipITx63GnB4Un17f
         RG7xDnEtgZuBcOvcgC3X1IVN85Twf6g2U4GDx6MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 123/346] vfio-ccw: Release any channel program when releasing/removing vfio-ccw mdev
Date:   Wed, 29 May 2019 20:03:16 -0700
Message-Id: <20190530030547.323876553@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b49bdc8602b7c9c7a977758bee4125683f73e59f ]

When releasing the vfio-ccw mdev, we currently do not release
any existing channel program and its pinned pages. This can
lead to the following warning:

[1038876.561565] WARNING: CPU: 2 PID: 144727 at drivers/vfio/vfio_iommu_type1.c:1494 vfio_sanity_check_pfn_list+0x40/0x70 [vfio_iommu_type1]

....

1038876.561921] Call Trace:
[1038876.561935] ([<00000009897fb870>] 0x9897fb870)
[1038876.561949]  [<000003ff8013bf62>] vfio_iommu_type1_detach_group+0xda/0x2f0 [vfio_iommu_type1]
[1038876.561965]  [<000003ff8007b634>] __vfio_group_unset_container+0x64/0x190 [vfio]
[1038876.561978]  [<000003ff8007b87e>] vfio_group_put_external_user+0x26/0x38 [vfio]
[1038876.562024]  [<000003ff806fc608>] kvm_vfio_group_put_external_user+0x40/0x60 [kvm]
[1038876.562045]  [<000003ff806fcb9e>] kvm_vfio_destroy+0x5e/0xd0 [kvm]
[1038876.562065]  [<000003ff806f63fc>] kvm_put_kvm+0x2a4/0x3d0 [kvm]
[1038876.562083]  [<000003ff806f655e>] kvm_vm_release+0x36/0x48 [kvm]
[1038876.562098]  [<00000000003c2dc4>] __fput+0x144/0x228
[1038876.562113]  [<000000000016ee82>] task_work_run+0x8a/0xd8
[1038876.562125]  [<000000000014c7a8>] do_exit+0x5d8/0xd90
[1038876.562140]  [<000000000014d084>] do_group_exit+0xc4/0xc8
[1038876.562155]  [<000000000015c046>] get_signal+0x9ae/0xa68
[1038876.562169]  [<0000000000108d66>] do_signal+0x66/0x768
[1038876.562185]  [<0000000000b9e37e>] system_call+0x1ea/0x2d8
[1038876.562195] 2 locks held by qemu-system-s39/144727:
[1038876.562205]  #0: 00000000537abaf9 (&container->group_lock){++++}, at: __vfio_group_unset_container+0x3c/0x190 [vfio]
[1038876.562230]  #1: 00000000670008b5 (&iommu->lock){+.+.}, at: vfio_iommu_type1_detach_group+0x36/0x2f0 [vfio_iommu_type1]
[1038876.562250] Last Breaking-Event-Address:
[1038876.562262]  [<000003ff8013aa24>] vfio_sanity_check_pfn_list+0x3c/0x70 [vfio_iommu_type1]
[1038876.562272] irq event stamp: 4236481
[1038876.562287] hardirqs last  enabled at (4236489): [<00000000001cee7a>] console_unlock+0x6d2/0x740
[1038876.562299] hardirqs last disabled at (4236496): [<00000000001ce87e>] console_unlock+0xd6/0x740
[1038876.562311] softirqs last  enabled at (4234162): [<0000000000b9fa1e>] __do_softirq+0x556/0x598
[1038876.562325] softirqs last disabled at (4234153): [<000000000014e4cc>] irq_exit+0xac/0x108
[1038876.562337] ---[ end trace 6c96d467b1c3ca06 ]---

Similarly we do not free the channel program when we are removing
the vfio-ccw device. Let's fix this by resetting the device and freeing
the channel program and pinned pages in the release path. For the remove
path we can just quiesce the device, since in the remove path the mediated
device is going away for good and so we don't need to do a full reset.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Message-Id: <ae9f20dc8873f2027f7b3c5d2aaa0bdfe06850b8.1554756534.git.alifm@linux.ibm.com>
Acked-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/vfio_ccw_ops.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index f673e106c0415..dc5ff47de3fee 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -130,11 +130,12 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
 
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_mdev_reset(mdev))
+		if (!vfio_ccw_sch_quiesce(private->sch))
 			private->state = VFIO_CCW_STATE_STANDBY;
 		/* The state will be NOT_OPER on error. */
 	}
 
+	cp_free(&private->cp);
 	private->mdev = NULL;
 	atomic_inc(&private->avail);
 
@@ -158,6 +159,14 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
 
+	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
+	    (private->state != VFIO_CCW_STATE_STANDBY)) {
+		if (!vfio_ccw_mdev_reset(mdev))
+			private->state = VFIO_CCW_STATE_STANDBY;
+		/* The state will be NOT_OPER on error. */
+	}
+
+	cp_free(&private->cp);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &private->nb);
 }
-- 
2.20.1



