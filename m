Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C135B889
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhDLCXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236608AbhDLCXT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 889186120F;
        Mon, 12 Apr 2021 02:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194182;
        bh=F/1qehbeTQ9FMyWP+b2I7kh8gor8lI7M2/T8+rBRT+Q=;
        h=From:To:Cc:Subject:Date:From;
        b=pyT7Jtb18jhRMVu0o66388hMlIHeGJYLeXr2gLN/XK20yIkpiUfUK2H0KRftV8Jzt
         UQDRn5zSjL0m/Xm0tz1R2jC9tCwHyzSbq3ZgDGACbxvux82S9YL6m0mJQwDlJY6NM1
         vv2ce2cdRN25j/FZn4gCmunNhww9/AIC5b8wnZU0WnrSHFz+WtgE6Ua5vuZHspU2OA
         i5rHix/eC2sFJPwaNiiK44N0IkyvoHLoSnjKzI/14QlDS7OBC9UMFrkWd7Z656Z+wH
         vE9GK/947PdKR2c9pOlrCA7WoUDKb4G6pK+jN+49uxR6eJCMQ+k0EPaNpXPxpArqYA
         JKNhb8/Mcfm5g==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, huangguangbin2@huawei.com
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "net: hns3: clear VF down state bit before request link status" failed to apply to 4.19-stable tree
Date:   Sun, 11 Apr 2021 22:23:00 -0400
Message-Id: <20210412022300.283614-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From ed7bedd2c3ca040f1e8ea02c6590a93116b1ec78 Mon Sep 17 00:00:00 2001
From: Guangbin Huang <huangguangbin2@huawei.com>
Date: Tue, 6 Apr 2021 21:10:43 +0800
Subject: [PATCH] net: hns3: clear VF down state bit before request link status

Currently, the VF down state bit is cleared after VF sending
link status request command. There is problem that when VF gets
link status replied from PF, the down state bit may still set
as 1. In this case, the link status replied from PF will be
ignored and always set VF link status to down.

To fix this problem, clear VF down state bit before VF requests
link status.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 700e068764c8..14b83eca0a5e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2624,14 +2624,14 @@ static int hclgevf_ae_start(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
+	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
+
 	hclgevf_reset_tqp_stats(handle);
 
 	hclgevf_request_link_info(hdev);
 
 	hclgevf_update_link_mode(hdev);
 
-	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
-
 	return 0;
 }
 
-- 
2.30.2




