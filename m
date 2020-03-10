Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779D717FD69
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgCJMyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728894AbgCJMyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:54:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F4C24693;
        Tue, 10 Mar 2020 12:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844843;
        bh=y6L1TFpF49ohcvee/WA6df90OUQDbBJtxI7H5ea/5QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TE5E72gRStIZnpb5WskUJWJSVZEfztI/x0Em3gQDKKK7X/MpCa6PuYBeB1cDDQe02
         5MOEzwqRyewpCWyAsCfDYpPa3Es7O0V7Hg9DHhb3sxKlDjXcBHPksqYfdReh/dqx1c
         5cBHjdAGRubB0As/Mp8tScJ70Y7ZqbyKeQ/iWdNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Partap <mpartap@gmx.net>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Michael Scott <hashcode0f@gmail.com>,
        NeKit <nekit1000@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.4 138/168] phy: mapphone-mdm6600: Fix write timeouts with shorter GPIO toggle interval
Date:   Tue, 10 Mar 2020 13:39:44 +0100
Message-Id: <20200310123649.468849087@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 46b7edf1c7b7c91004c4db2c355cbd033f2385f9 upstream.

I've noticed that when writing data to the modem the writes can time out
at some point eventually. Looks like kicking the modem idle GPIO every
600 ms instead of once a second fixes the issue. Note that this rate is
different from our runtime PM autosuspend rate MDM6600_MODEM_IDLE_DELAY_MS
that we still want to keep at 1 second, so let's add a separate define for
PHY_MDM6600_IDLE_KICK_MS.

Fixes: f7f50b2a7b05 ("phy: mapphone-mdm6600: Add runtime PM support for n_gsm on USB suspend")
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
 drivers/phy/motorola/phy-mapphone-mdm6600.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -20,6 +20,7 @@
 
 #define PHY_MDM6600_PHY_DELAY_MS	4000	/* PHY enable 2.2s to 3.5s */
 #define PHY_MDM6600_ENABLED_DELAY_MS	8000	/* 8s more total for MDM6600 */
+#define PHY_MDM6600_WAKE_KICK_MS	600	/* time on after GPIO toggle */
 #define MDM6600_MODEM_IDLE_DELAY_MS	1000	/* modem after USB suspend */
 #define MDM6600_MODEM_WAKE_DELAY_MS	200	/* modem response after idle */
 
@@ -510,8 +511,14 @@ static void phy_mdm6600_modem_wake(struc
 
 	ddata = container_of(work, struct phy_mdm6600, modem_wake_work.work);
 	phy_mdm6600_wake_modem(ddata);
+
+	/*
+	 * The modem does not always stay awake 1.2 seconds after toggling
+	 * the wake GPIO, and sometimes it idles after about some 600 ms
+	 * making writes time out.
+	 */
 	schedule_delayed_work(&ddata->modem_wake_work,
-			      msecs_to_jiffies(MDM6600_MODEM_IDLE_DELAY_MS));
+			      msecs_to_jiffies(PHY_MDM6600_WAKE_KICK_MS));
 }
 
 static int __maybe_unused phy_mdm6600_runtime_suspend(struct device *dev)


