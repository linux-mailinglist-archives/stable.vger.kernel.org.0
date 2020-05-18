Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB261D808D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgERRkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729046AbgERRkX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B94DF207FB;
        Mon, 18 May 2020 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823623;
        bh=MnXWXZU26+4+NeIY9AqrocqOaxDKw36ByaZ0bariZvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipGjf7I9W/5RqvfT6YJtTh0TVnXQCKWu/jF0CAeIrj+OZQ+gdOwyZdJG/+Mq4v6OX
         n8CSBglQ8d4FGdNs6K3tcjXspRN9tXYXDHSTA8sT/7sr0djpwCPxMrbysClADByD9C
         uVmMml4ZYkK0JEURuZcqgYYg6LEr0bEtl/Nk+Eo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/86] phy: micrel: Ensure interrupts are reenabled on resume
Date:   Mon, 18 May 2020 19:35:49 +0200
Message-Id: <20200518173454.160717267@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

[ Upstream commit f5aba91d7f186cba84af966a741a0346de603cd4 ]

At least on ksz8081, when getting back from power down, interrupts are
disabled. ensure they are reenabled if they were previously enabled.

This fixes resuming which is failing on the xplained boards from atmel
since 321beec5047a (net: phy: Use interrupts when available in NOLINK
state)

Fixes: 321beec5047a (net: phy: Use interrupts when available in NOLINK state)
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 98166e144f2dd..48788ef0ac639 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -603,6 +603,21 @@ ksz9021_wr_mmd_phyreg(struct phy_device *phydev, int ptrad, int devnum,
 {
 }
 
+static int kszphy_resume(struct phy_device *phydev)
+{
+	int value;
+
+	mutex_lock(&phydev->lock);
+
+	value = phy_read(phydev, MII_BMCR);
+	phy_write(phydev, MII_BMCR, value & ~BMCR_PDOWN);
+
+	kszphy_config_intr(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return 0;
+}
+
 static int kszphy_probe(struct phy_device *phydev)
 {
 	const struct kszphy_type *type = phydev->drv->driver_data;
@@ -794,7 +809,7 @@ static struct phy_driver ksphy_driver[] = {
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.resume		= kszphy_resume,
 	.driver		= { .owner = THIS_MODULE,},
 }, {
 	.phy_id		= PHY_ID_KSZ8061,
-- 
2.20.1



