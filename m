Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EB121FBBB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbgGNS4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbgGNS4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 415BA22B45;
        Tue, 14 Jul 2020 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752990;
        bh=Tq7/FqVQvTwhdxSjTAKQNwEt8Q2oDTiDVywv3QE008I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4XV/elmHMQE8PURUJdExs7bh7mV1Xow4wn8+5qaGCqQbaas1Yr/Gf7JK4b8NilpW
         ztYiMrGN2/yamVm9+1EZUGP2kr5Yuha0ow24qw7PABY3ue4OP8JU5SpadiEXzMNgb7
         oNjAtsrwMlWkAKmpn39CViGRwEcsAo0SeLcwsKMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 077/166] net: hns3: check reset pending after FLR prepare
Date:   Tue, 14 Jul 2020 20:44:02 +0200
Message-Id: <20200714184119.538318293@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit bb3d866882c280a85e8950d4d72af1e294d2e69c ]

If there is a PF reset pending before FLR prepare, FLR's
preparatory work will not fail, but the FLR rebuild procedure
will fail for this pending. So this PF reset pending should
be handled in the FLR preparatory.

Fixes: 8627bdedc435 ("net: hns3: refactor the precedure of PF FLR")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a758f9ae32be9..4de268a879582 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9351,7 +9351,7 @@ static void hclge_flr_prepare(struct hnae3_ae_dev *ae_dev)
 	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 	hdev->reset_type = HNAE3_FLR_RESET;
 	ret = hclge_reset_prepare(hdev);
-	if (ret) {
+	if (ret || hdev->reset_pending) {
 		dev_err(&hdev->pdev->dev, "fail to prepare FLR, ret=%d\n",
 			ret);
 		if (hdev->reset_pending ||
-- 
2.25.1



