Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067EE55AAF3
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiFYO00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiFYO0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B161E0ED
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B606C61451
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D909C3411C;
        Sat, 25 Jun 2022 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656167184;
        bh=hHC3f/VXNIyg1ci0JjSM9jPFtXBrh4mwyGC6W+6eH1w=;
        h=Subject:To:Cc:From:Date:From;
        b=rUAnN7n0VKhltwPyXdel7pwsDcL1cwcFkq2f1Y6bj8mHh64haTWUfoUFHM+G3Y+Y9
         Qq2y0dK+vdC4cERh336wkmgD2lqs/ecW2otIwC70G+oGdpctAWIWJOrEVECaY3783D
         yejud3wlRQQm7XLayC0r+vhRoIUKdQZDeHTmHGTU=
Subject: FAILED: patch "[PATCH] net: dsa: qca8k: reset cpu port on MTU change" failed to apply to 5.15-stable tree
To:     ansuelsmth@gmail.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 16:26:12 +0200
Message-ID: <1656167172101151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 386228c694bf1e7a7688e44412cb33500b0ac585 Mon Sep 17 00:00:00 2001
From: Christian Marangi <ansuelsmth@gmail.com>
Date: Tue, 21 Jun 2022 17:11:22 +0200
Subject: [PATCH] net: dsa: qca8k: reset cpu port on MTU change

It was discovered that the Documentation lacks of a fundamental detail
on how to correctly change the MAX_FRAME_SIZE of the switch.

In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
switch panics and cease to send any packet. This cause the mgmt ethernet
system to not receive any packet (the slow fallback still works) and
makes the device not reachable. To recover from this a switch reset is
required.

To correctly handle this, turn off the cpu ports before changing the
MAX_FRAME_SIZE and turn on again after the value is applied.

Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/20220621151122.10220-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2727d3169c25..1cbb05b0323f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2334,6 +2334,7 @@ static int
 qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	/* We have only have a general MTU setting.
 	 * DSA always set the CPU port's MTU to the largest MTU of the slave
@@ -2344,8 +2345,27 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
 
+	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
+	 * the switch panics.
+	 * Turn off both cpu ports before applying the new value to prevent
+	 * this.
+	 */
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 0);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 0);
+
 	/* Include L2 header / FCS length */
-	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
+
+	if (priv->port_enabled_map & BIT(0))
+		qca8k_port_set_status(priv, 0, 1);
+
+	if (priv->port_enabled_map & BIT(6))
+		qca8k_port_set_status(priv, 6, 1);
+
+	return ret;
 }
 
 static int

