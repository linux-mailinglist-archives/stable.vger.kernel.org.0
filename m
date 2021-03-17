Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560D033E445
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhCQA66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231833AbhCQA55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1106164FBC;
        Wed, 17 Mar 2021 00:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942670;
        bh=yFRTegtSzKBQvthZpm4ZsW52ysmmsTXaRrKe02Y/fdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTdbgv5/b9+NT8PhPjAJ/YFELDSZtmL1dDltz9sRrmcGEyFA7mjR0VFu6KfnVbATF
         W0kkhPT9sRWt6TwwrcCH7HHnenOKKZIdXTa8PEqdVXU8iIme+aVqSVr9sb6WoAPYHW
         SR69+FBWWelCEmFVIpXZdj/I6QOIXk5Qt4dKPWcAce1N52bcV0HrTK37JpXtujmEZF
         8V0gvrnNhpBHFiqDONhN6+vfbBO25dQE71RYOXLmg65/nuqU2G9hg3RpVocVzFgqSF
         yfCNj44OvS5Yrlk4gFXwx/D6F+bjdW3rqC2sJTD7Wz490aLiNqG4UgX9XicvtwFxoe
         Pqo/DLoFZtiqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 46/54] nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted
Date:   Tue, 16 Mar 2021 20:56:45 -0400
Message-Id: <20210317005654.724862-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit ae3afe6308b43bbf49953101d4ba2c1c481133a8 ]

When a command has been aborted we should return NVME_SC_HOST_ABORTED_CMD
to be consistent with the other transports.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index a107032da3c2..8bc0bd4bd7ab 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1956,7 +1956,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 				sizeof(op->rsp_iu), DMA_FROM_DEVICE);
 
 	if (opstate == FCPOP_STATE_ABORTED)
-		status = cpu_to_le16(NVME_SC_HOST_PATH_ERROR << 1);
+		status = cpu_to_le16(NVME_SC_HOST_ABORTED_CMD << 1);
 	else if (freq->status) {
 		status = cpu_to_le16(NVME_SC_HOST_PATH_ERROR << 1);
 		dev_info(ctrl->ctrl.device,
-- 
2.30.1

