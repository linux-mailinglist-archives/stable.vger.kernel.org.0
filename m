Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7776A43A03E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhJYT3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234725AbhJYT1m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:27:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C561061152;
        Mon, 25 Oct 2021 19:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189858;
        bh=zTglR+b7FxF17ziIzHYBD3U3RzZu7fN7JHvevCvfZ+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F44YN0CC6a72JAnXTxebmSPyzn5VyfkGbmUbS4ExlP0lDeORNZpXWyQWe/Yex2WL8
         fZSko93X9lgj0MxZ8rFe/X2xNNO9c1oyCD6P8fGUoEMoNql/KS5EafaHWoYfMPSgXN
         ExdCm1oxphnjgYH6JJ0vGwGWOcbdPP2+I+xtKrdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/37] net: hns3: add limit ets dwrr bandwidth cannot be 0
Date:   Mon, 25 Oct 2021 21:14:35 +0200
Message-Id: <20211025190930.255723800@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 731797fdffa3d083db536e2fdd07ceb050bb40b1 ]

If ets dwrr bandwidth of tc is set to 0, the hardware will switch to SP
mode. In this case, this tc may occupy all the tx bandwidth if it has
huge traffic, so it violates the purpose of the user setting.

To fix this problem, limit the ets dwrr bandwidth must greater than 0.

Fixes: cacde272dd00 ("net: hns3: Add hclge_dcb module for the support of DCB feature")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index dd935cd1fb44..865d27aea7d7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -96,6 +96,15 @@ static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
 				*changed = true;
 			break;
 		case IEEE_8021QAZ_TSA_ETS:
+			/* The hardware will switch to sp mode if bandwidth is
+			 * 0, so limit ets bandwidth must be greater than 0.
+			 */
+			if (!ets->tc_tx_bw[i]) {
+				dev_err(&hdev->pdev->dev,
+					"tc%u ets bw cannot be 0\n", i);
+				return -EINVAL;
+			}
+
 			if (hdev->tm_info.tc_info[i].tc_sch_mode !=
 				HCLGE_SCH_MODE_DWRR)
 				*changed = true;
-- 
2.33.0



