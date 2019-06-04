Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50306353F7
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfFDX3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727472AbfFDXYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2464C20859;
        Tue,  4 Jun 2019 23:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690643;
        bh=hqVgwEnF/9RsMcxRBozyd21dMgt3XTHl5Cq/n5kGfDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ev0dgmvv909VGq/R6HetjAySnU0toKsmyB2luIcgrvTVpTuIM7uBHsazMxijLD01
         e3yapQfRehslNpz0pTPH+atfrhgV9ZiiqHwGKFkZgBVCiGHjWGc+/GIOJ24rSP3NQw
         XxMtBDgX0k+/8wzncY1fKFuEUo025x5TmtuFvulQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 17/36] nvme: fix srcu locking on error return in nvme_get_ns_from_disk
Date:   Tue,  4 Jun 2019 19:23:12 -0400
Message-Id: <20190604232333.7185-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232333.7185-1-sashal@kernel.org>
References: <20190604232333.7185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 100c815cbd56480b3e31518475b04719c363614a ]

If we can't get a namespace don't leak the SRCU lock.  nvme_ioctl was
working around this, but nvme_pr_command wasn't handling this properly.
Just do what callers would usually expect.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index abfb46378cc1..44d8077fbe95 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1277,9 +1277,14 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct gendisk *disk,
 {
 #ifdef CONFIG_NVME_MULTIPATH
 	if (disk->fops == &nvme_ns_head_ops) {
+		struct nvme_ns *ns;
+
 		*head = disk->private_data;
 		*srcu_idx = srcu_read_lock(&(*head)->srcu);
-		return nvme_find_path(*head);
+		ns = nvme_find_path(*head);
+		if (!ns)
+			srcu_read_unlock(&(*head)->srcu, *srcu_idx);
+		return ns;
 	}
 #endif
 	*head = NULL;
@@ -1326,9 +1331,9 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 
 	ns = nvme_get_ns_from_disk(bdev->bd_disk, &head, &srcu_idx);
 	if (unlikely(!ns))
-		ret = -EWOULDBLOCK;
-	else
-		ret = nvme_ns_ioctl(ns, cmd, arg);
+		return -EWOULDBLOCK;
+
+	ret = nvme_ns_ioctl(ns, cmd, arg);
 	nvme_put_ns_from_disk(head, srcu_idx);
 	return ret;
 }
-- 
2.20.1

