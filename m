Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2F679728
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390912AbfG2Txs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390821AbfG2Txp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:53:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CB6F2171F;
        Mon, 29 Jul 2019 19:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430024;
        bh=TkFUy521NuzO1b0exrOSpw/zPM68krysMkymAJtGe00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymJbWoYYJouTm81MUXgD488eLrnBOA6QczfMP6CsbsteNQ1J7WS+Q76C1P+V2XElV
         wq9jVna5AlRvBw9+dthHrrxKtslhF26zSRx/7Jv1vsBkyM6oZCi2kq+obxKzZpjou+
         SN6ML49yJYxxG/piN9bSjHkEhKN1LfXNyoKJUeBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 5.2 173/215] usb: usb251xb: Reallow swap-dx-lanes to apply to the upstream port
Date:   Mon, 29 Jul 2019 21:22:49 +0200
Message-Id: <20190729190809.936125511@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 4849ee6129702dcb05d36f9c7c61b4661fcd751f upstream.

This is a partial revert of 73d31def1aab "usb: usb251xb: Create a ports
field collector method", which broke a existing devicetree
(arch/arm64/boot/dts/freescale/imx8mq.dtsi).

There is no reason why the swap-dx-lanes property should not apply to
the upstream port. The reason given in the breaking commit was that it's
inconsitent with respect to other port properties, but in fact it is not.
All other properties which only apply to the downstream ports explicitly
reject port 0, so there is pretty strong precedence that the driver
referred to the upstream port as port 0. So there is no inconsistency in
this property at all, other than the swapping being also applicable to
the upstream port.

CC: stable@vger.kernel.org #5.2
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20190719084407.28041-3-l.stach@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/usb251xb.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/usb251xb.c
+++ b/drivers/usb/misc/usb251xb.c
@@ -375,7 +375,8 @@ out_err:
 
 #ifdef CONFIG_OF
 static void usb251xb_get_ports_field(struct usb251xb *hub,
-				    const char *prop_name, u8 port_cnt, u8 *fld)
+				    const char *prop_name, u8 port_cnt,
+				    bool ds_only, u8 *fld)
 {
 	struct device *dev = hub->dev;
 	struct property *prop;
@@ -383,7 +384,7 @@ static void usb251xb_get_ports_field(str
 	u32 port;
 
 	of_property_for_each_u32(dev->of_node, prop_name, prop, p, port) {
-		if ((port >= 1) && (port <= port_cnt))
+		if ((port >= ds_only ? 1 : 0) && (port <= port_cnt))
 			*fld |= BIT(port);
 		else
 			dev_warn(dev, "port %u doesn't exist\n", port);
@@ -501,15 +502,15 @@ static int usb251xb_get_ofdata(struct us
 
 	hub->non_rem_dev = USB251XB_DEF_NON_REMOVABLE_DEVICES;
 	usb251xb_get_ports_field(hub, "non-removable-ports", data->port_cnt,
-				 &hub->non_rem_dev);
+				 true, &hub->non_rem_dev);
 
 	hub->port_disable_sp = USB251XB_DEF_PORT_DISABLE_SELF;
 	usb251xb_get_ports_field(hub, "sp-disabled-ports", data->port_cnt,
-				 &hub->port_disable_sp);
+				 true, &hub->port_disable_sp);
 
 	hub->port_disable_bp = USB251XB_DEF_PORT_DISABLE_BUS;
 	usb251xb_get_ports_field(hub, "bp-disabled-ports", data->port_cnt,
-				 &hub->port_disable_bp);
+				 true, &hub->port_disable_bp);
 
 	hub->max_power_sp = USB251XB_DEF_MAX_POWER_SELF;
 	if (!of_property_read_u32(np, "sp-max-total-current-microamp",
@@ -573,7 +574,7 @@ static int usb251xb_get_ofdata(struct us
 	 */
 	hub->port_swap = USB251XB_DEF_PORT_SWAP;
 	usb251xb_get_ports_field(hub, "swap-dx-lanes", data->port_cnt,
-				 &hub->port_swap);
+				 false, &hub->port_swap);
 
 	/* The following parameters are currently not exposed to devicetree, but
 	 * may be as soon as needed.


