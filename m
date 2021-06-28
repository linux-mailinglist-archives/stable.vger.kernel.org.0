Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009D73B62F2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhF1Ou2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236363AbhF1OsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B615561CAC;
        Mon, 28 Jun 2021 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891000;
        bh=+AUXDUczjuSawvCTHOIWXEs386Lj8FbWpVxfUswMffo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnG18SHPXzd1Wy+qGEZ3VDBiQlCRXx3GsegCITo1DTcp/bsBywHEfShJtbxMIYEwr
         gqglqj68EpuoFpSvihx8gvqnA1sb+nLsQUVMiFpv10xuOdK+kmw8QYKxzvoMebGMhF
         uIRC+3/nsWlZf+gal9VDmz9rvx6hsvYWAXli8/mixCg/Blz3m6CVEiv+W/RaGq48KD
         ggOrAY8m73wGXtek83yGKa4AYwVang9WLkVKR1Jbp2qyuq0qvaAztkpdR+FurAkvtN
         2ST0OxPPHmElv2HMhuSyUajFNsRL/hfIFE3LKYbGKQohPCld16fIL3vJRyx4JYI4Z4
         yOuSqdBcIzEDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/88] nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
Date:   Mon, 28 Jun 2021 10:35:11 -0400
Message-Id: <20210628143628.33342-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 1c5f8e882a05de5c011e8c3fbeceb0d1c590eb53 ]

When the call to nvme_enable_ctrl() in nvme_loop_configure_admin_queue()
fails the NVME_LOOP_Q_LIVE flag is not cleared.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 5f33c3a9469b..963d8de932d1 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -430,6 +430,7 @@ static int nvme_loop_configure_admin_queue(struct nvme_loop_ctrl *ctrl)
 	return 0;
 
 out_cleanup_queue:
+	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 out_free_tagset:
 	blk_mq_free_tag_set(&ctrl->admin_tag_set);
-- 
2.30.2

