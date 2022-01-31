Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803394A410B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358547AbiAaLBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:01:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33372 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358543AbiAaLAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:00:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF73D60B2E;
        Mon, 31 Jan 2022 11:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F3EC340EF;
        Mon, 31 Jan 2022 11:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626846;
        bh=UX7bfLZZjswaacQhiYiq56Uuh1Jos6QIbBnp3bN5WmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZFXv5B1EEgsavwjI/ucDADPBp6dkj8H+dKA61aGAlF73/gcAub7GhqQrABjqMbjZ
         VmKCAUuUS6fG5KKV5zUysbze21ZQycGq121K/CQY/w7SwljuV1dyC0jRJqRRtKO3nP
         1qr9rrGmLkFA/PTQhXRf1MeF3u6v7HW9mGdae3m0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 58/64] net: hns3: handle empty unknown interrupt for VF
Date:   Mon, 31 Jan 2022 11:56:43 +0100
Message-Id: <20220131105217.631535565@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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
index ce6a4e1965e1d..403c1b9cf6ab8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1970,8 +1970,7 @@ static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 		break;
 	}
 
-	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
-		hclgevf_enable_vector(&hdev->misc_vector, true);
+	hclgevf_enable_vector(&hdev->misc_vector, true);
 
 	return IRQ_HANDLED;
 }
-- 
2.34.1



