Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F4C451143
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbhKOTCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243369AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69956348D;
        Mon, 15 Nov 2021 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999955;
        bh=8UZlS5a/lRVH9pSvaVM+MtAJjuT4aSFB4dMrtFesmvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8oGSxxRx+d4Qqc9xKZr+9uP0m7wDRFM5hyEqxBZ1/EwbwjCgdq3WZ8P+9H2JfLS9
         hDx+uCV0TcMb0AYB0t8Bqwue/a6MlVDp4v+b9gpPCdC9KJn7tvaWToEtXBYz8zNs1h
         FoLHhkiCPaoYffxxoOXVU/xygVFf1CWjofOHDwJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 484/849] nvme-rdma: fix error code in nvme_rdma_setup_ctrl
Date:   Mon, 15 Nov 2021 17:59:27 +0100
Message-Id: <20211115165436.650826772@linuxfoundation.org>
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

From: Max Gurtovoy <mgurtovoy@nvidia.com>

[ Upstream commit 09748122009aed7bfaa7acc33c10c083a4758322 ]

In case that icdoff is not zero or mandatory keyed sgls are not
supported by the NVMe/RDMA target, we'll go to error flow but we'll
return 0 to the caller. Fix it by returning an appropriate error code.

Fixes: c66e2998c8ca ("nvme-rdma: centralize controller setup sequence")
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 042c594bc57e2..0498801542eb6 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1095,11 +1095,13 @@ static int nvme_rdma_setup_ctrl(struct nvme_rdma_ctrl *ctrl, bool new)
 		return ret;
 
 	if (ctrl->ctrl.icdoff) {
+		ret = -EOPNOTSUPP;
 		dev_err(ctrl->ctrl.device, "icdoff is not supported!\n");
 		goto destroy_admin;
 	}
 
 	if (!(ctrl->ctrl.sgls & (1 << 2))) {
+		ret = -EOPNOTSUPP;
 		dev_err(ctrl->ctrl.device,
 			"Mandatory keyed sgls are not supported!\n");
 		goto destroy_admin;
-- 
2.33.0



