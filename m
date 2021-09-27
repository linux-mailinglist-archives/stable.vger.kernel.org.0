Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BAB419C22
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhI0RZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237779AbhI0RXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 905E961178;
        Mon, 27 Sep 2021 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762906;
        bh=Ngtfc/ZT5UQBoTe3PuwKULQ/RYpuQzVTbWrXG14zjjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSot7gg9pHc9ajXJDk0Jqfw6g8P9qT2n02W6gFjNts5lMEzjfQTE6PvUhofln8jHX
         o36jVBUI68w9zvGXJUejQ+3FF1wa9laxEAf0R+I0AMrgFBc5Hu1JRaM86BOuwgLBmN
         NcEBFr0Ku9b2x+Fl36/3yipX436t23GwnqlChosg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 063/162] net: hns3: fix change RSS hfunc ineffective issue
Date:   Mon, 27 Sep 2021 19:01:49 +0200
Message-Id: <20210927170235.650772669@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit e184cec5e29d8eb3c3435b12a9074b75e2d69e4a ]

When user change rss 'hfunc' without set rss 'hkey' by ethtool
-X command, the driver will ignore the 'hfunc' for the hkey is
NULL. It's unreasonable. So fix it.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Fixes: 374ad291762a ("net: hns3: Add RSS general configuration support for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 45 ++++++++++------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 52 ++++++++++++-------
 2 files changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 72d55c028ac4..40c4949eed4d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4734,6 +4734,24 @@ static int hclge_get_rss(struct hnae3_handle *handle, u32 *indir,
 	return 0;
 }
 
+static int hclge_parse_rss_hfunc(struct hclge_vport *vport, const u8 hfunc,
+				 u8 *hash_algo)
+{
+	switch (hfunc) {
+	case ETH_RSS_HASH_TOP:
+		*hash_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
+		return 0;
+	case ETH_RSS_HASH_XOR:
+		*hash_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
+		return 0;
+	case ETH_RSS_HASH_NO_CHANGE:
+		*hash_algo = vport->rss_algo;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			 const  u8 *key, const  u8 hfunc)
 {
@@ -4743,30 +4761,27 @@ static int hclge_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	u8 hash_algo;
 	int ret, i;
 
+	ret = hclge_parse_rss_hfunc(vport, hfunc, &hash_algo);
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "invalid hfunc type %u\n", hfunc);
+		return ret;
+	}
+
 	/* Set the RSS Hash Key if specififed by the user */
 	if (key) {
-		switch (hfunc) {
-		case ETH_RSS_HASH_TOP:
-			hash_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
-			break;
-		case ETH_RSS_HASH_XOR:
-			hash_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
-			break;
-		case ETH_RSS_HASH_NO_CHANGE:
-			hash_algo = vport->rss_algo;
-			break;
-		default:
-			return -EINVAL;
-		}
-
 		ret = hclge_set_rss_algo_key(hdev, hash_algo, key);
 		if (ret)
 			return ret;
 
 		/* Update the shadow RSS key with user specified qids */
 		memcpy(vport->rss_hash_key, key, HCLGE_RSS_KEY_SIZE);
-		vport->rss_algo = hash_algo;
+	} else {
+		ret = hclge_set_rss_algo_key(hdev, hash_algo,
+					     vport->rss_hash_key);
+		if (ret)
+			return ret;
 	}
+	vport->rss_algo = hash_algo;
 
 	/* Update the shadow RSS table with user specified qids */
 	for (i = 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index be3ea7023ed8..22cf66004dfa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -814,40 +814,56 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 	return 0;
 }
 
+static int hclgevf_parse_rss_hfunc(struct hclgevf_dev *hdev, const u8 hfunc,
+				   u8 *hash_algo)
+{
+	switch (hfunc) {
+	case ETH_RSS_HASH_TOP:
+		*hash_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
+		return 0;
+	case ETH_RSS_HASH_XOR:
+		*hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
+		return 0;
+	case ETH_RSS_HASH_NO_CHANGE:
+		*hash_algo = hdev->rss_cfg.hash_algo;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 			   const u8 *key, const u8 hfunc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
+	u8 hash_algo;
 	int ret, i;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+		ret = hclgevf_parse_rss_hfunc(hdev, hfunc, &hash_algo);
+		if (ret)
+			return ret;
+
 		/* Set the RSS Hash Key if specififed by the user */
 		if (key) {
-			switch (hfunc) {
-			case ETH_RSS_HASH_TOP:
-				rss_cfg->hash_algo =
-					HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
-				break;
-			case ETH_RSS_HASH_XOR:
-				rss_cfg->hash_algo =
-					HCLGEVF_RSS_HASH_ALGO_SIMPLE;
-				break;
-			case ETH_RSS_HASH_NO_CHANGE:
-				break;
-			default:
-				return -EINVAL;
-			}
-
-			ret = hclgevf_set_rss_algo_key(hdev, rss_cfg->hash_algo,
-						       key);
-			if (ret)
+			ret = hclgevf_set_rss_algo_key(hdev, hash_algo, key);
+			if (ret) {
+				dev_err(&hdev->pdev->dev,
+					"invalid hfunc type %u\n", hfunc);
 				return ret;
+			}
 
 			/* Update the shadow RSS key with user specified qids */
 			memcpy(rss_cfg->rss_hash_key, key,
 			       HCLGEVF_RSS_KEY_SIZE);
+		} else {
+			ret = hclgevf_set_rss_algo_key(hdev, hash_algo,
+						       rss_cfg->rss_hash_key);
+			if (ret)
+				return ret;
 		}
+		rss_cfg->hash_algo = hash_algo;
 	}
 
 	/* update the shadow RSS table with user specified qids */
-- 
2.33.0



