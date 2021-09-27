Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C57419BE3
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbhI0RXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237119AbhI0RV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD4DA61354;
        Mon, 27 Sep 2021 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762825;
        bh=t/SA1DhEuCKXKOztdgcGndYk60fY7ugI9AnxuDRSGms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sooUIp3yhOIihuKuGoqEy3715UNU+bJWzHBWp4KTOQPTuiq3NL2uyt1tlanr7MHV2
         ZOrlYFNZ6CnxwV87+p1LzS29UFdT5mYUbqmpzieGxl6axJfUBK51saw5EH8Vn+ZlhV
         Xaqwdp2apinGHY49zaL4ngJpOP8sj5tcKVpzWV7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 066/162] net: hns3: check queue id range before using
Date:   Mon, 27 Sep 2021 19:01:52 +0200
Message-Id: <20210927170235.747671577@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 63b1279d9905100a14da9e043de7b28e99dba3f8 ]

The input parameters may not be reliable. Before using the
queue id, we should check this parameter. Otherwise, memory
overwriting may occur.

Fixes: d34100184685 ("net: hns3: refactor the mailbox message between PF and VF")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 91c32f99b644..c1a4b79a7050 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -588,9 +588,17 @@ static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 				     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
 				     struct hclge_respond_to_vf_msg *resp_msg)
 {
+	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
 	u16 queue_id, qid_in_pf;
 
 	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
+	if (queue_id >= handle->kinfo.num_tqps) {
+		dev_err(&hdev->pdev->dev, "Invalid queue id(%u) from VF %u\n",
+			queue_id, mbx_req->mbx_src_vfid);
+		return;
+	}
+
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 	memcpy(resp_msg->data, &qid_in_pf, sizeof(qid_in_pf));
 	resp_msg->len = sizeof(qid_in_pf);
-- 
2.33.0



