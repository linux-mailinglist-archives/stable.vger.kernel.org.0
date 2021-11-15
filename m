Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6445260B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359795AbhKPCBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240324AbhKOSHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E6746330A;
        Mon, 15 Nov 2021 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998360;
        bh=Evx++gjDo7wbItwzP2XPGpf24lLdK8c/ZffjhhVXzYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzEmnlV8s87kdT+Eur4Q7NB6mWWO/+Olc3eRBf83MzbvWQwi+/8QftTUy+pq4+7m5
         A6Ixjsd3vfawLxAYsXIjnqPPtGFOtJQgPSgfFAQqqmr3sXFED2oNaiu/zZydWSG8Fv
         hADZwSSMSc1RsKYXlyUJy8xI0DJXQN1gGS5S/v48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jim Quinlan <james.quinlan@broadcom.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/575] remoteproc: Fix a memory leak in an error handling path in rproc_handle_vdev()
Date:   Mon, 15 Nov 2021 18:03:27 +0100
Message-Id: <20211115165400.378038857@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0374a4ea7269645c46c3eb288526ea072fa19e79 ]

If 'copy_dma_range_map() fails, the memory allocated for 'rvdev' will leak.
Move the 'copy_dma_range_map()' call after the device registration so
that 'rproc_rvdev_release()' can be called to free some resources.

Also, branch to the error handling path if 'copy_dma_range_map()' instead
of a direct return to avoid some other leaks.

Fixes: e0d072782c73 ("dma-mapping: introduce DMA range map, supplanting dma_pfn_offset")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jim Quinlan <james.quinlan@broadcom.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/e6d0dad6620da4fdf847faa903f79b735d35f262.1630755377.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 47924d5ed4f56..369a97f3eca99 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -550,9 +550,6 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* Initialise vdev subdevice */
 	snprintf(name, sizeof(name), "vdev%dbuffer", rvdev->index);
 	rvdev->dev.parent = &rproc->dev;
-	ret = copy_dma_range_map(&rvdev->dev, rproc->dev.parent);
-	if (ret)
-		return ret;
 	rvdev->dev.release = rproc_rvdev_release;
 	dev_set_name(&rvdev->dev, "%s#%s", dev_name(rvdev->dev.parent), name);
 	dev_set_drvdata(&rvdev->dev, rvdev);
@@ -562,6 +559,11 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 		put_device(&rvdev->dev);
 		return ret;
 	}
+
+	ret = copy_dma_range_map(&rvdev->dev, rproc->dev.parent);
+	if (ret)
+		goto free_rvdev;
+
 	/* Make device dma capable by inheriting from parent's capabilities */
 	set_dma_ops(&rvdev->dev, get_dma_ops(rproc->dev.parent));
 
-- 
2.33.0



