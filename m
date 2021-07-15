Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE353CA860
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbhGOTAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242507AbhGOS7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3BFE60D07;
        Thu, 15 Jul 2021 18:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375410;
        bh=NK1C+OqojIwMpGe7AJKnUxjuIRKG0Oa2NtHXQG3auq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWtbvxqHow+S7E1LCjIyFyCGOlJGd/Lrtat8VwvdJ1VfwKlDviYLDNsOo/hxGYkE8
         CU8qNaAKx6yJLL4g2xXyJ/lioblC+iZfmo29JnyWEdLVlZnlLAa/FPvOVqHZx/qgED
         jOLSnDNxWl2aobEwTgtreYYcQhVSYofJeDNPC/y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 076/242] net: phy: realtek: add delay to fix RXC generation issue
Date:   Thu, 15 Jul 2021 20:37:18 +0200
Message-Id: <20210715182606.321944992@linuxfoundation.org>
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

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 6813cc8cfdaf401476e1a007cec8ae338cefa573 ]

PHY will delay about 11.5ms to generate RXC clock when switching from
power down to normal operation. Read/write registers would also cause RXC
become unstable and stop for a while during this process. Realtek engineer
suggests 15ms or more delay can workaround this issue.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 821e85a97367..7b99a3234c65 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -357,6 +357,19 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int rtl821x_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_resume(phydev);
+	if (ret < 0)
+		return ret;
+
+	msleep(20);
+
+	return 0;
+}
+
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	int ret = 0, oldpage;
@@ -852,7 +865,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-- 
2.30.2



