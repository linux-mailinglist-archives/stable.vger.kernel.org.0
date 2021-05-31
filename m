Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A0A396292
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhEaO55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234138AbhEaOzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:55:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92B1C6144A;
        Mon, 31 May 2021 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469593;
        bh=R0vlZ6sQS4fAcvQpJozlxvCjEPSH13cje2YqNOsS4AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/rV5ZGDlZVEecvL5Pm/V1vUi/FtiDBtoIYAbCbKLyRlMqt8McLj0Lrtb0ywLe4T8
         eNKVJ7ZjWEZsq6wNtt7T699AhdqUcR6Z03znHgMi0L/gi2d3bMfZWZnymDkirq5Dde
         FNhwYGoNol2kotiWZs9W8uUQ25eIW2CheXuTbd30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 258/296] net: hns3: fix incorrect resp_msg issue
Date:   Mon, 31 May 2021 15:15:13 +0200
Message-Id: <20210531130712.430374088@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

[ Upstream commit a710b9ffbebaf713f7dbd4dbd9524907e5d66f33 ]

In hclge_mbx_handler(), if there are two consecutive mailbox
messages that requires resp_msg, the resp_msg is not cleared
after processing the first message, which will cause the resp_msg
data of second message incorrect.

Fix it by clearing the resp_msg before processing every mailbox
message.

Fixes: bb5790b71bad ("net: hns3: refactor mailbox response scheme between PF and VF")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index c3bb16b1f060..9265a00de18e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -694,7 +694,6 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 	unsigned int flag;
 	int ret = 0;
 
-	memset(&resp_msg, 0, sizeof(resp_msg));
 	/* handle all the mailbox requests in the queue */
 	while (!hclge_cmd_crq_empty(&hdev->hw)) {
 		if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state)) {
@@ -722,6 +721,9 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 
 		trace_hclge_pf_mbx_get(hdev, req);
 
+		/* clear the resp_msg before processing every mailbox message */
+		memset(&resp_msg, 0, sizeof(resp_msg));
+
 		switch (req->msg.code) {
 		case HCLGE_MBX_MAP_RING_TO_VECTOR:
 			ret = hclge_map_unmap_ring_to_vf_vector(vport, true,
-- 
2.30.2



