Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C67273F00
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388027AbfGXU3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387685AbfGXTdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:33:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B930120659;
        Wed, 24 Jul 2019 19:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996818;
        bh=1UxkEgMDGesnIPbV3F1ENZaDuBaggGu38f6L0zhjtCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiLc3CBb8W6abkTNBRYltzCMfUmt2dNQPHetchdS8z6zbX35vNEwqcYlOnbAVNbWZ
         Tu/F/0PFwJV44Ca7PGZUQSGLvfe0HVcy1ut4ZJRGRGkTTk55QQ0pQry+d4Qj76TqUb
         mSh4jVvnx2Z/qxQHU2DsxglRJyTgM0GuIcJoDPOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 227/413] net: hns3: fix port capbility updating issue
Date:   Wed, 24 Jul 2019 21:18:38 +0200
Message-Id: <20190724191751.215518732@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 49b1255603de5183c5e377200be3b3afe0dcdb86 ]

Currently, the driver queries the media port information, and
updates the port capability periodically. But it sets an error
mac->speed_type value, which stops update port capability.

Fixes: 88d10bd6f730 ("net: hns3: add support for multiple media type")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bab04d2d674a..f2bffc05e902 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2592,6 +2592,7 @@ static int hclge_get_sfp_info(struct hclge_dev *hdev, struct hclge_mac *mac)
 		mac->speed_ability = le32_to_cpu(resp->speed_ability);
 		mac->autoneg = resp->autoneg;
 		mac->support_autoneg = resp->autoneg_ability;
+		mac->speed_type = QUERY_ACTIVE_SPEED;
 		if (!resp->active_fec)
 			mac->fec_mode = 0;
 		else
-- 
2.20.1



