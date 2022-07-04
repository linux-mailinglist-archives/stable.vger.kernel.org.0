Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC9A5656CD
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbiGDNQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiGDNQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:16:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95134638A
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:16:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D08EB80EFF
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674D9C3411E;
        Mon,  4 Jul 2022 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656940603;
        bh=tJT9XIxmQ3Vyniu6Ylh5KKE/g/EPp/nb5KGqOhgXw3I=;
        h=Subject:To:Cc:From:Date:From;
        b=X+7QlIk/VwbZEqrD8jRbDdTaV+NSUF2S29zhoZHxnXEG0d7B67xK9kkMhCscN6uEA
         l/1S032eWtLXmh+rGa+2xzlGnGS3du1o6ZuwIqJCUvhGwxnqR9xbdXwmD5p6NNT++b
         OscXdp830I6KUsIDRuvuDwap/D7iNl/OE83nNVKc=
Subject: FAILED: patch "[PATCH] net: sparx5: mdb add/del handle non-sparx5 devices" failed to apply to 5.18-stable tree
To:     casper.casan@gmail.com, Steen.Hegelund@microchip.com,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:16:40 +0200
Message-ID: <165694060077121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9c5de246c1dbe785268fc2e83c88624b92e4ec93 Mon Sep 17 00:00:00 2001
From: Casper Andersson <casper.casan@gmail.com>
Date: Thu, 30 Jun 2022 14:22:26 +0200
Subject: [PATCH] net: sparx5: mdb add/del handle non-sparx5 devices

When adding/deleting mdb entries on other net_devices, eg., tap
interfaces, it should not crash.

Fixes: 3bacfccdcb2d ("net: sparx5: Add mdb handlers")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Link: https://lore.kernel.org/r/20220630122226.316812-1-casper.casan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 3429660cd2e5..5edc8b7176c8 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -396,6 +396,9 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	u32 mact_entry;
 	int res, err;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	if (netif_is_bridge_master(v->obj.orig_dev)) {
 		sparx5_mact_learn(spx5, PGID_CPU, v->addr, v->vid);
 		return 0;
@@ -466,6 +469,9 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 	u32 mact_entry, res, pgid_entry[3];
 	int err;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	if (netif_is_bridge_master(v->obj.orig_dev)) {
 		sparx5_mact_forget(spx5, v->addr, v->vid);
 		return 0;

