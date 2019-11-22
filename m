Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2BE106D7D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfKVLAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfKVLAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:00:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65BED20730;
        Fri, 22 Nov 2019 11:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420430;
        bh=xLo8An/GGtaYvQusuEEVTAK6bx26bpriaCZTP8Q7WCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVAXDmwGpNVWNDc+iWGV9D0nLAM3Czi7sTeRIaiM2YQ53lpQz+KbzAWn8G9bh5V5E
         zRS4TZffqKSXhXhoniWciB7NFIvFMGMAWDfEp+0l9Ai9/U+YyQM8nS/2KSv7Gb5A1E
         4+Qp0CrH93lOh19zykytlt6sxhIIl84bVvn/35Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/220] media: i2c: adv748x: Support probing a single output
Date:   Fri, 22 Nov 2019 11:27:48 +0100
Message-Id: <20191122100920.186984454@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit eccf442ce156ec2b4e06b1239d5fdcb0c732f63f ]

Currently the adv748x driver will fail to probe unless both of its
output endpoints (TXA and TXB) are connected.

Make the driver support probing provided that there is at least one
input, and one output connected and protect the clean-up function from
accessing un-initialized fields.

Following patches will fix other uses of un-initialized TXs in the driver,
such as power management functions.

Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 25 +++++++++++++++++++++---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 18 ++++++-----------
 drivers/media/i2c/adv748x/adv748x.h      |  2 ++
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 6ca88daa0ecd7..65c3024c5f76f 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -569,7 +569,8 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 {
 	struct device_node *ep_np = NULL;
 	struct of_endpoint ep;
-	bool found = false;
+	bool out_found = false;
+	bool in_found = false;
 
 	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
 		of_graph_parse_endpoint(ep_np, &ep);
@@ -592,10 +593,17 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 		of_node_get(ep_np);
 		state->endpoints[ep.port] = ep_np;
 
-		found = true;
+		/*
+		 * At least one input endpoint and one output endpoint shall
+		 * be defined.
+		 */
+		if (ep.port < ADV748X_PORT_TXA)
+			in_found = true;
+		else
+			out_found = true;
 	}
 
-	return found ? 0 : -ENODEV;
+	return in_found && out_found ? 0 : -ENODEV;
 }
 
 static void adv748x_dt_cleanup(struct adv748x_state *state)
@@ -627,6 +635,17 @@ static int adv748x_probe(struct i2c_client *client,
 	state->i2c_clients[ADV748X_PAGE_IO] = client;
 	i2c_set_clientdata(client, state);
 
+	/*
+	 * We can not use container_of to get back to the state with two TXs;
+	 * Initialize the TXs's fields unconditionally on the endpoint
+	 * presence to access them later.
+	 */
+	state->txa.state = state->txb.state = state;
+	state->txa.page = ADV748X_PAGE_TXA;
+	state->txb.page = ADV748X_PAGE_TXB;
+	state->txa.port = ADV748X_PORT_TXA;
+	state->txb.port = ADV748X_PORT_TXB;
+
 	/* Discover and process ports declared by the Device tree endpoints */
 	ret = adv748x_parse_dt(state);
 	if (ret) {
diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 469be87a3761f..556e13c911a62 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -266,19 +266,10 @@ static int adv748x_csi2_init_controls(struct adv748x_csi2 *tx)
 
 int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
 {
-	struct device_node *ep;
 	int ret;
 
-	/* We can not use container_of to get back to the state with two TXs */
-	tx->state = state;
-	tx->page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
-
-	ep = state->endpoints[is_txa(tx) ? ADV748X_PORT_TXA : ADV748X_PORT_TXB];
-	if (!ep) {
-		adv_err(state, "No endpoint found for %s\n",
-				is_txa(tx) ? "txa" : "txb");
-		return -ENODEV;
-	}
+	if (!is_tx_enabled(tx))
+		return 0;
 
 	/* Initialise the virtual channel */
 	adv748x_csi2_set_virtual_channel(tx, 0);
@@ -288,7 +279,7 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
 			    is_txa(tx) ? "txa" : "txb");
 
 	/* Ensure that matching is based upon the endpoint fwnodes */
-	tx->sd.fwnode = of_fwnode_handle(ep);
+	tx->sd.fwnode = of_fwnode_handle(state->endpoints[tx->port]);
 
 	/* Register internal ops for incremental subdev registration */
 	tx->sd.internal_ops = &adv748x_csi2_internal_ops;
@@ -321,6 +312,9 @@ int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
 
 void adv748x_csi2_cleanup(struct adv748x_csi2 *tx)
 {
+	if (!is_tx_enabled(tx))
+		return;
+
 	v4l2_async_unregister_subdev(&tx->sd);
 	media_entity_cleanup(&tx->sd.entity);
 	v4l2_ctrl_handler_free(&tx->ctrl_hdl);
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 65f83741277e1..1cf46c401664d 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -82,6 +82,7 @@ struct adv748x_csi2 {
 	struct adv748x_state *state;
 	struct v4l2_mbus_framefmt format;
 	unsigned int page;
+	unsigned int port;
 
 	struct media_pad pads[ADV748X_CSI2_NR_PADS];
 	struct v4l2_ctrl_handler ctrl_hdl;
@@ -91,6 +92,7 @@ struct adv748x_csi2 {
 
 #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
 #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
+#define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] != NULL)
 
 enum adv748x_hdmi_pads {
 	ADV748X_HDMI_SINK,
-- 
2.20.1



