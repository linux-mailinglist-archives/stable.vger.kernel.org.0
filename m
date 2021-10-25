Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A922143A133
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbhJYThh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236496AbhJYTev (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA1760FDC;
        Mon, 25 Oct 2021 19:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190267;
        bh=A12vJG/IntlvEzY70YMt9ZcQI0BSVV7aJhjxFDoAqrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPIuljchvu8QDukKL8JaoKudamp034qptz9kqQp7cP8C3hlSoUDNCaEs5Tz38Icpl
         uBdAFLgKsrbReCzWVTMwChdT+Aipto/afTlFJSYhEXXvijJvbs+MZKtIy7efVlqDFq
         PkvAXO1QCkrmC+wfzepz0JN7IeEYY0W4ZvkeCUbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/95] net: hns3: add limit ets dwrr bandwidth cannot be 0
Date:   Mon, 25 Oct 2021 21:14:22 +0200
Message-Id: <20211025191000.537591150@linuxfoundation.org>
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
index 28a90ead4795..8e6085753b9f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -134,6 +134,15 @@ static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
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



