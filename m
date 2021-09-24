Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF04417368
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344334AbhIXMzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344572AbhIXMxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D026561352;
        Fri, 24 Sep 2021 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487828;
        bh=eJAqY7s9rP5B7G3YsawqxVBMz9xKcqEeZjsYhHiO0xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG6wHJU8v2aCtN1XegSgsFTGXZ9fO0686o169u6Rx7qx5WbMFn2YIUxhoEp3oryR4
         TCdmgPhbk+yU//diG6DmzODMrnhBlCb0f3ttcLTs7yetMD1CAjxWbbofHF/EWSbp2P
         qDJj+Z/IOoWrveYDK5JCzhACDAsBGrWDl82TP0I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Oros <poros@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH 5.4 27/50] phy: avoid unnecessary link-up delay in polling mode
Date:   Fri, 24 Sep 2021 14:44:16 +0200
Message-Id: <20210924124333.159067703@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Oros <poros@redhat.com>

commit e96bd2d3b1f83170d1d5c1a99e439b39a22a5b58 upstream.

commit 93c0970493c71f ("net: phy: consider latched link-down status in
polling mode") removed double-read of latched link-state register for
polling mode from genphy_update_link(). This added extra ~1s delay into
sequence link down->up.
Following scenario:
 - After boot link goes up
 - phy_start() is called triggering an aneg restart, hence link goes
   down and link-down info is latched.
 - After aneg has finished link goes up. In phy_state_machine is checked
   link state but it is latched "link is down". The state machine is
   scheduled after one second and there is detected "link is up". This
   extra delay can be avoided when we keep link-state register double read
   in case when link was down previously.

With this solution we don't miss a link-down event in polling mode and
link-up is faster.

Details about this quirky behavior on Realtek phy:
Without patch:
T0:    aneg is started, link goes down, link-down status is latched
T0+3s: state machine runs, up-to-date link-down is read
T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
       here i read link-down (BMSR_LSTATUS==0),
T0+5s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
       up-to-date link-up is read (BMSR_LSTATUS==1),
       phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING

With patch:
T0:    aneg is started, link goes down, link-down status is latched
T0+3s: state machine runs, up-to-date link-down is read
T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
       first BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==0,
       second BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==1,
       phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING

Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy-c45.c    |    5 +++--
 drivers/net/phy/phy_device.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -239,9 +239,10 @@ int genphy_c45_read_link(struct phy_devi
 
 		/* The link state is latched low so that momentary link
 		 * drops can be detected. Do not double-read the status
-		 * in polling mode to detect such short link drops.
+		 * in polling mode to detect such short link drops except
+		 * the link was already down.
 		 */
-		if (!phy_polling_mode(phydev)) {
+		if (!phy_polling_mode(phydev) || !phydev->link) {
 			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
 			if (val < 0)
 				return val;
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1766,9 +1766,10 @@ int genphy_update_link(struct phy_device
 
 	/* The link state is latched low so that momentary link
 	 * drops can be detected. Do not double-read the status
-	 * in polling mode to detect such short link drops.
+	 * in polling mode to detect such short link drops except
+	 * the link was already down.
 	 */
-	if (!phy_polling_mode(phydev)) {
+	if (!phy_polling_mode(phydev) || !phydev->link) {
 		status = phy_read(phydev, MII_BMSR);
 		if (status < 0)
 			return status;


