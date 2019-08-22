Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D4299AB3
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391164AbfHVRP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390473AbfHVRIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:43 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7EB523429;
        Thu, 22 Aug 2019 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493723;
        bh=9ci3Ug3FGCxgxpgteG3x+RIRrG59YRYacjNFOQOS1IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSdQaFVxsfbROkn9cGx31uMAuu75FEAJELMUKgAl9yZL6CkVZ3MyzCHnqO4G5QhYt
         ECJa6vvcJKDfxtxf0Rkd9g6XBmY6HBxXQWraiSxOZ9MqnCKQouZkO5g8T8YQQVsRcZ
         ETmzKAZEklOZcJB1exIXVOCFDRqqWUZBmtSrhl30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 053/135] RDMA/qedr: Fix the hca_type and hca_rev returned in device attributes
Date:   Thu, 22 Aug 2019 13:06:49 -0400
Message-Id: <20190822170811.13303-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 15fe6a8dcc3b48358c28e17b485fc837f9605ec4 ]

There was a place holder for hca_type and vendor was returned
in hca_rev. Fix the hca_rev to return the hw revision and fix
the hca_type to return an informative string representing the
hca.

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Link: https://lore.kernel.org/r/20190728111338.21930-1-michal.kalderon@marvell.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 083c2c00a8e91..dfdd1e16de7f5 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -125,14 +125,20 @@ static ssize_t hw_rev_show(struct device *device, struct device_attribute *attr,
 	struct qedr_dev *dev =
 		rdma_device_to_drv_device(device, struct qedr_dev, ibdev);
 
-	return scnprintf(buf, PAGE_SIZE, "0x%x\n", dev->pdev->vendor);
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n", dev->attr.hw_ver);
 }
 static DEVICE_ATTR_RO(hw_rev);
 
 static ssize_t hca_type_show(struct device *device,
 			     struct device_attribute *attr, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%s\n", "HCA_TYPE_TO_SET");
+	struct qedr_dev *dev =
+		rdma_device_to_drv_device(device, struct qedr_dev, ibdev);
+
+	return scnprintf(buf, PAGE_SIZE, "FastLinQ QL%x %s\n",
+			 dev->pdev->device,
+			 rdma_protocol_iwarp(&dev->ibdev, 1) ?
+			 "iWARP" : "RoCE");
 }
 static DEVICE_ATTR_RO(hca_type);
 
-- 
2.20.1

