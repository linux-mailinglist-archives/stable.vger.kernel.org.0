Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DBF79995
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfG2TZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfG2TZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:25:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2EE320C01;
        Mon, 29 Jul 2019 19:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428323;
        bh=OUn9xTpSoelEjjstaQwdtzxYPwUI7JFY53i+XxSV/4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUXa9r07/tixa8KhaRAQ9lpbESSFXDTiP6tC5/azjQXYVephFRemMSqvxFwnyqGmi
         UWmv0wz4fndQUB9Ze+aHM6Jcs//RaW/YHMXunvz92Wlprffxn7t8RZKY8ICYSav2vI
         xCsqInlDxYj2I8kFzSI0WdRaqQe8ZvrX07AFRhvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Robert Hancock <hancock@sedsystems.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 039/293] net: sfp: add mutex to prevent concurrent state checks
Date:   Mon, 29 Jul 2019 21:18:50 +0200
Message-Id: <20190729190825.439396977@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2158e856f56bb762ef90f3ec244d41a519826f75 ]

sfp_check_state can potentially be called by both a threaded IRQ handler
and delayed work. If it is concurrently called, it could result in
incorrect state management. Add a st_mutex to protect the state - this
lock gets taken outside of code that checks and handle state changes, and
the existing sm_mutex nests inside of it.

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 2dcb25aa0452..9cef89fe410d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -115,10 +115,11 @@ struct sfp {
 	struct gpio_desc *gpio[GPIO_MAX];
 
 	bool attached;
+	struct mutex st_mutex;			/* Protects state */
 	unsigned int state;
 	struct delayed_work poll;
 	struct delayed_work timeout;
-	struct mutex sm_mutex;
+	struct mutex sm_mutex;			/* Protects state machine */
 	unsigned char sm_mod_state;
 	unsigned char sm_dev_state;
 	unsigned short sm_state;
@@ -738,6 +739,7 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
+	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
@@ -763,6 +765,7 @@ static void sfp_check_state(struct sfp *sfp)
 		sfp_sm_event(sfp, state & SFP_F_LOS ?
 				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
 	rtnl_unlock();
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static irqreturn_t sfp_irq(int irq, void *data)
@@ -793,6 +796,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 	sfp->dev = dev;
 
 	mutex_init(&sfp->sm_mutex);
+	mutex_init(&sfp->st_mutex);
 	INIT_DELAYED_WORK(&sfp->poll, sfp_poll);
 	INIT_DELAYED_WORK(&sfp->timeout, sfp_timeout);
 
-- 
2.20.1



