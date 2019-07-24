Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1E73A0B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403747AbfGXTqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391063AbfGXTqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:46:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D235C205C9;
        Wed, 24 Jul 2019 19:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997583;
        bh=kRG4d6d5TG/mBD8Z0zXw5vqsmv4xOfEV6e8qfpaQqGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bH2wWPsbuJNPSQ1GUnmHhBv+qrOBKcCpWBnKj10fNw2KJIcntL8iX2LrfCBAaDluu
         y3zw/L5NzoSJ+cRmlBrhW7rtkRo23KINDk1aYCf1vypAGXfNRAqPCcE67LhDl07lWa
         MPq40iWOUAe71mw4nho+7NuwQGAPoNARQW73kniE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Robert Hancock <hancock@sedsystems.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 071/371] net: sfp: add mutex to prevent concurrent state checks
Date:   Wed, 24 Jul 2019 21:17:03 +0200
Message-Id: <20190724191730.234005812@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
index 71812be0ac64..b6efd2d41dce 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -186,10 +186,11 @@ struct sfp {
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
@@ -1719,6 +1720,7 @@ static void sfp_check_state(struct sfp *sfp)
 {
 	unsigned int state, i, changed;
 
+	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
 	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
@@ -1744,6 +1746,7 @@ static void sfp_check_state(struct sfp *sfp)
 		sfp_sm_event(sfp, state & SFP_F_LOS ?
 				SFP_E_LOS_HIGH : SFP_E_LOS_LOW);
 	rtnl_unlock();
+	mutex_unlock(&sfp->st_mutex);
 }
 
 static irqreturn_t sfp_irq(int irq, void *data)
@@ -1774,6 +1777,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 	sfp->dev = dev;
 
 	mutex_init(&sfp->sm_mutex);
+	mutex_init(&sfp->st_mutex);
 	INIT_DELAYED_WORK(&sfp->poll, sfp_poll);
 	INIT_DELAYED_WORK(&sfp->timeout, sfp_timeout);
 
-- 
2.20.1



