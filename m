Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E33231BCBC
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhBOPex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhBOPbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB6B164E34;
        Mon, 15 Feb 2021 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402972;
        bh=SKFQENu7INq7P849sQ2+kBobGSIxyjI5eJfGYtCYQqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGTmO6gbij3JkkiZYNa1E1PVROIIYEiAIAFob6k+vupgrCwofeUd/2ikonPRSMv9B
         iCWIiKqiyADtFXq/vP4g5FcPAIGe/YNb6MckG0az+hi4uMVw+0GPCcI2SNqGKe1H6e
         xuVmRQveGxC5alTermeW2Zwzx1X8W+77D2Y8f4Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/60] net: hns3: add a check for queue_id in hclge_reset_vf_queue()
Date:   Mon, 15 Feb 2021 16:27:27 +0100
Message-Id: <20210215152716.617536072@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 67a69f84cab60484f02eb8cbc7a76edffbb28a25 ]

The queue_id is received from vf, if use it directly,
an out-of-bound issue may be caused, so add a check for
this queue_id before using it in hclge_reset_vf_queue().

Fixes: 1a426f8b40fc ("net: hns3: fix the VF queue reset flow error")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6887b7fda6e07..08040cafc06bc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8563,12 +8563,19 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 
 void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id)
 {
+	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
 	int reset_try_times = 0;
 	int reset_status;
 	u16 queue_gid;
 	int ret;
 
+	if (queue_id >= handle->kinfo.num_tqps) {
+		dev_warn(&hdev->pdev->dev, "Invalid vf queue id(%u)\n",
+			 queue_id);
+		return;
+	}
+
 	queue_gid = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 
 	ret = hclge_send_reset_tqp_cmd(hdev, queue_gid, true);
-- 
2.27.0



