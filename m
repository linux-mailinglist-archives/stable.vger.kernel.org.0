Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47CE3CA701
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbhGOSvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239847AbhGOSvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA90613D0;
        Thu, 15 Jul 2021 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374892;
        bh=Urdi0RMyDw7osxiomLrzAYzglhIWs81NXDgqg0/pm+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySVTlL+cP9fLPpAJkMhLHV5mKR/cYa42qaecyGNRk8Pl3t4cnAYRki74fZaS5lqbB
         e9zLvAN9246dDP0u2lc1Ik/mSlSsABKuDC08MZW6Hj/YjDM0xsbD37PJEmtASWCRXW
         i2hQ9FgrnOCudE31IJFHgtBwYB6nxLXvFgExcEdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/215] net: sgi: ioc3-eth: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:23 +0200
Message-Id: <20210715182611.998259495@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit db8f7be1e1d64fbf113a456ef94534fbf5e9a9af ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 6eef0f45b133..2b29fd4cbdf4 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -835,6 +835,10 @@ static int ioc3eth_probe(struct platform_device *pdev)
 	int err;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	/* get mac addr from one wire prom */
 	if (ioc3eth_get_mac_addr(regs, mac_addr))
 		return -EPROBE_DEFER; /* not available yet */
-- 
2.30.2



