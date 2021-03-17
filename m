Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7A033E3B1
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhCQA5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhCQA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF8864F97;
        Wed, 17 Mar 2021 00:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942601;
        bh=TB2G9h7TKrUOwzjOSiCb3bkl/tAilWqLR6IHXUsml1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIkYLtzgMRWu1iiJmg6LfuEt69i8zxNX+EMdXNRS79G+WfJscl6iX+WSTz/6O1/Kv
         4yln8ulw6lntUZiLdeCMIUEG8rwfjC53oq3IuWyr532TX6FIM9PNn2SxKbffYpChH7
         6Sq2MpwoVr5oNf2gsrrsbLXERKexp1S+osnhth+JUyZgfyUVzqiEfaEtJMM0ZOLXDB
         kyRPbWa9iPmaV+M3xODrKZADeQa8upw5XlK5wwcfZIClcZmBQiV6hmKf1Q8xnQcKFG
         bWF2EX/GBpmw8SlqsmhJqSpgMWZi4GQlPF+vH1I6kWfuBbMmBrapZLX/M5xQEO665c
         zDyVi5a6LHNgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        James Smart <jsmart2021@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 52/61] nvme-fc: return NVME_SC_HOST_ABORTED_CMD when a command has been aborted
Date:   Tue, 16 Mar 2021 20:55:26 -0400
Message-Id: <20210317005536.724046-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index cd2d28139d97..f737fc9aa5dd 100644
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

