Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71B31CAF62
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgEHMn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbgEHMn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 270A920731;
        Fri,  8 May 2020 12:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941837;
        bh=Eza8NhI9L9YI4bSOy94/iPb7+PZtQz1qpTvrev4zn34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ps7Lxn/8jmoGnp76C5lboaK38lDZY8u+772iRYBxQeLRG2aMa42fJlh1hlY2GAzu2
         ABcfCF16sjtn5LvJE7Pa6ojMHdGP7Ke61igt9ThIJvPx6ETF9PCFBAA0Etk951Pg9s
         KCUvrzT5YoFGMNAflLIkR2NIMUEM8MiMxfREAb6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 152/312] net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS
Date:   Fri,  8 May 2020 14:32:23 +0200
Message-Id: <20200508123135.152851246@linuxfoundation.org>
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

commit d5c3d84657db57bd23ecd58b97f1c99dd42a7b80 upstream.

Commit 2c7b49212a86 ("phy: fix the use of PHY_IGNORE_INTERRUPT") changed
a hunk in phy_state_machine() in the PHY_RUNNING case which was not
needed. The change essentially makes the PHY library treat PHY devices
with PHY_IGNORE_INTERRUPT to keep polling for the PHY device, even
though the intent is not to do it.

Fix this by reverting that specific hunk, which makes the PHY state
machine wait for state changes, and stay in the PHY_RUNNING state for as
long as needed.

Fixes: 2c7b49212a86 ("phy: fix the use of PHY_IGNORE_INTERRUPT")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/phy.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -912,10 +912,10 @@ void phy_state_machine(struct work_struc
 		phydev->adjust_link(phydev->attached_dev);
 		break;
 	case PHY_RUNNING:
-		/* Only register a CHANGE if we are polling or ignoring
-		 * interrupts and link changed since latest checking.
+		/* Only register a CHANGE if we are polling and link changed
+		 * since latest checking.
 		 */
-		if (!phy_interrupt_is_valid(phydev)) {
+		if (phydev->irq == PHY_POLL) {
 			old_link = phydev->link;
 			err = phy_read_status(phydev);
 			if (err)
@@ -1015,8 +1015,13 @@ void phy_state_machine(struct work_struc
 	dev_dbg(&phydev->dev, "PHY state change %s -> %s\n",
 		phy_state_to_str(old_state), phy_state_to_str(phydev->state));
 
-	queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
-			   PHY_STATE_TIME * HZ);
+	/* Only re-schedule a PHY state machine change if we are polling the
+	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
+	 * between states from phy_mac_interrupt()
+	 */
+	if (phydev->irq == PHY_POLL)
+		queue_delayed_work(system_power_efficient_wq, &phydev->state_queue,
+				   PHY_STATE_TIME * HZ);
 }
 
 void phy_mac_interrupt(struct phy_device *phydev, int new_link)


