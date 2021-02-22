Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B15321656
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhBVMUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbhBVMQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC8FD64F0E;
        Mon, 22 Feb 2021 12:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996192;
        bh=Wxk1ijMviDHa6qy0buBtIBerW4GldoSIePKM9BhpQcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcPBQM039apsYbMT4VxJRykBfEVzFG+ihJEE0nP+hRIK0unDVHX1RejGD0q2pgLR6
         k/wwjgfwLPlv++ztkKWo6zeZUvE+F0LqIhqoqmPadhGHfhDepffWW+Z7cSQ9EYrxdl
         TqE4rUCbtwcpnJWFnJmwCUjsNdVuDaiqmFhsmMfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/50] net: hns3: add a check for queue_id in hclge_reset_vf_queue()
Date:   Mon, 22 Feb 2021 13:13:14 +0100
Message-Id: <20210222121024.494373702@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
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
index d575dd9a329d9..16ab000454f91 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5182,12 +5182,19 @@ void hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 
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



