Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06658593B81
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbiHOTyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344856AbiHOTxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093D343E62;
        Mon, 15 Aug 2022 11:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA86FB81057;
        Mon, 15 Aug 2022 18:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25AFC433C1;
        Mon, 15 Aug 2022 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589470;
        bh=xwqlsyLT4+wEgeoymS/IaazHbOUWacD/OGFbiM81irw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtUARHuty1oB7hPZSiN7qfBGf+OZdSySdMlOMpRKNV1znHxRlpi/uaAf9NGE/zEyD
         o/Cfz15SoPJ4hFI9nTQKnv1Dyiq4TupiELO9Yv071O66riaxuKqjPw8ez4ZOp4j23b
         pYd0edt6oi575nyUKZSX8bJKr7X0LmBvQgkjN34A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andre Edich <andre.edich@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 698/779] usbnet: smsc95xx: Fix deadlock on runtime resume
Date:   Mon, 15 Aug 2022 20:05:42 +0200
Message-Id: <20220815180407.188032005@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 7b960c967f2aa01ab8f45c5a0bd78e754cffdeee ]

Commit 05b35e7eb9a1 ("smsc95xx: add phylib support") amended
smsc95xx_resume() to call phy_init_hw().  That function waits for the
device to runtime resume even though it is placed in the runtime resume
path, causing a deadlock.

The problem is that phy_init_hw() calls down to smsc95xx_mdiobus_read(),
which never uses the _nopm variant of usbnet_read_cmd().

Commit b4df480f68ae ("usbnet: smsc95xx: add reset_resume function with
reset operation") causes a similar deadlock on resume if the device was
already runtime suspended when entering system sleep:

That's because the commit introduced smsc95xx_reset_resume(), which
calls down to smsc95xx_reset(), which neglects to use _nopm accessors.

Fix by auto-detecting whether a device access is performed by the
suspend/resume task_struct and use the _nopm variant if so.  This works
because the PM core guarantees that suspend/resume callbacks are run in
task context.

Stacktrace for posterity:

  INFO: task kworker/2:1:49 blocked for more than 122 seconds.
  Workqueue: usb_hub_wq hub_event
  schedule
  rpm_resume
  __pm_runtime_resume
  usb_autopm_get_interface
  usbnet_read_cmd
  __smsc95xx_read_reg
  __smsc95xx_phy_wait_not_busy
  __smsc95xx_mdio_read
  smsc95xx_mdiobus_read
  __mdiobus_read
  mdiobus_read
  smsc_phy_reset
  phy_init_hw
  smsc95xx_resume
  usb_resume_interface
  usb_resume_both
  usb_runtime_resume
  __rpm_callback
  rpm_callback
  rpm_resume
  __pm_runtime_resume
  usb_autoresume_device
  hub_event
  process_one_work

Fixes: b4df480f68ae ("usbnet: smsc95xx: add reset_resume function with reset operation")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.16+
Cc: Andre Edich <andre.edich@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 3eb62197c2f5..460e90eb528f 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -69,6 +69,7 @@ struct smsc95xx_priv {
 	struct fwnode_handle *irqfwnode;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
+	struct task_struct *pm_task;
 };
 
 static bool turbo_mode = true;
@@ -78,13 +79,14 @@ MODULE_PARM_DESC(turbo_mode, "Enable multiple frames per Rx transaction");
 static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 					    u32 *data, int in_pm)
 {
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (current != pdata->pm_task)
 		fn = usbnet_read_cmd;
 	else
 		fn = usbnet_read_cmd_nopm;
@@ -108,13 +110,14 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 					     u32 data, int in_pm)
 {
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, const void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (current != pdata->pm_task)
 		fn = usbnet_write_cmd;
 	else
 		fn = usbnet_write_cmd_nopm;
@@ -1482,9 +1485,12 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	u32 val, link_up;
 	int ret;
 
+	pdata->pm_task = current;
+
 	ret = usbnet_suspend(intf, message);
 	if (ret < 0) {
 		netdev_warn(dev->net, "usbnet_suspend error\n");
+		pdata->pm_task = NULL;
 		return ret;
 	}
 
@@ -1724,6 +1730,7 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	if (ret && PMSG_IS_AUTO(message))
 		usbnet_resume(intf);
 
+	pdata->pm_task = NULL;
 	return ret;
 }
 
@@ -1744,29 +1751,31 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	/* do this first to ensure it's cleared even in error case */
 	pdata->suspend_flags = 0;
 
+	pdata->pm_task = current;
+
 	if (suspend_flags & SUSPEND_ALLMODES) {
 		/* clear wake-up sources */
 		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
 		if (ret < 0)
-			return ret;
+			goto done;
 
 		val &= ~(WUCSR_WAKE_EN_ | WUCSR_MPEN_);
 
 		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
 		if (ret < 0)
-			return ret;
+			goto done;
 
 		/* clear wake-up status */
 		ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
 		if (ret < 0)
-			return ret;
+			goto done;
 
 		val &= ~PM_CTL_WOL_EN_;
 		val |= PM_CTL_WUPS_;
 
 		ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
 		if (ret < 0)
-			return ret;
+			goto done;
 	}
 
 	phy_init_hw(pdata->phydev);
@@ -1775,15 +1784,20 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	if (ret < 0)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
+done:
+	pdata->pm_task = NULL;
 	return ret;
 }
 
 static int smsc95xx_reset_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
+	pdata->pm_task = current;
 	ret = smsc95xx_reset(dev);
+	pdata->pm_task = NULL;
 	if (ret < 0)
 		return ret;
 
-- 
2.35.1



