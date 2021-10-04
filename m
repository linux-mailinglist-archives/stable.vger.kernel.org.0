Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB46421000
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbhJDNkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238371AbhJDNiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 850FC6159A;
        Mon,  4 Oct 2021 13:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353440;
        bh=FZwgsMyYOtSav5zQPNH1yBIkX+5AlpRp7AQZkNa3UuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuZXvsD1MOOfW517UyNM3Q/w8GXStVEUtcbsTt8lGaxPyNf4vQ+DVCYEalZLokgei
         U5iiY1ztVa25zQLNQOIt9TCkfJBvSjbU58xlXm4KFweCmGwioTUQ6CO0ZYrgJEIeV1
         zkJnALP6WyDXb6mrpENYXRyoXwgsQSD8fHxVnEhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 128/172] net: hns3: fix show wrong state when add existing uc mac address
Date:   Mon,  4 Oct 2021 14:52:58 +0200
Message-Id: <20211004125049.101994260@linuxfoundation.org>
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

[ Upstream commit 108b3c7810e14892c4a1819b1d268a2c785c087c ]

Currently, if function adds an existing unicast mac address, eventhough
driver will not add this address into hardware, but it will return 0 in
function hclge_add_uc_addr_common(). It will cause the state of this
unicast mac address is ACTIVE in driver, but it should be in TO-ADD state.

To fix this problem, function hclge_add_uc_addr_common() returns -EEXIST
if mac address is existing, and delete two error log to avoid printing
them all the time after this modification.

Fixes: 72110b567479 ("net: hns3: return 0 and print warning when hit duplicate MAC")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 90a72c79fec9..9920e76b4f41 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8701,15 +8701,8 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 	}
 
 	/* check if we just hit the duplicate */
-	if (!ret) {
-		dev_warn(&hdev->pdev->dev, "VF %u mac(%pM) exists\n",
-			 vport->vport_id, addr);
-		return 0;
-	}
-
-	dev_err(&hdev->pdev->dev,
-		"PF failed to add unicast entry(%pM) in the MAC table\n",
-		addr);
+	if (!ret)
+		return -EEXIST;
 
 	return ret;
 }
@@ -8861,7 +8854,13 @@ static void hclge_sync_vport_mac_list(struct hclge_vport *vport,
 		} else {
 			set_bit(HCLGE_VPORT_STATE_MAC_TBL_CHANGE,
 				&vport->state);
-			break;
+
+			/* If one unicast mac address is existing in hardware,
+			 * we need to try whether other unicast mac addresses
+			 * are new addresses that can be added.
+			 */
+			if (ret != -EEXIST)
+				break;
 		}
 	}
 }
-- 
2.33.0



