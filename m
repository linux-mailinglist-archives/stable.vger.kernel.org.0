Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCF35426
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfFDXbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfFDXXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:23:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C057420862;
        Tue,  4 Jun 2019 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690581;
        bh=DEfZPxevgdlIF4EJdrDYiUNmOwg+yU+llyzjzz9f0BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReMO5OaXGt8ZajBV10RNoHPJ6omTAf3LqlnYyKRfSci7Joy12nvdKL64zK9U/sdb7
         pNkJr6A7y6Lyui9W45cQ2lHjS8HTbLkPkRvPtp4xMwPlxqmu1XaT39US8eQvHyuAtn
         mQ2fKz5iRQv7+4Q3+obAheH8MZeXpbT7jiLitnFM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.1 31/60] nvme: merge nvme_ns_ioctl into nvme_ioctl
Date:   Tue,  4 Jun 2019 19:21:41 -0400
Message-Id: <20190604232212.6753-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 90ec611adcf20b96d0c2b7166497d53e4301a57f ]

Merge the two functions to make future changes a little easier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 47 ++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index decc0b3a3854..8b77e6a05f4b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1383,32 +1383,11 @@ static void nvme_put_ns_from_disk(struct nvme_ns_head *head, int idx)
 		srcu_read_unlock(&head->srcu, idx);
 }
 
-static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned cmd, unsigned long arg)
-{
-	switch (cmd) {
-	case NVME_IOCTL_ID:
-		force_successful_syscall_return();
-		return ns->head->ns_id;
-	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ns->ctrl, NULL, (void __user *)arg);
-	case NVME_IOCTL_IO_CMD:
-		return nvme_user_cmd(ns->ctrl, ns, (void __user *)arg);
-	case NVME_IOCTL_SUBMIT_IO:
-		return nvme_submit_io(ns, (void __user *)arg);
-	default:
-		if (ns->ndev)
-			return nvme_nvm_ioctl(ns, cmd, arg);
-		if (is_sed_ioctl(cmd))
-			return sed_ioctl(ns->ctrl->opal_dev, cmd,
-					 (void __user *) arg);
-		return -ENOTTY;
-	}
-}
-
 static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned int cmd, unsigned long arg)
 {
 	struct nvme_ns_head *head = NULL;
+	void __user *argp = (void __user *)arg;
 	struct nvme_ns *ns;
 	int srcu_idx, ret;
 
@@ -1416,7 +1395,29 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 	if (unlikely(!ns))
 		return -EWOULDBLOCK;
 
-	ret = nvme_ns_ioctl(ns, cmd, arg);
+	switch (cmd) {
+	case NVME_IOCTL_ID:
+		force_successful_syscall_return();
+		ret = ns->head->ns_id;
+		break;
+	case NVME_IOCTL_ADMIN_CMD:
+		ret = nvme_user_cmd(ns->ctrl, NULL, argp);
+		break;
+	case NVME_IOCTL_IO_CMD:
+		ret = nvme_user_cmd(ns->ctrl, ns, argp);
+		break;
+	case NVME_IOCTL_SUBMIT_IO:
+		ret = nvme_submit_io(ns, argp);
+		break;
+	default:
+		if (ns->ndev)
+			ret = nvme_nvm_ioctl(ns, cmd, arg);
+		else if (is_sed_ioctl(cmd))
+			ret = sed_ioctl(ns->ctrl->opal_dev, cmd, argp);
+		else
+			ret = -ENOTTY;
+	}
+
 	nvme_put_ns_from_disk(head, srcu_idx);
 	return ret;
 }
-- 
2.20.1

