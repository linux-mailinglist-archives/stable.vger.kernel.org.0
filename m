Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CEB66484A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbjAJSKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239045AbjAJSKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949D19C07
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:07:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8C3261864
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5D9C433D2;
        Tue, 10 Jan 2023 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374060;
        bh=SLCtXeuthS/7mZVAiU1AlaOgkEXYdEdE3v/fzMSQW1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEfsxkelEzMgvH7Ya/T/1n4Eg6KDkEV9K1WYvXESiWmrhM1AopKjYqDLMwFcbenfy
         bsMLN/vO01NXFGPQuZA6tLu3Us5adrwdP9kSejMNE1fR5A5fqsVN2fjuFbDCj0PR7j
         0cbS5aSxxpH6G2kOe/m8ydRHZf3IVhWdtrJkPGtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jian Shen <shenjian15@huawei.com>,
        Hao Lan <lanhao@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 030/148] net: hns3: fix VF promisc mode not update when mac table full
Date:   Tue, 10 Jan 2023 19:02:14 +0100
Message-Id: <20230110180018.167688236@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 8ee57c7b8406c7aa8ca31e014440c87c6383f429 ]

Currently, it missed set HCLGE_VPORT_STATE_PROMISC_CHANGE
flag for VF when vport->overflow_promisc_flags changed.
So the VF won't check whether to update promisc mode in
this case. So add it.

Fixes: 1e6e76101fd9 ("net: hns3: configure promisc mode for VF asynchronously")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 75 +++++++++++--------
 1 file changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7e8a60f2401c..2a1765eed4c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12536,60 +12536,71 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	return ret;
 }
 
-static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+static int hclge_sync_vport_promisc_mode(struct hclge_vport *vport)
 {
-	struct hclge_vport *vport = &hdev->vport[0];
 	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
+	bool uc_en = false;
+	bool mc_en = false;
 	u8 tmp_flags;
+	bool bc_en;
 	int ret;
-	u16 i;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
 		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 		vport->last_promisc_flags = vport->overflow_promisc_flags;
 	}
 
-	if (test_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state)) {
+	if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state))
+		return 0;
+
+	/* for PF */
+	if (!vport->vport_id) {
 		tmp_flags = handle->netdev_flags | vport->last_promisc_flags;
 		ret = hclge_set_promisc_mode(handle, tmp_flags & HNAE3_UPE,
 					     tmp_flags & HNAE3_MPE);
-		if (!ret) {
-			clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				  &vport->state);
+		if (!ret)
 			set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
 				&vport->state);
-		}
+		else
+			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state);
+		return ret;
 	}
 
-	for (i = 1; i < hdev->num_alloc_vport; i++) {
-		bool uc_en = false;
-		bool mc_en = false;
-		bool bc_en;
+	/* for VF */
+	if (vport->vf_info.trusted) {
+		uc_en = vport->vf_info.request_uc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_UPE;
+		mc_en = vport->vf_info.request_mc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE;
+	}
+	bc_en = vport->vf_info.request_bc_en > 0;
 
-		vport = &hdev->vport[i];
+	ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
+					 mc_en, bc_en);
+	if (ret) {
+		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
+		return ret;
+	}
+	hclge_set_vport_vlan_fltr_change(vport);
 
-		if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-					&vport->state))
-			continue;
+	return 0;
+}
 
-		if (vport->vf_info.trusted) {
-			uc_en = vport->vf_info.request_uc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_UPE;
-			mc_en = vport->vf_info.request_mc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_MPE;
-		}
-		bc_en = vport->vf_info.request_bc_en > 0;
+static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport;
+	int ret;
+	u16 i;
 
-		ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
-						 mc_en, bc_en);
-		if (ret) {
-			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				&vport->state);
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+
+		ret = hclge_sync_vport_promisc_mode(vport);
+		if (ret)
 			return;
-		}
-		hclge_set_vport_vlan_fltr_change(vport);
 	}
 }
 
-- 
2.35.1



