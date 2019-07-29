Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F1A79761
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390775AbfG2Tvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390222AbfG2Tvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:51:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682F3217D4;
        Mon, 29 Jul 2019 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429913;
        bh=kWYMEl2mcLtwN/DWe0hT2YGnrHiImohYSWe2qTLe4J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+YPzzJeeyUKqVMCCfQkGJNKWFbwnN4ooN6+D7Sqgk59QEjg5EFaJ1z/eFaH+nY9X
         ULqZphlk0SG4G+8qIR0nrVsV0VZHLo6/CdI5U7txpRXevE8m5ejTbNiW5MUjnMSpO+
         4r8/hgFIIWcPt76ySBiXypPm42lzurlgmU300lyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Mike Playle <mplayle@solarflare.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 136/215] nvme-tcp: set the STABLE_WRITES flag when data digests are enabled
Date:   Mon, 29 Jul 2019 21:22:12 +0200
Message-Id: <20190729190803.152828213@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 958f2a0f8121ae36a5cbff383ab94fadf1fba5eb ]

There was a few false alarms sighted on target side about wrong data
digest while performing high throughput load to XFS filesystem shared
through NVMoF TCP.

This flag tells the rest of the kernel to ensure that the data buffer
does not change while the write is in flight.  It incurs a performance
penalty, so only enable it when it is actually needed, i.e. when we are
calculating data digests.

Although even with this change in place, ext2 users can steel experience
false positives, as ext2 is not respecting this flag. This may be apply
to vfat as well.

Signed-off-by: Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
Signed-off-by: Mike Playle <mplayle@solarflare.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 22c68e3b71d5..215bef904b7b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -11,6 +11,7 @@
 #include <linux/hdreg.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/backing-dev.h>
 #include <linux/list_sort.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -3256,6 +3257,10 @@ static int nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 		goto out_free_ns;
 	}
 
+	if (ctrl->opts->data_digest)
+		ns->queue->backing_dev_info->capabilities
+			|= BDI_CAP_STABLE_WRITES;
+
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, ns->queue);
 	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
 		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
-- 
2.20.1



