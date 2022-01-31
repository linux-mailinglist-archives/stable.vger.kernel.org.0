Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5FC4A4213
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349384AbiAaLKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53778 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359087AbiAaLFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:05:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 070F1B82A6B;
        Mon, 31 Jan 2022 11:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383ADC340EE;
        Mon, 31 Jan 2022 11:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627150;
        bh=iLf+aQshedKdJMZ/kjXdA49LDG7dvJiXr2Q4KVVJcKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSvNyB8X525aWAbfONEHmyr+hbYOqk4Yr6lG1qbR2aQk3HFExbCqTX3O9hUoB5Vhu
         nwYKbmsPGFISa7JfrLXK29P2CITebjBslLx2O/jveQtkO5Af7p6RQk2ttBgzl731Mq
         IGX7InZCIDwAv6a1kdqBOIS3TSkjWH6QfgmwZK7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/100] net: hns3: handle empty unknown interrupt for VF
Date:   Mon, 31 Jan 2022 11:56:51 +0100
Message-Id: <20220131105223.483458541@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 2f61353cd2f789a4229b6f5c1c24a40a613357bb ]

Since some interrupt states may be cleared by hardware, the driver
may receive an empty interrupt. Currently, the VF driver directly
disables the vector0 interrupt in this case. As a result, the VF
is unavailable. Therefore, the vector0 interrupt should be enabled
in this case.

Fixes: b90fcc5bd904 ("net: hns3: add reset handling for VF when doing Core/Global/IMP reset")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 6e7da1dc2e8c3..d6580e942724d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2382,8 +2382,7 @@ static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 		break;
 	}
 
-	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
-		hclgevf_enable_vector(&hdev->misc_vector, true);
+	hclgevf_enable_vector(&hdev->misc_vector, true);
 
 	return IRQ_HANDLED;
 }
-- 
2.34.1



