Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A155A49C9
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiH2LaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiH2L3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171167168;
        Mon, 29 Aug 2022 04:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C6776122B;
        Mon, 29 Aug 2022 11:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67351C433C1;
        Mon, 29 Aug 2022 11:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771746;
        bh=Zbkptztkx3K6TXVOoXnL5C+7twSLxobqsqQ1ns/lazA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDXCFExXAiNYXpfr1O5wEushVfArj81CNUUIYJi5qONQ7Qz1bGdsiXNILar+A+w3D
         C/fwdLvVR/kyuD5IT504afDyrxRl1mNlqCHv6I6VrrANt92GU1HcqxKQ8d8UxGkULQ
         RxzueKfnEHLqRVSMRA/+HLTKMVm/cuONmbyN7ANM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Andre Edich <andre.edich@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/136] Revert "usbnet: smsc95xx: Fix deadlock on runtime resume"
Date:   Mon, 29 Aug 2022 12:59:46 +0200
Message-Id: <20220829105809.573320725@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b574d1e3e9a2432b5acd9c4a9dc8d70b6a37aaf1 which is
commit 7b960c967f2aa01ab8f45c5a0bd78e754cffdeee upstream.

It is reported to cause problems, so drop it from the 5.15.y tree until
the root cause can be determined.

Reported-by: Lukas Wunner <lukas@wunner.de>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Ferry Toth <fntoth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Andre Edich <andre.edich@microchip.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/20220826132137.GA24932@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc95xx.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -69,7 +69,6 @@ struct smsc95xx_priv {
 	struct fwnode_handle *irqfwnode;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
-	struct task_struct *pm_task;
 };
 
 static bool turbo_mode = true;
@@ -79,14 +78,13 @@ MODULE_PARM_DESC(turbo_mode, "Enable mul
 static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 					    u32 *data, int in_pm)
 {
-	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
 
 	BUG_ON(!dev);
 
-	if (current != pdata->pm_task)
+	if (!in_pm)
 		fn = usbnet_read_cmd;
 	else
 		fn = usbnet_read_cmd_nopm;
@@ -110,14 +108,13 @@ static int __must_check __smsc95xx_read_
 static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 					     u32 data, int in_pm)
 {
-	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, const void *, u16);
 
 	BUG_ON(!dev);
 
-	if (current != pdata->pm_task)
+	if (!in_pm)
 		fn = usbnet_write_cmd;
 	else
 		fn = usbnet_write_cmd_nopm;
@@ -1485,12 +1482,9 @@ static int smsc95xx_suspend(struct usb_i
 	u32 val, link_up;
 	int ret;
 
-	pdata->pm_task = current;
-
 	ret = usbnet_suspend(intf, message);
 	if (ret < 0) {
 		netdev_warn(dev->net, "usbnet_suspend error\n");
-		pdata->pm_task = NULL;
 		return ret;
 	}
 
@@ -1730,7 +1724,6 @@ done:
 	if (ret && PMSG_IS_AUTO(message))
 		usbnet_resume(intf);
 
-	pdata->pm_task = NULL;
 	return ret;
 }
 
@@ -1751,31 +1744,29 @@ static int smsc95xx_resume(struct usb_in
 	/* do this first to ensure it's cleared even in error case */
 	pdata->suspend_flags = 0;
 
-	pdata->pm_task = current;
-
 	if (suspend_flags & SUSPEND_ALLMODES) {
 		/* clear wake-up sources */
 		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		val &= ~(WUCSR_WAKE_EN_ | WUCSR_MPEN_);
 
 		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		/* clear wake-up status */
 		ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
 		if (ret < 0)
-			goto done;
+			return ret;
 
 		val &= ~PM_CTL_WOL_EN_;
 		val |= PM_CTL_WUPS_;
 
 		ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
 		if (ret < 0)
-			goto done;
+			return ret;
 	}
 
 	phy_init_hw(pdata->phydev);
@@ -1784,20 +1775,15 @@ static int smsc95xx_resume(struct usb_in
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
-done:
-	pdata->pm_task = NULL;
 	return ret;
 }
 
 static int smsc95xx_reset_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
-	pdata->pm_task = current;
 	ret = smsc95xx_reset(dev);
-	pdata->pm_task = NULL;
 	if (ret < 0)
 		return ret;
 


