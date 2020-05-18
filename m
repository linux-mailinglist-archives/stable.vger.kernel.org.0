Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8411D8041
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgERRi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbgERRi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:38:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4DDF207C4;
        Mon, 18 May 2020 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823506;
        bh=swodPM4ofA4LWEg+ihmFAkOFJBSXFCaaWYhER0DkMDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On7XOPUDoBNiIHkbYQML1bIjiRTj1kyH6w82y8WLEd20RximjRz6enqIf2i0lfBeA
         dmmrXjcNRVl33gO0rix/qr3rwyRP488G9Ge+jG94YkJYPL1hCVxr8fvmPgc8EcxtBy
         bBY20sB9kdjDxRNY7BAwRNHI0UWIGc9a885lCfmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 02/86] Revert "net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS"
Date:   Mon, 18 May 2020 19:35:33 +0200
Message-Id: <20200518173450.765036296@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 0d1951fa23ba0d35a4c5498ff28d1c5206d6fcdd which was
commit d5c3d84657db57bd23ecd58b97f1c99dd42a7b80 upstream.

Guillaume reports that this patch breaks booting on
at91-sama5d4_xplained, so revert it for now.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Reported-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -916,10 +916,10 @@ void phy_state_machine(struct work_struc
 		phydev->adjust_link(phydev->attached_dev);
 		break;
 	case PHY_RUNNING:
-		/* Only register a CHANGE if we are polling and link changed
-		 * since latest checking.
+		/* Only register a CHANGE if we are polling or ignoring
+		 * interrupts and link changed since latest checking.
 		 */
-		if (phydev->irq == PHY_POLL) {
+		if (!phy_interrupt_is_valid(phydev)) {
 			old_link = phydev->link;
 			err = phy_read_status(phydev);
 			if (err)
@@ -1019,13 +1019,8 @@ void phy_state_machine(struct work_struc
 	dev_dbg(&phydev->dev, "PHY state change %s -> %s\n",
 		phy_state_to_str(old_state), phy_state_to_str(phydev->state));
 
-	/* Only re-schedule a PHY state machine change if we are polling the
-	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
-	 * between states from phy_mac_interrupt()
-	 */
-	if (phydev->irq == PHY_POLL)
-		queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
-				   PHY_STATE_TIME * HZ);
+	queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
+			   PHY_STATE_TIME * HZ);
 }
 
 void phy_mac_interrupt(struct phy_device *phydev, int new_link)


