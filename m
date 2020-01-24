Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FF3148482
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733175AbgAXLLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731122AbgAXLLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:11:09 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A0B020708;
        Fri, 24 Jan 2020 11:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864268;
        bh=ve1OCC4JQ1RHqCH6kBY51jI1ez7VQNaWeqSXiQ0bBOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLIY/trfLOGG8Zjkp7SyUwqw2F8f7B+c6AJbMLPH3P89v1biiLXuFdlrYrqmdlert
         He4V240e5Kr++puOv6ZB7Ly9xt0Q8uGyxgf0VO5VWB5QvusrywSTEfX+PPjr2ht49n
         Oh9JFwl/40bIqmxcMb1ED9foru+79NXj7dkaoPJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/639] mdio_bus: Fix PTR_ERR() usage after initialization to constant
Date:   Fri, 24 Jan 2020 10:26:17 +0100
Message-Id: <20200124093112.954681712@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 780feae7eb69388c8d8b661cda6706b0dc0f642b ]

Fix coccinelle warning:

./drivers/net/phy/mdio_bus.c:51:5-12: ERROR: PTR_ERR applied after initialization to constant on line 44
./drivers/net/phy/mdio_bus.c:52:5-12: ERROR: PTR_ERR applied after initialization to constant on line 44

fix this by using IS_ERR before PTR_ERR

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c5588d4508f97..5c89a310359de 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -56,11 +56,12 @@ static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 		gpiod = fwnode_get_named_gpiod(&mdiodev->dev.of_node->fwnode,
 					       "reset-gpios", 0, GPIOD_OUT_LOW,
 					       "PHY reset");
-	if (PTR_ERR(gpiod) == -ENOENT ||
-	    PTR_ERR(gpiod) == -ENOSYS)
-		gpiod = NULL;
-	else if (IS_ERR(gpiod))
-		return PTR_ERR(gpiod);
+	if (IS_ERR(gpiod)) {
+		if (PTR_ERR(gpiod) == -ENOENT || PTR_ERR(gpiod) == -ENOSYS)
+			gpiod = NULL;
+		else
+			return PTR_ERR(gpiod);
+	}
 
 	mdiodev->reset = gpiod;
 
-- 
2.20.1



