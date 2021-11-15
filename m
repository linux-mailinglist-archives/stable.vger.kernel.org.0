Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BAA451241
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241145AbhKOTdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:33:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244618AbhKOTRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF4F61872;
        Mon, 15 Nov 2021 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000525;
        bh=sIHIbKWXWQKAMWd6v6wxFncRTQ2BVNWst8wwIJ1FvIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLFgvS2tlHaSTEyKkNUR4QZymLN6MHuL+EYAWZIcVPb1h+1JbNdwCgPN17d6n1YkF
         B0cZHR26UHXYnav3pmEP8JHySSxRHg0XZK28hk0chTa4aqJ6hw6xjdsASbAQqMynGf
         cOBmcazNXuyZXe3O2OYRZ0mOocShNZbh+lxuQjF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jim Quinlan <james.quinlan@broadcom.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 692/849] remoteproc: Fix a memory leak in an error handling path in rproc_handle_vdev()
Date:   Mon, 15 Nov 2021 18:02:55 +0100
Message-Id: <20211115165443.665232094@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 7de5905d276ac..f77b0ff55385e 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -556,9 +556,6 @@ static int rproc_handle_vdev(struct rproc *rproc, void *ptr,
 	/* Initialise vdev subdevice */
 	snprintf(name, sizeof(name), "vdev%dbuffer", rvdev->index);
 	rvdev->dev.parent = &rproc->dev;
-	ret = copy_dma_range_map(&rvdev->dev, rproc->dev.parent);
-	if (ret)
-		return ret;
 	rvdev->dev.release = rproc_rvdev_release;
 	dev_set_name(&rvdev->dev, "%s#%s", dev_name(rvdev->dev.parent), name);
 	dev_set_drvdata(&rvdev->dev, rvdev);
@@ -568,6 +565,11 @@ static int rproc_handle_vdev(struct rproc *rproc, void *ptr,
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



