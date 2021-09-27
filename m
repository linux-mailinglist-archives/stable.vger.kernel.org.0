Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10D4419BE1
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbhI0RXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237117AbhI0RV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16DB56136A;
        Mon, 27 Sep 2021 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762822;
        bh=sImdJO25MZRSWLYp99LzW631akTAOgNgNl2QosUSSM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvFYaNjMGSIeH1EADvQAVXXYwKQmC7wP36j/G6JX1vZNCqk5GXChBjuvCdBpvi7CW
         NWVW1PrmsmegT/o1xlQSXsGJuo1e2Gb3fi/BaShcK1zeaLxSjId1Wk07pIlUrQ13MC
         02BO9YoECoXHnYv5lx/YJdQjzIku3VwR6tZaoByw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaran Zhang <zhangjiaran@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 065/162] net: hns3: fix misuse vf id and vport id in some logs
Date:   Mon, 27 Sep 2021 19:01:51 +0200
Message-Id: <20210927170235.714884882@linuxfoundation.org>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

[ Upstream commit 311c0aaa9b4bb8dc65f22634e15963316b17c921 ]

vport_id include PF and VFs, vport_id = 0 means PF, other values mean VFs.
So the actual vf id is equal to vport_id minus 1.

Some VF print logs are actually vport, and logs of vf id actually use
vport id, so this patch fixes them.

Fixes: ac887be5b0fe ("net: hns3: change print level of RAS error log from warning to error")
Fixes: adcf738b804b ("net: hns3: cleanup some print format warning")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  8 ++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 ++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index ec9a7f8bc3fe..2eeafd61a07e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1878,12 +1878,12 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 		return;
 	}
 
-	dev_err(dev, "PPU_PF_ABNORMAL_INT_ST over_8bd_no_fe found, vf_id(%u), queue_id(%u)\n",
+	dev_err(dev, "PPU_PF_ABNORMAL_INT_ST over_8bd_no_fe found, vport(%u), queue_id(%u)\n",
 		vf_id, q_id);
 
 	if (vf_id) {
 		if (vf_id >= hdev->num_alloc_vport) {
-			dev_err(dev, "invalid vf id(%u)\n", vf_id);
+			dev_err(dev, "invalid vport(%u)\n", vf_id);
 			return;
 		}
 
@@ -1896,8 +1896,8 @@ static void hclge_handle_over_8bd_err(struct hclge_dev *hdev,
 
 		ret = hclge_inform_reset_assert_to_vf(&hdev->vport[vf_id]);
 		if (ret)
-			dev_err(dev, "inform reset to vf(%u) failed %d!\n",
-				hdev->vport->vport_id, ret);
+			dev_err(dev, "inform reset to vport(%u) failed %d!\n",
+				vf_id, ret);
 	} else {
 		set_bit(HNAE3_FUNC_RESET, reset_requests);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 45faf924bc36..3f8d56ccc057 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3660,7 +3660,8 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
 				"set vf(%u) rst failed %d!\n",
-				vport->vport_id, ret);
+				vport->vport_id - HCLGE_VF_VPORT_START_NUM,
+				ret);
 			return ret;
 		}
 
@@ -3675,7 +3676,8 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 		if (ret)
 			dev_warn(&hdev->pdev->dev,
 				 "inform reset to vf(%u) failed %d!\n",
-				 vport->vport_id, ret);
+				 vport->vport_id - HCLGE_VF_VPORT_START_NUM,
+				 ret);
 	}
 
 	return 0;
@@ -11460,11 +11462,11 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
 		struct hclge_vport *vport = &hdev->vport[i];
 		int ret;
 
-		 /* Send cmd to clear VF's FUNC_RST_ING */
+		 /* Send cmd to clear vport's FUNC_RST_ING */
 		ret = hclge_set_vf_rst(hdev, vport->vport_id, false);
 		if (ret)
 			dev_warn(&hdev->pdev->dev,
-				 "clear vf(%u) rst failed %d!\n",
+				 "clear vport(%u) rst failed %d!\n",
 				 vport->vport_id, ret);
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 0dbed35645ed..91c32f99b644 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -564,7 +564,7 @@ static int hclge_reset_vf(struct hclge_vport *vport)
 	struct hclge_dev *hdev = vport->back;
 
 	dev_warn(&hdev->pdev->dev, "PF received VF reset request from VF %u!",
-		 vport->vport_id);
+		 vport->vport_id - HCLGE_VF_VPORT_START_NUM);
 
 	return hclge_func_reset_cmd(hdev, vport->vport_id);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 78d5bf1ea561..44618cc4cca1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -581,7 +581,7 @@ int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
 		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
-				"vf%u, qs%u failed to set tx_rate:%d, ret=%d\n",
+				"vport%u, qs%u failed to set tx_rate:%d, ret=%d\n",
 				vport->vport_id, shap_cfg_cmd->qs_id,
 				max_tx_rate, ret);
 			return ret;
-- 
2.33.0



