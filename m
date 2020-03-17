Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F571188053
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgCQLJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbgCQLJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:09:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A6D420658;
        Tue, 17 Mar 2020 11:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443356;
        bh=9z7ishqt115JwBLp4vX5r6NTDqceP79ZULTg2EPRlC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2F4xDL8ytsG/VpCZx4oArdIYnZpS1a8IyvLZGg7G1LCPZ9y/GCK32rfZIpxhyOuh7
         HudzpoPuelWpEwEgkl4FXnirNFrTkgoZO3YuzBG4j27hn+c48akS4O5psUfjdsvj2b
         Rmi2u9vZLJ5txxy4cyW4/gub5tEZ/4ATUJ8qpPBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 018/151] net: hns3: fix a not link up issue when fibre port supports autoneg
Date:   Tue, 17 Mar 2020 11:53:48 +0100
Message-Id: <20200317103327.715249731@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 68e1006f618e509fc7869259fe83ceec4a95dac3 ]

When fibre port supports auto-negotiation, the IMP(Intelligent
Management Process) processes the speed of auto-negotiation
and the  user's speed separately.
For below case, the port will get a not link up problem.
step 1: disables auto-negotiation and sets speed to A, then
the driver's MAC speed will be updated to A.
step 2: enables auto-negotiation and MAC gets negotiated
speed B, then the driver's MAC speed will be updated to B
through querying in periodical task.
step 3: MAC gets new negotiated speed A.
step 4: disables auto-negotiation and sets speed to B before
periodical task query new MAC speed A, the driver will  ignore
the speed configuration.

This patch fixes it by skipping speed and duplex checking when
fibre port supports auto-negotiation.

Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2450,10 +2450,12 @@ static int hclge_cfg_mac_speed_dup_hw(st
 
 int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex)
 {
+	struct hclge_mac *mac = &hdev->hw.mac;
 	int ret;
 
 	duplex = hclge_check_speed_dup(duplex, speed);
-	if (hdev->hw.mac.speed == speed && hdev->hw.mac.duplex == duplex)
+	if (!mac->support_autoneg && mac->speed == speed &&
+	    mac->duplex == duplex)
 		return 0;
 
 	ret = hclge_cfg_mac_speed_dup_hw(hdev, speed, duplex);


