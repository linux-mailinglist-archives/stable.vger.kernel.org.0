Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666EE31BD28
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhBOPlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231557AbhBOPiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 361D164EB1;
        Mon, 15 Feb 2021 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403225;
        bh=2hljRmYRsaCubJA6yh5FcPHKxO/+/e/4mzZZ0NUXBqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3E17FKS5MHYwsRqFofuwvNASKQTVTcnrx1eyLHXPKO8hkGHtA2fT5JBWh2gK3QHt
         aDl5aounkbBC79ZLGgcwhS/wWeVR5b5AM/rfmiFSlmag02lGonvFS94vxh24B6yrK+
         wwwlCQlzAU4lIaFcp9+0J4ZQwlOCvuaUU/JHBmsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/104] net: hns3: add a check for tqp_index in hclge_get_ring_chain_from_mbx()
Date:   Mon, 15 Feb 2021 16:27:27 +0100
Message-Id: <20210215152721.840893688@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 326334aad024a60f46dc5e7dbe1efe32da3ca66f ]

The tqp_index is received from vf, if use it directly,
an out-of-bound issue may be caused, so add a check for
this tqp_index before using it in hclge_get_ring_chain_from_mbx().

Fixes: 84e095d64ed9 ("net: hns3: Change PF to add ring-vect binding & resetQ to mailbox")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 3ab6db2588d31..c997c90371550 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -158,21 +158,31 @@ static int hclge_get_ring_chain_from_mbx(
 			struct hclge_vport *vport)
 {
 	struct hnae3_ring_chain_node *cur_chain, *new_chain;
+	struct hclge_dev *hdev = vport->back;
 	int ring_num;
-	int i = 0;
+	int i;
 
 	ring_num = req->msg.ring_num;
 
 	if (ring_num > HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM)
 		return -ENOMEM;
 
+	for (i = 0; i < ring_num; i++) {
+		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
+			dev_err(&hdev->pdev->dev, "tqp index(%u) is out of range(0-%u)\n",
+				req->msg.param[i].tqp_index,
+				vport->nic.kinfo.rss_size - 1);
+			return -EINVAL;
+		}
+	}
+
 	hnae3_set_bit(ring_chain->flag, HNAE3_RING_TYPE_B,
-		      req->msg.param[i].ring_type);
+		      req->msg.param[0].ring_type);
 	ring_chain->tqp_index =
 		hclge_get_queue_id(vport->nic.kinfo.tqp
-				   [req->msg.param[i].tqp_index]);
+				   [req->msg.param[0].tqp_index]);
 	hnae3_set_field(ring_chain->int_gl_idx, HNAE3_RING_GL_IDX_M,
-			HNAE3_RING_GL_IDX_S, req->msg.param[i].int_gl_index);
+			HNAE3_RING_GL_IDX_S, req->msg.param[0].int_gl_index);
 
 	cur_chain = ring_chain;
 
-- 
2.27.0



