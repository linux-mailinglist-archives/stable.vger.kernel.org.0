Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3EA2E3CEE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438747AbgL1OI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438717AbgL1OI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D9D2205CB;
        Mon, 28 Dec 2020 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164522;
        bh=IWlUGcXcpSqxeRF9LeGhQQP2euCF37w8cNULYYO1ozA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l31Z/3IbJ7sONsrc/9lH0Uh1ZIfamUXW9cc6cf/tN77DEmDwcqnx0akc6kpkdll6J
         Iyl3osUMmpJ4/hEkCW92KNuN5tS+mSnidEes3hMsP0NGcywMQafP7AgrFIRDlA3aCM
         g5YxLtpj2hdH9RWErW917qm9YPdtx6WYs1xCLtMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Murphy <dmurphy@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/717] leds: lp50xx: Fix an error handling path in lp50xx_probe_dt()
Date:   Mon, 28 Dec 2020 13:43:22 +0100
Message-Id: <20201228125030.755655060@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6d8d014c7dcf85a79da71ef586d06d03d2cae558 ]

In case of memory allocation failure, we must release some resources as
done in all other error handling paths of the function.

'goto child_out' instead of a direct return so that 'fwnode_handle_put()'
is called when we break out of a 'device_for_each_child_node' loop.

Fixes: 242b81170fb8 ("leds: lp50xx: Add the LP50XX family of the RGB LED driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp50xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp50xx.c b/drivers/leds/leds-lp50xx.c
index 5fb4f24aeb2e8..f13117eed976d 100644
--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -487,8 +487,10 @@ static int lp50xx_probe_dt(struct lp50xx *priv)
 		 */
 		mc_led_info = devm_kcalloc(priv->dev, LP50XX_LEDS_PER_MODULE,
 					   sizeof(*mc_led_info), GFP_KERNEL);
-		if (!mc_led_info)
-			return -ENOMEM;
+		if (!mc_led_info) {
+			ret = -ENOMEM;
+			goto child_out;
+		}
 
 		fwnode_for_each_child_node(child, led_node) {
 			ret = fwnode_property_read_u32(led_node, "color",
-- 
2.27.0



