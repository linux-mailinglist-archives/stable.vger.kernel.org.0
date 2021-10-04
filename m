Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64DE420FF2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhJDNjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237912AbhJDNho (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F8E0613DB;
        Mon,  4 Oct 2021 13:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353435;
        bh=6znmiAQI0D3L8XyYriWdU5mi/p9+rpxvrGDto5V/CtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEvc+ZPtYuFUChIrG1facdIsIjG3zFPCf4XqON8Q5z/7DDgS3zC25d2SwoJtXvZxh
         SrS1QBTv/ka5d1jhYKreQ1B76iMM9t1f/g6kX5JBR8ihTfTjl2aaIe1ICNXJ1KrKMC
         sMVkCjV8xtDcVlXbT8AvpnNoWoeFZ+GEyk2zaJVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 126/172] net: hns3: dont rollback when destroy mqprio fail
Date:   Mon,  4 Oct 2021 14:52:56 +0200
Message-Id: <20211004125049.041036533@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit d82650be60ee92e7486f755f5387023278aa933f ]

For destroy mqprio is irreversible in stack, so it's unnecessary
to rollback the tc configuration when destroy mqprio failed.
Otherwise, it may cause the configuration being inconsistent
between driver and netstack.

As the failure is usually caused by reset, and the driver will
restore the configuration after reset, so it can keep the
configuration being consistent between driver and hardware.

Fixes: 5a5c90917467 ("net: hns3: add support for tc mqprio offload")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c  | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 5fadfdbc4858..e4f87ffd41ac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -493,12 +493,17 @@ static int hclge_setup_tc(struct hnae3_handle *h,
 	return hclge_notify_init_up(hdev);
 
 err_out:
-	/* roll-back */
-	memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
-	if (hclge_config_tc(hdev, &kinfo->tc_info))
-		dev_err(&hdev->pdev->dev,
-			"failed to roll back tc configuration\n");
-
+	if (!tc) {
+		dev_warn(&hdev->pdev->dev,
+			 "failed to destroy mqprio, will active after reset, ret = %d\n",
+			 ret);
+	} else {
+		/* roll-back */
+		memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
+		if (hclge_config_tc(hdev, &kinfo->tc_info))
+			dev_err(&hdev->pdev->dev,
+				"failed to roll back tc configuration\n");
+	}
 	hclge_notify_init_up(hdev);
 
 	return ret;
-- 
2.33.0



