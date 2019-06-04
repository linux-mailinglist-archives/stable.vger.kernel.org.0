Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B4735345
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfFDXYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbfFDXYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F6192085A;
        Tue,  4 Jun 2019 23:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690647;
        bh=kChrSNIcXK0ycoxtm2AM0NIG8iR3/Ztr7GjHH/Ai/+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO7/2iJGEyPg7fqAR+2fQ1TZ7gIbxI5ziFvHCSJMz5LNItIjV5Mu/nUjZ+828rXJV
         XAd5pL+n19AmXg+NsXO0XgDw0YpNBRRQxPK5JlVmpAcLZjC3GTXrVJF3nM7Nxx5xHz
         0a/lnw+OhK2O5nVAYmbFZ/Wr8NNDWnK4yNcHZFwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Kenneth Heitke <kenneth.heitke@intel.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Keith Busch <keith.busch@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 20/36] nvme: release namespace SRCU protection before performing controller ioctls
Date:   Tue,  4 Jun 2019 19:23:15 -0400
Message-Id: <20190604232333.7185-20-sashal@kernel.org>
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

[ Upstream commit 5fb4aac756acacf260b9ebd88747251effa3a2f2 ]

Holding the SRCU critical section protecting the namespace list can
cause deadlocks when using the per-namespace admin passthrough ioctl to
delete as namespace.  Release it earlier when performing per-controller
ioctls to avoid that.

Reported-by: Kenneth Heitke <kenneth.heitke@intel.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 82f5f1d030d4..818788275406 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1310,14 +1310,31 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 	if (unlikely(!ns))
 		return -EWOULDBLOCK;
 
+	/*
+	 * Handle ioctls that apply to the controller instead of the namespace
+	 * seperately and drop the ns SRCU reference early.  This avoids a
+	 * deadlock when deleting namespaces using the passthrough interface.
+	 */
+	if (cmd == NVME_IOCTL_ADMIN_CMD || is_sed_ioctl(cmd)) {
+		struct nvme_ctrl *ctrl = ns->ctrl;
+
+		nvme_get_ctrl(ns->ctrl);
+		nvme_put_ns_from_disk(head, srcu_idx);
+
+		if (cmd == NVME_IOCTL_ADMIN_CMD)
+			ret = nvme_user_cmd(ctrl, NULL, argp);
+		else
+			ret = sed_ioctl(ctrl->opal_dev, cmd, argp);
+
+		nvme_put_ctrl(ctrl);
+		return ret;
+	}
+
 	switch (cmd) {
 	case NVME_IOCTL_ID:
 		force_successful_syscall_return();
 		ret = ns->head->ns_id;
 		break;
-	case NVME_IOCTL_ADMIN_CMD:
-		ret = nvme_user_cmd(ns->ctrl, NULL, argp);
-		break;
 	case NVME_IOCTL_IO_CMD:
 		ret = nvme_user_cmd(ns->ctrl, ns, argp);
 		break;
@@ -1327,8 +1344,6 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 	default:
 		if (ns->ndev)
 			ret = nvme_nvm_ioctl(ns, cmd, arg);
-		else if (is_sed_ioctl(cmd))
-			ret = sed_ioctl(ns->ctrl->opal_dev, cmd, argp);
 		else
 			ret = -ENOTTY;
 	}
-- 
2.20.1

