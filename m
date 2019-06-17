Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30480493D1
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbfFQVZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbfFQVZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:25:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29E4D2063F;
        Mon, 17 Jun 2019 21:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806741;
        bh=VYyhyrgg/DJ/e4Djl5XWxP6JTsXLLylVkZB6XxZ6LyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7udcaNoPqhjvWEwg3u3KYCB2ueq0w6AQcsOUUZEMRYJvqPKLNYJgotD45Ob9B5u0
         xQcvBRE6t5ROWxRJTa/Q3QR+bguv2L8R7+1g5qR5lrjjHH4PKhPXwonKggzXPQpBev
         WgI44XwV1FvVTXQ8NPHnhnI13y3I40j1U8Jc7EKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Heitke <kenneth.heitke@intel.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/75] nvme: release namespace SRCU protection before performing controller ioctls
Date:   Mon, 17 Jun 2019 23:09:53 +0200
Message-Id: <20190617210754.386649678@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



