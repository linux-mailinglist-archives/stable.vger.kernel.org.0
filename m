Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D693B461E87
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379774AbhK2ShC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:37:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52660 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378749AbhK2SfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:35:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60118CE13AA;
        Mon, 29 Nov 2021 18:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0EBC53FC7;
        Mon, 29 Nov 2021 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210700;
        bh=hJtRomHVfhrSx2NalxNrW4QcfScJCGqMg3uyVbIElrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBGKgFF1M5qisO/O7mS7Hk1QYZFgigr84LE9dfXvhmPNKsDzlWwrmnpe7h1Z1OOsk
         KslEBBllhGSARYwBkG99boV+PvCvZ3iaFi/3MpBEr0WWUrcHlL42+uWRdHv6aKxw3B
         KwHdP1+iKLphZNHKHR+2aWp+qb8vNgojGTcHcTww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/121] net: phylink: Force retrigger in case of latched link-fail indicator
Date:   Mon, 29 Nov 2021 19:18:37 +0100
Message-Id: <20211129181714.555135358@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 8279e08dad9db..57b1b138522e0 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -675,6 +675,19 @@ static void phylink_resolve(struct work_struct *w)
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
 			 * both the PHY and the MAC */
 			if (pl->phydev)
-- 
2.33.0



