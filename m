Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A6213A610
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgANKIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731005AbgANKIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:08:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1BE020678;
        Tue, 14 Jan 2020 10:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996511;
        bh=D3VkGmMM0F+62RmYOJvCGnU+mkcmb+KmFgNnf0ojJhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfl2ikiQo8SCt+QbpboaqzO8fTK2hAS1HJYrT8z6Iiy1gtwYRO2AUYewcvhT2n42E
         0lvAteHBAO2pt3GqQyUKicNrczAauyF0i9LQ4C+sqiCFH6QClwZjdIcbNIeh4EfX+j
         Oqp5pJlgL2lGq60PCQl3oHVrWt0FXprBSndY4cXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 4.19 42/46] phy: cpcap-usb: Fix error path when no host driver is loaded
Date:   Tue, 14 Jan 2020 11:01:59 +0100
Message-Id: <20200114094348.395107803@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094339.608068818@linuxfoundation.org>
References: <20200114094339.608068818@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 4acb0200ab2b07843e3ef5599add3454c7440f03 upstream.

If musb_mailbox() returns an error, we must still continue to finish
configuring the phy.

Otherwise the phy state may end up only half initialized, and this can
cause the debug serial console to stop working. And this will happen if the
usb driver musb controller is not loaded.

Let's fix the issue by adding helper for cpcap_usb_try_musb_mailbox().

Fixes: 6d6ce40f63af ("phy: cpcap-usb: Add CPCAP PMIC USB support")
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/motorola/phy-cpcap-usb.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/phy/motorola/phy-cpcap-usb.c
+++ b/drivers/phy/motorola/phy-cpcap-usb.c
@@ -207,6 +207,19 @@ static int cpcap_phy_get_ints_state(stru
 static int cpcap_usb_set_uart_mode(struct cpcap_phy_ddata *ddata);
 static int cpcap_usb_set_usb_mode(struct cpcap_phy_ddata *ddata);
 
+static void cpcap_usb_try_musb_mailbox(struct cpcap_phy_ddata *ddata,
+				       enum musb_vbus_id_status status)
+{
+	int error;
+
+	error = musb_mailbox(status);
+	if (!error)
+		return;
+
+	dev_dbg(ddata->dev, "%s: musb_mailbox failed: %i\n",
+		__func__, error);
+}
+
 static void cpcap_usb_detect(struct work_struct *work)
 {
 	struct cpcap_phy_ddata *ddata;
@@ -226,9 +239,7 @@ static void cpcap_usb_detect(struct work
 		if (error)
 			goto out_err;
 
-		error = musb_mailbox(MUSB_ID_GROUND);
-		if (error)
-			goto out_err;
+		cpcap_usb_try_musb_mailbox(ddata, MUSB_ID_GROUND);
 
 		error = regmap_update_bits(ddata->reg, CPCAP_REG_USBC3,
 					   CPCAP_BIT_VBUSSTBY_EN,
@@ -255,9 +266,7 @@ static void cpcap_usb_detect(struct work
 			error = cpcap_usb_set_usb_mode(ddata);
 			if (error)
 				goto out_err;
-			error = musb_mailbox(MUSB_ID_GROUND);
-			if (error)
-				goto out_err;
+			cpcap_usb_try_musb_mailbox(ddata, MUSB_ID_GROUND);
 
 			return;
 		}
@@ -267,9 +276,7 @@ static void cpcap_usb_detect(struct work
 		error = cpcap_usb_set_usb_mode(ddata);
 		if (error)
 			goto out_err;
-		error = musb_mailbox(MUSB_VBUS_VALID);
-		if (error)
-			goto out_err;
+		cpcap_usb_try_musb_mailbox(ddata, MUSB_VBUS_VALID);
 
 		return;
 	}
@@ -279,9 +286,7 @@ static void cpcap_usb_detect(struct work
 	if (error)
 		goto out_err;
 
-	error = musb_mailbox(MUSB_VBUS_OFF);
-	if (error)
-		goto out_err;
+	cpcap_usb_try_musb_mailbox(ddata, MUSB_VBUS_OFF);
 
 	dev_dbg(ddata->dev, "set UART mode\n");
 
@@ -647,9 +652,7 @@ static int cpcap_usb_phy_remove(struct p
 	if (error)
 		dev_err(ddata->dev, "could not set UART mode\n");
 
-	error = musb_mailbox(MUSB_VBUS_OFF);
-	if (error)
-		dev_err(ddata->dev, "could not set mailbox\n");
+	cpcap_usb_try_musb_mailbox(ddata, MUSB_VBUS_OFF);
 
 	usb_remove_phy(&ddata->phy);
 	cancel_delayed_work_sync(&ddata->detect_work);


