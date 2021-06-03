Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA97239A84F
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhFCROj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232670AbhFCRMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F5E461412;
        Thu,  3 Jun 2021 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740223;
        bh=8OKa0TN9Ba3djjRumI74iBKp/RKpJZ3D36X667OX8RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QY5fkIWfYinf2iN0WxbITHY8TX50cBQqGDf9Vcn4qoPlOCJ2dsnurd5D4DWSrglTJ
         0TrFfXoz2XVp5zUwMG2euMndzxQkh4knVuU9Mu/L0WkG0Q11/0fMISFEcXwTegF1Y4
         H9jWDNDgMz9tBt1zAcpfn+rzo3AQkj4QbmOHE4xg99FE58HAoFgiOpGnV+ZZ3UVI2D
         nIkBG5LC3s4E8nextUqyJNXTnl77FR9RNMQtPsLtkTQwGMiWGA4jQR3L5o7d9UdnjH
         toQqhPHMgNrQbRhjgnE1OIP4yTBtWJSRxVjU/wC9wInitLSrINNXN98KYo86lgmIvy
         IOztACL8z6rCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 19/23] nvme-fabrics: decode host pathing error for connect
Date:   Thu,  3 Jun 2021 13:09:55 -0400
Message-Id: <20210603170959.3169420-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 4d9442bf263ac45d495bb7ecf75009e59c0622b2 ]

Add an additional decoding for 'host pathing error' during connect.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 05dd46f98441..3ae800e87999 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -344,6 +344,11 @@ static void nvmf_log_connect_error(struct nvme_ctrl *ctrl,
 			cmd->connect.recfmt);
 		break;
 
+	case NVME_SC_HOST_PATH_ERROR:
+		dev_err(ctrl->device,
+			"Connect command failed: host path error\n");
+		break;
+
 	default:
 		dev_err(ctrl->device,
 			"Connect command failed, error wo/DNR bit: %d\n",
-- 
2.30.2

