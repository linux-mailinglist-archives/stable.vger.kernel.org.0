Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC487140030
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390384AbgAPXT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbgAPXT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A16C20684;
        Thu, 16 Jan 2020 23:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216767;
        bh=RvhoIAxXqYDw5faNpUGywRjxgGEB37kkvbofp85v6co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPyKjcu1reryNXE2oymZW49RR3C6sgZY9Rxk8QNNJo4wBVK1VkKlcHE+QPF8tjpio
         g2+Eio3+hEgO2l9EHYrkuKmO4QJESjrF8ZPXteqek3aLf+yQ4mM6/7vafKGofYMnhS
         lcY8cS8V/1CAs2F3UdOr+XW4f3MzNbYuzWYyfK78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marcel Partap <mpartap@gmx.net>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Michael Scott <hashcode0f@gmail.com>,
        NeKit <nekit1000@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.4 003/203] phy: mapphone-mdm6600: Fix uninitialized status value regression
Date:   Fri, 17 Jan 2020 00:15:20 +0100
Message-Id: <20200116231745.430527440@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit af5d44de571811a151510bfd1236407b7f551cd9 upstream.

Only the used bits get cleared with bitmap_zero() when we call
gpiod_get_array_value_cansleep(). We must mask only the bits we're
using for ddata->status as the other bits in the bitmap may not be
initialized.

And let's also drop useless debug code accidentally left over while
at it.

Fixes: b9762bebc633 ("gpiolib: Pass bitmaps, not integer arrays, to get/set array")
Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marcel Partap <mpartap@gmx.net>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Michael Scott <hashcode0f@gmail.com>
Cc: NeKit <nekit1000@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/motorola/phy-mapphone-mdm6600.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -200,7 +200,7 @@ static void phy_mdm6600_status(struct wo
 	struct phy_mdm6600 *ddata;
 	struct device *dev;
 	DECLARE_BITMAP(values, PHY_MDM6600_NR_STATUS_LINES);
-	int error, i, val = 0;
+	int error;
 
 	ddata = container_of(work, struct phy_mdm6600, status_work.work);
 	dev = ddata->dev;
@@ -212,16 +212,11 @@ static void phy_mdm6600_status(struct wo
 	if (error)
 		return;
 
-	for (i = 0; i < PHY_MDM6600_NR_STATUS_LINES; i++) {
-		val |= test_bit(i, values) << i;
-		dev_dbg(ddata->dev, "XXX %s: i: %i values[i]: %i val: %i\n",
-			__func__, i, test_bit(i, values), val);
-	}
-	ddata->status = values[0];
+	ddata->status = values[0] & ((1 << PHY_MDM6600_NR_STATUS_LINES) - 1);
 
 	dev_info(dev, "modem status: %i %s\n",
 		 ddata->status,
-		 phy_mdm6600_status_name[ddata->status & 7]);
+		 phy_mdm6600_status_name[ddata->status]);
 	complete(&ddata->ack);
 }
 


