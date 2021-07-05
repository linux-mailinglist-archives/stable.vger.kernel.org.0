Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9053BBBBE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhGELCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhGELCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB404613B9;
        Mon,  5 Jul 2021 10:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482778;
        bh=otDNswzrNoZlJxkieNYaRlw/bmg3oENY62X+0YIE9lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpYMvoTeFy+k6tczpQoDwt9EswrL4xFt3olhL3fjTkvFTL1/tc7jPBGwrAfE6fwux
         y+Avo8O00LoUKeCVhJMkUQ04KCA+G2fNHeMCtRDPN1p/YHIqAhLCkl84J+xgT5dE5t
         b+efEejj+BctT4qKAiNtIDbbvBg+yThwHXF3y0nWQlp8gxnH9Nhk9j+iUu+2EqDOee
         usWzs5OR6sA9dfpzERbFA0l/8CbiAAPfAJlNT9TzvOvsxRJo0y6qXmUSnZsmAD/ToQ
         QLdPsYgqLavD2wubXlyRRiHlbs0DkNs3RXJ2TMKi1Wx5HV2SnmvG1b8qhS7em2xL0W
         pxipTwdawKMPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 2/7] s390/vfio-ap: clean up mdev resources when remove callback invoked
Date:   Mon,  5 Jul 2021 06:59:29 -0400
Message-Id: <20210705105934.1513188-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.15-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit 8c0795d2a0f50e2b131f5b2a8c2795939a94058e ]

The mdev remove callback for the vfio_ap device driver bails out with
-EBUSY if the mdev is in use by a KVM guest (i.e., the KVM pointer in the
struct ap_matrix_mdev is not NULL). The intended purpose was
to prevent the mdev from being removed while in use. There are two
problems with this scenario:

1. Returning a non-zero return code from the remove callback does not
   prevent the removal of the mdev.

2. The KVM pointer in the struct ap_matrix_mdev will always be NULL because
   the remove callback will not get invoked until the mdev fd is closed.
   When the mdev fd is closed, the mdev release callback is invoked and
   clears the KVM pointer from the struct ap_matrix_mdev.

Let's go ahead and remove the check for KVM in the remove callback and
allow the cleanup of mdev resources to proceed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20210609224634.575156-2-akrowiak@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6946a7e26eff..ef5e792c665f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -366,16 +366,6 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-
-	/*
-	 * If the KVM pointer is in flux or the guest is running, disallow
-	 * un-assignment of control domain.
-	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
-		mutex_unlock(&matrix_dev->lock);
-		return -EBUSY;
-	}
-
 	vfio_ap_mdev_reset_queues(mdev);
 	list_del(&matrix_mdev->node);
 	kfree(matrix_mdev);
-- 
2.30.2

