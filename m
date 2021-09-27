Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D782E419BE6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbhI0RXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236274AbhI0RVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 472796121E;
        Mon, 27 Sep 2021 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762830;
        bh=1QTACPbaBB0Y5rgcUZwZESEjSyPBFncz9BYY+K9H6Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gbf1ArLww4ojFbpWxBjeaebNBS9Wm8rJMUkPUUJRH1arpkmQzTQwtQH7Dz71jG1UV
         tfauSMDQ9ZyZVleQ+N10xvJd4CHta4i+C+LygvlhPcP0KsrY+yf0EvsGohaqspD5ve
         Ai56+xu+HpzORE9nKJxG6zTT4vzv5zqJHKzAxFXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 068/162] net: hns3: fix a return value error in hclge_get_reset_status()
Date:   Mon, 27 Sep 2021 19:01:54 +0200
Message-Id: <20210927170235.816375301@linuxfoundation.org>
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

[ Upstream commit 5126b9d3d4acdebc12b9d436282f88d8a1b5146c ]

hclge_get_reset_status() should return the tqp reset status.
However, if the CMDQ fails, the caller will take it as tqp reset
success status by mistake. Therefore, uses a parameters to get
the tqp reset status instead.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 556dfc854763..90a72c79fec9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10719,7 +10719,8 @@ static int hclge_reset_tqp_cmd_send(struct hclge_dev *hdev, u16 queue_id,
 	return 0;
 }
 
-static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id)
+static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id,
+				  u8 *reset_status)
 {
 	struct hclge_reset_tqp_queue_cmd *req;
 	struct hclge_desc desc;
@@ -10737,7 +10738,9 @@ static int hclge_get_reset_status(struct hclge_dev *hdev, u16 queue_id)
 		return ret;
 	}
 
-	return hnae3_get_bit(req->ready_to_reset, HCLGE_TQP_RESET_B);
+	*reset_status = hnae3_get_bit(req->ready_to_reset, HCLGE_TQP_RESET_B);
+
+	return 0;
 }
 
 u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id)
@@ -10756,7 +10759,7 @@ static int hclge_reset_tqp_cmd(struct hnae3_handle *handle)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	u16 reset_try_times = 0;
-	int reset_status;
+	u8 reset_status;
 	u16 queue_gid;
 	int ret;
 	u16 i;
@@ -10772,7 +10775,11 @@ static int hclge_reset_tqp_cmd(struct hnae3_handle *handle)
 		}
 
 		while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
-			reset_status = hclge_get_reset_status(hdev, queue_gid);
+			ret = hclge_get_reset_status(hdev, queue_gid,
+						     &reset_status);
+			if (ret)
+				return ret;
+
 			if (reset_status)
 				break;
 
-- 
2.33.0



