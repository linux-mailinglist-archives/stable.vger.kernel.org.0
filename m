Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA611B71E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbfLKQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731210AbfLKPMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36A22464B;
        Wed, 11 Dec 2019 15:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077166;
        bh=8VCYKCYLmWQwWUoJfqKJ05SIdKRPFsPGHNN+S7jyXK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WodKHoJ2tj1hh6PQRfLb5WPEmPg+ISHdZahJPjUmusZQgBTmh8PLN1TSVlc9YXaJa
         RYgDEPHh9ysSy6NUzuryuW3zOZL6sK4yGiIVxZkxv3zLcvFaasSOpEV1Od+MA5h8Vp
         xfcI7v2hA+H1b3j/tcMKw3CwAhS/f77n55JuKEb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 040/105] net: hns3: fix ETS bandwidth validation bug
Date:   Wed, 11 Dec 2019 16:05:29 +0100
Message-Id: <20191211150237.197851307@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit c2d56897819338eb0ba8b93184f7d10329b36653 ]

Some device only support 4 TCs, but the driver check the total
bandwidth of 8 TCs, so may cause wrong configurations write to
the hw.

This patch uses hdev->tc_max to instead HNAE3_MAX_TC to fix it.

Fixes: e432abfb99e5 ("net: hns3: add common validation in hclge_dcb")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index d9136a199d8db..f5c323e798343 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -124,7 +124,7 @@ static int hclge_ets_validate(struct hclge_dev *hdev, struct ieee_ets *ets,
 	if (ret)
 		return ret;
 
-	for (i = 0; i < HNAE3_MAX_TC; i++) {
+	for (i = 0; i < hdev->tc_max; i++) {
 		switch (ets->tc_tsa[i]) {
 		case IEEE_8021QAZ_TSA_STRICT:
 			if (hdev->tm_info.tc_info[i].tc_sch_mode !=
-- 
2.20.1



