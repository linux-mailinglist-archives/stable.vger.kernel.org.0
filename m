Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E829F4513EC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348750AbhKOT7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344117AbhKOTX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D8D63627;
        Mon, 15 Nov 2021 18:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002333;
        bh=8UZlS5a/lRVH9pSvaVM+MtAJjuT4aSFB4dMrtFesmvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtzmuoB+G4LgU+kNlNFr85br5sNK1NdU0zQMzqvTMeG6pd9uBLGexk4taoLmy3XJN
         Syi13nijyMnIEmd0NfeX0FqUsN8s9/TxWOKukccEfEa8DSo2+I+YPED5tCOIqyVF1S
         RI565R+Fky/JKYNOKLLXbKGMs23r6bBHQEzz5ZoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 492/917] nvme-rdma: fix error code in nvme_rdma_setup_ctrl
Date:   Mon, 15 Nov 2021 17:59:47 +0100
Message-Id: <20211115165445.459120960@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



