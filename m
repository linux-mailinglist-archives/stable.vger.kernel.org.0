Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F0231BEF0
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 17:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhBOQVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 11:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhBOPq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:46:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE9064EC0;
        Mon, 15 Feb 2021 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403324;
        bh=Hqraj+gjq6jLAt7EoKIIfleXiDxSneSE6qKy00InmPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ED9eASDnn1NTGcAckbbBCl+ADGsbNDiIqGQfmQBopBbWu/bVFwpsYdyCeLir/qd0m
         URkx/hCtyzke8I6mmP7MIQVoUMVtqsZYMelQWb+Sy7plMqDmTXm+M3Xp3JQakRneT+
         +OCCz0Pkb7Dqwjx386AfW2glvBEBN0VjZkl7Huvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/104] net: hns3: add a check for index in hclge_get_rss_key()
Date:   Mon, 15 Feb 2021 16:27:28 +0100
Message-Id: <20210215152721.874054509@linuxfoundation.org>
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

[ Upstream commit 532cfc0df1e4d68e74522ef4a0dcbf6ebbe68287 ]

The index is received from vf, if use it directly,
an out-of-bound issue may be caused, so add a check for
this index before using it in hclge_get_rss_key().

Fixes: a638b1d8cc87 ("net: hns3: fix get VF RSS issue")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c    | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index c997c90371550..9c8004fc9dc4f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -591,6 +591,17 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 
 	index = mbx_req->msg.data[0];
 
+	/* Check the query index of rss_hash_key from VF, make sure no
+	 * more than the size of rss_hash_key.
+	 */
+	if (((index + 1) * HCLGE_RSS_MBX_RESP_LEN) >
+	      sizeof(vport[0].rss_hash_key)) {
+		dev_warn(&hdev->pdev->dev,
+			 "failed to get the rss hash key, the index(%u) invalid !\n",
+			 index);
+		return;
+	}
+
 	memcpy(resp_msg->data,
 	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
-- 
2.27.0



