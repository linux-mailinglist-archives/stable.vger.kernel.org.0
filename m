Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E59B4626AF
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhK2W4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbhK2WzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:55:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF25C1A3CB3;
        Mon, 29 Nov 2021 10:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3833AB8162E;
        Mon, 29 Nov 2021 18:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE0FC53FC7;
        Mon, 29 Nov 2021 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211190;
        bh=SGcqcQGiiRMcZM/0B434ZFQp9y9pUhCXAUHlUgSjj1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfvOpAKNj+pKPabXmxn9MEspEYBHr+GyyS0Wc2T/mujSh92RVa3qbVC+R7J2quzXw
         f7327qaCzWY1cS/2DsyFgiLgQLEs8fvBIJ1KPvThad/dqREDqnptpMr8AWv5kCULDt
         nZn2wl0At96I4mnuJNaDhQph7Qbu5CDueSXzeksU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/179] net: phylink: Force retrigger in case of latched link-fail indicator
Date:   Mon, 29 Nov 2021 19:18:50 +0100
Message-Id: <20211129181723.424457791@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit dbae3388ea9ca33bd1d5eabc3b0ef17e69c74677 ]

On mv88e6xxx 1G/2.5G PCS, the SerDes register 4.2001.2 has the following
description:
  This register bit indicates when link was lost since the last
  read. For the current link status, read this register
  back-to-back.

Thus to get current link state, we need to read the register twice.

But doing that in the link change interrupt handler would lead to
potentially ignoring link down events, which we really want to avoid.

Thus this needs to be solved in phylink's resolve, by retriggering
another resolve in the event when PCS reports link down and previous
link was up, and by re-reading PCS state if the previous link was down.

The wrong value is read when phylink requests change from sgmii to
2500base-x mode, and link won't come up. This fixes the bug.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 59ee87df5746e..fef1416dcee4c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -688,6 +688,19 @@ static void phylink_resolve(struct work_struct *w)
 		case MLO_AN_INBAND:
 			phylink_mac_pcs_get_state(pl, &link_state);
 
+			/* The PCS may have a latching link-fail indicator.
+			 * If the link was up, bring the link down and
+			 * re-trigger the resolve. Otherwise, re-read the
+			 * PCS state to get the current status of the link.
+			 */
+			if (!link_state.link) {
+				if (cur_link_state)
+					retrigger = true;
+				else
+					phylink_mac_pcs_get_state(pl,
+								  &link_state);
+			}
+
 			/* If we have a phy, the "up" state is the union of
 			 * both the PHY and the MAC
 			 */
-- 
2.33.0



