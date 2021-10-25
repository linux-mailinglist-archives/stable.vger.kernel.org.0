Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B018B43A141
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhJYTh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236640AbhJYTfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E27496112F;
        Mon, 25 Oct 2021 19:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190317;
        bh=Jb6Kh4rTiM3gtUjlA5XIm/ee8sX1QmV616xtfBG+Qr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLDTfXVtEpCNqTYln+dqO3aOKwBDJC3JSH92HXSNILQ5BUeiLC0c+lGux01Rfaobx
         R5290QAS+qpc6XmeyK3VR35FH6Z13hVGiY54AgKnvYUom/PfAs2DBKLhh5hWeckg4R
         zAPND/HF2ShrFdwxi4n32JYbDgdWgoUKuM2fDSNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/95] net: hns3: fix vf reset workqueue cannot exit
Date:   Mon, 25 Oct 2021 21:14:24 +0200
Message-Id: <20211025191000.826832400@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 1385cc81baeb3bd8cbbbcdc1557f038ac1712529 ]

The task of VF reset is performed through the workqueue. It checks the
value of hdev->reset_pending to determine whether to exit the loop.
However, the value of hdev->reset_pending may also be assigned by
the interrupt function hclgevf_misc_irq_handle(), which may cause the
loop fail to exit and keep occupying the workqueue. This loop is not
necessary, so remove it and the workqueue will be rescheduled if the
reset needs to be retried or a new reset occurs.

Fixes: 1cc9bc6e5867 ("net: hns3: split hclgevf_reset() into preparing and rebuilding part")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 3641d7c31451..a47f23f27a11 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2160,9 +2160,9 @@ static void hclgevf_reset_service_task(struct hclgevf_dev *hdev)
 		hdev->reset_attempts = 0;
 
 		hdev->last_reset_time = jiffies;
-		while ((hdev->reset_type =
-			hclgevf_get_reset_level(hdev, &hdev->reset_pending))
-		       != HNAE3_NONE_RESET)
+		hdev->reset_type =
+			hclgevf_get_reset_level(hdev, &hdev->reset_pending);
+		if (hdev->reset_type != HNAE3_NONE_RESET)
 			hclgevf_reset(hdev);
 	} else if (test_and_clear_bit(HCLGEVF_RESET_REQUESTED,
 				      &hdev->reset_state)) {
-- 
2.33.0



