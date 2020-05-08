Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487FB1CAF92
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgEHMmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbgEHMmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B26A2495F;
        Fri,  8 May 2020 12:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941739;
        bh=sZtbQdeqjZqRdpdr9Qm6Xl/Fs+kYYY2c4mklpf8+o+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Io3tI86p8l2TTR/ZW/SSIARbJfEYK7n9QUymKIFSaO0Ro53izrSwNxnNLRj8A3bBg
         8ksXBCa3SoFSW2c6JTCw9p9eBzBcIWHmmYf8GDMF5eg/BXL8dJVqX3tVc9qDkcAMwD
         OiLRuSMz9I8SCD+ytd7WEr2WsDmeiv25u9wlA8WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 153/312] net: phy: Fix phy_mac_interrupt()
Date:   Fri,  8 May 2020 14:32:24 +0200
Message-Id: <20200508123135.224336711@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit deccd16f91f930af8e91ffbbfc839d0ad8da999d upstream.

Commit 5ea94e7686a3 ("phy: add phy_mac_interrupt()") to use with
PHY_IGNORE_INTERRUPT added a cancel_work_sync() into phy_mac_interrupt()
which is allowed to sleep, whereas phy_mac_interrupt() is expected to be
callable from interrupt context.

Now that we have fixed how the PHY state machine treats
PHY_IGNORE_INTERRUPT with respect to state changes, we can just set the
new link state, and queue the PHY state machine for execution so it is
going to read the new link state.

For that to work properly, we need to update phy_change() not to try to
invoke any interrupt callbacks if we have configured the PHY device for
PHY_IGNORE_INTERRUPT, because that PHY device and its driver are not
required to implement those.

Fixes: 5ea94e7686a3 ("phy: add phy_mac_interrupt() to use with PHY_IGNORE_INTERRUPT")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/phy.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -699,25 +699,29 @@ void phy_change(struct work_struct *work
 	struct phy_device *phydev =
 		container_of(work, struct phy_device, phy_queue);
 
-	if (phydev->drv->did_interrupt &&
-	    !phydev->drv->did_interrupt(phydev))
-		goto ignore;
+	if (phy_interrupt_is_valid(phydev)) {
+		if (phydev->drv->did_interrupt &&
+		    !phydev->drv->did_interrupt(phydev))
+			goto ignore;
 
-	if (phy_disable_interrupts(phydev))
-		goto phy_err;
+		if (phy_disable_interrupts(phydev))
+			goto phy_err;
+	}
 
 	mutex_lock(&phydev->lock);
 	if ((PHY_RUNNING == phydev->state) || (PHY_NOLINK == phydev->state))
 		phydev->state = PHY_CHANGELINK;
 	mutex_unlock(&phydev->lock);
 
-	atomic_dec(&phydev->irq_disable);
-	enable_irq(phydev->irq);
+	if (phy_interrupt_is_valid(phydev)) {
+		atomic_dec(&phydev->irq_disable);
+		enable_irq(phydev->irq);
 
-	/* Reenable interrupts */
-	if (PHY_HALTED != phydev->state &&
-	    phy_config_interrupt(phydev, PHY_INTERRUPT_ENABLED))
-		goto irq_enable_err;
+		/* Reenable interrupts */
+		if (PHY_HALTED != phydev->state &&
+		    phy_config_interrupt(phydev, PHY_INTERRUPT_ENABLED))
+			goto irq_enable_err;
+	}
 
 	/* reschedule state queue work to run as soon as possible */
 	cancel_delayed_work_sync(&phydev->state_queue);
@@ -1026,9 +1030,10 @@ void phy_state_machine(struct work_struc
 
 void phy_mac_interrupt(struct phy_device *phydev, int new_link)
 {
-	cancel_work_sync(&phydev->phy_queue);
 	phydev->link = new_link;
-	schedule_work(&phydev->phy_queue);
+
+	/* Trigger a state machine change */
+	queue_work(system_power_efficient_wq, &phydev->phy_queue);
 }
 EXPORT_SYMBOL(phy_mac_interrupt);
 


