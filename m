Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD3C33E461
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhCQA7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232228AbhCQA7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA7C464FA5;
        Wed, 17 Mar 2021 00:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942722;
        bh=RIRFGEqrcd5TIFcmBQsp4YlMG8xjpmPckwKgKpxzPq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blVOzqAT0oakViqRsYaVpxZYpTlHvIBVbWf+wI5n0/yi8oFCSPEZY9mz4plcB9Mfl
         CyTd9bIIstgTECfVE8brnOdgqJWCLRRsctXXZb+h2iIYSZqZkRG7RQ0w8i8Iy2x9+z
         jeTfU7tVNQQjghtMhfRrJUgo3ayBMtlK3TD2DVPRvnqHukOMzVlo3zZQnTpz0f96Wz
         D6bkerX2G/HHTZb2shxiXwiL6aK++eI9ujH/V4q7BguhBZOvdfkDBH09dbV3+TqgV9
         7ohFb+QuMGefpm2tiTHtcfvQb1heVDJ98VcBUCs9K4bHDxW4lagy84cuPcOr2qZDxB
         JgNghPTF9mz9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 32/37] nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted
Date:   Tue, 16 Mar 2021 20:57:57 -0400
Message-Id: <20210317005802.725825-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index 65b3dc9cd693..0d2c22cf12a0 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1608,7 +1608,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 				sizeof(op->rsp_iu), DMA_FROM_DEVICE);
 
 	if (opstate == FCPOP_STATE_ABORTED)
-		status = cpu_to_le16(NVME_SC_HOST_PATH_ERROR << 1);
+		status = cpu_to_le16(NVME_SC_HOST_ABORTED_CMD << 1);
 	else if (freq->status) {
 		status = cpu_to_le16(NVME_SC_HOST_PATH_ERROR << 1);
 		dev_info(ctrl->ctrl.device,
-- 
2.30.1

