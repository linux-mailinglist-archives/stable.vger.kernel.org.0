Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1641C47AD28
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhLTOul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:50:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38566 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbhLTOsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23EBE6119E;
        Mon, 20 Dec 2021 14:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05907C36AE7;
        Mon, 20 Dec 2021 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011680;
        bh=H8nEWLBfly227va2lh+trTW2ggB7Q5uq1uCN8EYUpC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwChPRA/MOzgS6HWzKTnxz/7paVvbTTMojj53hAk5TdlI1wRzLqzeXYdrPSw0Pa5V
         qZOJ/D6T5bPDiNJdU9XZ8weRdaMrADiknshV/NF3BI8BB4X4fI6FysVGXWu2JesNd7
         vFGF88d25RnIbu5q6kU00lTGdLQ/TjUKYCK0g/Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/99] net: hns3: fix use-after-free bug in hclgevf_send_mbx_msg
Date:   Mon, 20 Dec 2021 15:34:08 +0100
Message-Id: <20211220143030.548532914@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 27cbf64a766e86f068ce6214f04c00ceb4db1af4 ]

Currently, the hns3_remove function firstly uninstall client instance,
and then uninstall acceletion engine device. The netdevice is freed in
client instance uninstall process, but acceletion engine device uninstall
process still use it to trace runtime information. This causes a use after
free problem.

So fixes it by check the instance register state to avoid use after free.

Fixes: d8355240cf8f ("net: hns3: add trace event support for PF/VF mailbox")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 5b2dcd97c1078..b8e5ca6700ed5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -109,7 +109,8 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 
 	memcpy(&req->msg, send_msg, sizeof(struct hclge_vf_to_pf_msg));
 
-	trace_hclge_vf_mbx_send(hdev, req);
+	if (test_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state))
+		trace_hclge_vf_mbx_send(hdev, req);
 
 	/* synchronous send */
 	if (need_resp) {
-- 
2.33.0



