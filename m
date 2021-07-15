Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E432B3CA8AD
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241234AbhGOTCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242620AbhGOS7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49AAD61158;
        Thu, 15 Jul 2021 18:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375414;
        bh=Urdi0RMyDw7osxiomLrzAYzglhIWs81NXDgqg0/pm+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwFpUAdLCT98+dqH3rt+SC1N8+dpV/cguu359rQdKFOmw/9OmzYhw7T/L9Q1f7BZ7
         KxBlTz+UzvmlwZH5XmUwwDO4XuZGZK8VrgFJeXYrLD7S3gWcs/zOWUfrEk97bmZcfo
         CPW0pt2NkVG1eCM+DeEZZGJqO3Nd9/1jMO3EMIEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 078/242] net: sgi: ioc3-eth: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:20 +0200
Message-Id: <20210715182606.644790006@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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



