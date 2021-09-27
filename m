Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE008419AD8
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbhI0RMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236052AbhI0RKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:10:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED76661252;
        Mon, 27 Sep 2021 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762484;
        bh=RMc65/Qoy7hdYNxTvmFi7XWTegQgZsJPPC8upN/Yw3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1XfGAC/3ddE5yjtqW6I3R50zqS/WhVBG6GjCeMypJmF6aG3O4Dz+ZiJrUMO5Ey/k
         YS7l+66Tk17RRrszu0GX1hYIssSkNTyoU8hRLBgtmMu96jKhOnnBhsCciqkwUp0lqq
         qTUJARZ4dYueHMkRu0/k1+h77BCyTBbRmruRZXKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/103] net: hns3: check queue id range before using
Date:   Mon, 27 Sep 2021 19:02:12 +0200
Message-Id: <20210927170227.128766674@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index 8c528ea33406..8932af32e89d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -581,9 +581,17 @@ static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
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



