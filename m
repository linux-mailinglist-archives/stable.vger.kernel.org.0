Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5132731BD30
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhBOPlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhBOPh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D6B64EA0;
        Mon, 15 Feb 2021 15:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403223;
        bh=grc1k0mbQ9jRudH5zA0+n9VImf0+UaRZieI9KyOEOVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvS2PmX048zmbrcU5CLlR4W27PeJbSGRpD+GR79ns/v75qVwqfeD3JT1r0uYAhhCv
         wTfYEsjVx80YEVPwcHiMpt8AzPWML26I+SO1mgVUrTNHOxkqYZrmj9AwbpzIPz0knm
         xlHzohDYvN6tTadTAAEcb5a9H3SQcq2RRbBHaEM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/104] net: hns3: add a check for queue_id in hclge_reset_vf_queue()
Date:   Mon, 15 Feb 2021 16:27:26 +0100
Message-Id: <20210215152721.811226958@linuxfoundation.org>
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

[ Upstream commit 67a69f84cab60484f02eb8cbc7a76edffbb28a25 ]

The queue_id is received from vf, if use it directly,
an out-of-bound issue may be caused, so add a check for
this queue_id before using it in hclge_reset_vf_queue().

Fixes: 1a426f8b40fc ("net: hns3: fix the VF queue reset flow error")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4321132a4f630..c40820baf48a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9404,12 +9404,19 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 
 void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id)
 {
+	struct hnae3_handle *handle = &vport->nic;
 	struct hclge_dev *hdev = vport->back;
 	int reset_try_times = 0;
 	int reset_status;
 	u16 queue_gid;
 	int ret;
 
+	if (queue_id >= handle->kinfo.num_tqps) {
+		dev_warn(&hdev->pdev->dev, "Invalid vf queue id(%u)\n",
+			 queue_id);
+		return;
+	}
+
 	queue_gid = hclge_covert_handle_qid_global(&vport->nic, queue_id);
 
 	ret = hclge_send_reset_tqp_cmd(hdev, queue_gid, true);
-- 
2.27.0



