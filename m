Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55847551CF1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344677AbiFTNWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344556AbiFTNUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8983B22527;
        Mon, 20 Jun 2022 06:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFC76B811A2;
        Mon, 20 Jun 2022 13:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23813C3411B;
        Mon, 20 Jun 2022 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730462;
        bh=2me0UpX2QGc470gWTPLcXDcdd34FHBXND0Eocd5bEtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q46K9aZ9Pfmx8uCaJmEoLh0cp4SqGedaHSFIIwg59buTA99xluw78kiHlc1ebz09k
         hGyl8yMAM/HzLDBze/95q8K+Vg96ENvyuIImtiAdNdRgj6UDesmVzYEvUrpcMpgV4j
         dsZMiHoto2TeJVs+sNUE8bf0cAFAxTOBdpUS4Dek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/106] net: hns3: split function hclge_update_port_base_vlan_cfg()
Date:   Mon, 20 Jun 2022 14:51:19 +0200
Message-Id: <20220620124726.177904410@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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

[ Upstream commit d25f5eddbe1ace18fa95318fd229b07a64ec4353 ]

Currently the function hclge_update_port_base_vlan_cfg() is a
bit long. Split it to several small functions, to improve the
readability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 69 ++++++++++---------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 892f2f12c54c..cdd1d2ebdde2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10397,12 +10397,41 @@ static bool hclge_need_update_vlan_filter(const struct hclge_vlan_info *new_cfg,
 	return false;
 }
 
+static int hclge_modify_port_base_vlan_tag(struct hclge_vport *vport,
+					   struct hclge_vlan_info *new_info,
+					   struct hclge_vlan_info *old_info)
+{
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	/* add new VLAN tag */
+	ret = hclge_set_vlan_filter_hw(hdev, htons(new_info->vlan_proto),
+				       vport->vport_id, new_info->vlan_tag,
+				       false);
+	if (ret)
+		return ret;
+
+	/* remove old VLAN tag */
+	if (old_info->vlan_tag == 0)
+		ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
+					       true, 0);
+	else
+		ret = hclge_set_vlan_filter_hw(hdev, htons(ETH_P_8021Q),
+					       vport->vport_id,
+					       old_info->vlan_tag, true);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to clear vport%u port base vlan %u, ret = %d.\n",
+			vport->vport_id, old_info->vlan_tag, ret);
+
+	return ret;
+}
+
 int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 				    struct hclge_vlan_info *vlan_info)
 {
 	struct hnae3_handle *nic = &vport->nic;
 	struct hclge_vlan_info *old_vlan_info;
-	struct hclge_dev *hdev = vport->back;
 	int ret;
 
 	old_vlan_info = &vport->port_base_vlan_cfg.vlan_info;
@@ -10415,38 +10444,12 @@ int hclge_update_port_base_vlan_cfg(struct hclge_vport *vport, u16 state,
 	if (!hclge_need_update_vlan_filter(vlan_info, old_vlan_info))
 		goto out;
 
-	if (state == HNAE3_PORT_BASE_VLAN_MODIFY) {
-		/* add new VLAN tag */
-		ret = hclge_set_vlan_filter_hw(hdev,
-					       htons(vlan_info->vlan_proto),
-					       vport->vport_id,
-					       vlan_info->vlan_tag,
-					       false);
-		if (ret)
-			return ret;
-
-		/* remove old VLAN tag */
-		if (old_vlan_info->vlan_tag == 0)
-			ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
-						       true, 0);
-		else
-			ret = hclge_set_vlan_filter_hw(hdev,
-						       htons(ETH_P_8021Q),
-						       vport->vport_id,
-						       old_vlan_info->vlan_tag,
-						       true);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"failed to clear vport%u port base vlan %u, ret = %d.\n",
-				vport->vport_id, old_vlan_info->vlan_tag, ret);
-			return ret;
-		}
-
-		goto out;
-	}
-
-	ret = hclge_update_vlan_filter_entries(vport, state, vlan_info,
-					       old_vlan_info);
+	if (state == HNAE3_PORT_BASE_VLAN_MODIFY)
+		ret = hclge_modify_port_base_vlan_tag(vport, vlan_info,
+						      old_vlan_info);
+	else
+		ret = hclge_update_vlan_filter_entries(vport, state, vlan_info,
+						       old_vlan_info);
 	if (ret)
 		return ret;
 
-- 
2.35.1



