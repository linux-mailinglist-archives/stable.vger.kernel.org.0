Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D469F1881CE
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgCQLBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgCQLBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:01:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D0D20736;
        Tue, 17 Mar 2020 11:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442860;
        bh=ttFVe+yP36IF+RprTIdY9BFpzGWzZDHW0WaLD4WWx9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUgh0dvJdduo5/70VabBqpdIJwTCEV4zqq9fdk77frZChNRacMnE2m78Q4FrKkMnJ
         kQho31kDHmSpMqa/HX7YPapgFP4Lgwhi+qARuxnNPjcETROP+AopI4BwhjyCtmQWzL
         z/ZcUZq+nWh1mA17iaCaxYxf8gqR8dnYyGGKsZoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 017/123] net: hns3: fix a not link up issue when fibre port supports autoneg
Date:   Tue, 17 Mar 2020 11:54:04 +0100
Message-Id: <20200317103309.499210595@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
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
@@ -2417,10 +2417,12 @@ static int hclge_cfg_mac_speed_dup_hw(st
 
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


