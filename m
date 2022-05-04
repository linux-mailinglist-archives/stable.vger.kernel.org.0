Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BEA51A725
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354564AbiEDRCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355060AbiEDQ7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A674D4A917;
        Wed,  4 May 2022 09:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D5661794;
        Wed,  4 May 2022 16:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F325C385A4;
        Wed,  4 May 2022 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683074;
        bh=qDEZ8SH3Rn+JKQzBNY97iqp3aZA6lcc2Yd/aMdMD4NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/eEmT5nSbMBkaMHE1qe1PWv4gT/vi8v0DD0IB/rdkorDVVYiDFnlcIPtTIi8fL0I
         7+rkqA482DvJ+jdgjxIHWSjPo2Sx5K6iyf+NZZy3ZeOYncgjNnc2/8lkC2kCPOTMY7
         6uAR0qbPYcwvRvH/ie80oLRBZo5r5ljm3mUcyLDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/129] net: hns3: add return value for mailbox handling in PF
Date:   Wed,  4 May 2022 18:44:30 +0200
Message-Id: <20220504153027.335728646@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit c59d606296842409a6e5a4828235b0bd46b12bc4 ]

Currently, there are some querying mailboxes sent from VF to PF,
and VF will wait the PF's handling result. For mailbox
HCLGE_MBX_GET_QID_IN_PF and HCLGE_MBX_GET_RSS_KEY, it may fail
when the input parameter is invalid, but the prototype of their
handler function is void. In this case, PF always return success
to VF, which may cause the VF get incorrect result.

Fixes it by adding return value for these function.

Fixes: 63b1279d9905 ("net: hns3: check queue id range before using")
Fixes: 532cfc0df1e4 ("net: hns3: add a check for index in hclge_get_rss_key()")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index b948fe3ac56b..51b7b46f2f30 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -584,9 +584,9 @@ static int hclge_set_vf_mtu(struct hclge_vport *vport,
 	return hclge_set_vport_mtu(vport, mtu);
 }
 
-static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
-				     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-				     struct hclge_respond_to_vf_msg *resp_msg)
+static int hclge_get_queue_id_in_pf(struct hclge_vport *vport,
+				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+				    struct hclge_respond_to_vf_msg *resp_msg)
 {
 	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
@@ -596,17 +596,18 @@ static void hclge_get_queue_id_in_pf(struct hclge_vport *vport,
 	if (queue_id >= handle->kinfo.num_tqps) {
 		dev_err(&hdev->pdev->dev, "Invalid queue id(%u) from VF %u\n",
 			queue_id, mbx_req->mbx_src_vfid);
-		return;
+		return -EINVAL;
 	}
 
 	qid_in_pf = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 	memcpy(resp_msg->data, &qid_in_pf, sizeof(qid_in_pf));
 	resp_msg->len = sizeof(qid_in_pf);
+	return 0;
 }
 
-static void hclge_get_rss_key(struct hclge_vport *vport,
-			      struct hclge_mbx_vf_to_pf_cmd *mbx_req,
-			      struct hclge_respond_to_vf_msg *resp_msg)
+static int hclge_get_rss_key(struct hclge_vport *vport,
+			     struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+			     struct hclge_respond_to_vf_msg *resp_msg)
 {
 #define HCLGE_RSS_MBX_RESP_LEN	8
 	struct hclge_dev *hdev = vport->back;
@@ -622,13 +623,14 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 		dev_warn(&hdev->pdev->dev,
 			 "failed to get the rss hash key, the index(%u) invalid !\n",
 			 index);
-		return;
+		return -EINVAL;
 	}
 
 	memcpy(resp_msg->data,
 	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
 	resp_msg->len = HCLGE_RSS_MBX_RESP_LEN;
+	return 0;
 }
 
 static void hclge_link_fail_parse(struct hclge_dev *hdev, u8 link_fail_code)
@@ -807,10 +809,10 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					"VF fail(%d) to set mtu\n", ret);
 			break;
 		case HCLGE_MBX_GET_QID_IN_PF:
-			hclge_get_queue_id_in_pf(vport, req, &resp_msg);
+			ret = hclge_get_queue_id_in_pf(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_RSS_KEY:
-			hclge_get_rss_key(vport, req, &resp_msg);
+			ret = hclge_get_rss_key(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_GET_LINK_MODE:
 			hclge_get_link_mode(vport, req);
-- 
2.35.1



