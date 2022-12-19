Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0853650E60
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 16:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiLSPNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 10:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbiLSPNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 10:13:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4E063B3
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 07:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEDF960FEF
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 15:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA68C433F0;
        Mon, 19 Dec 2022 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671462791;
        bh=Nxyki6dXX/UMIxzzE8kY49sa3R71fcCjQRyuMw2K2Es=;
        h=Subject:To:Cc:From:Date:From;
        b=1I3EgUSLjAesQmQK6Bx6GskqzDJ9OWJyjCNMCtlGed+JuNu52s+vgoUsG4LYVPfvS
         RiM/vzekxs0gP7B9HS0bqCgbGoHvIJ6sEluDD2e4hn87AUcp9WuV7+BGODpXVB5lCj
         lw1V9HaLWzlY1IWOseqyJ7D1Hz4xQQ7mPJYsbhMI=
Subject: FAILED: patch "[PATCH] usb: musb: remove extra check in musb_gadget_vbus_draw" failed to apply to 4.14-stable tree
To:     ivo.g.dimitrov.75@gmail.com, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Dec 2022 16:12:54 +0100
Message-ID: <16714627744996@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ecec4b20d29c ("usb: musb: remove extra check in musb_gadget_vbus_draw")
a6d45ea063f0 ("usb: musb: Allow running without CONFIG_USB_PHY")
21acc656a06e ("usb: musb: Add and use inline functions musb_{get,set}_state")
df561f6688fe ("treewide: Use fallthrough pseudo-keyword")
37711e5e2325 ("Merge tag 'nfs-for-5.9-1' of git://git.linux-nfs.org/projects/trondmy/linux-nfs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ecec4b20d29c3d6922dafe7d2555254a454272d2 Mon Sep 17 00:00:00 2001
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Date: Fri, 25 Nov 2022 20:21:15 +0200
Subject: [PATCH] usb: musb: remove extra check in musb_gadget_vbus_draw

The checks for musb->xceiv and musb->xceiv->set_power duplicate those in
usb_phy_set_power(), so there is no need of them. Moreover, not calling
usb_phy_set_power() results in usb_phy_set_charger_current() not being
called, so current USB config max current is not propagated through USB
charger framework and charger drivers may try to draw more current than
allowed or possible.

Fix that by removing those extra checks and calling usb_phy_set_power()
directly.

Tested on Motorola Droid4 and Nokia N900

Fixes: a9081a008f84 ("usb: phy: Add USB charger support")
Cc: stable <stable@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Link: https://lore.kernel.org/r/1669400475-4762-1-git-send-email-ivo.g.dimitrov.75@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 6cb9514ef340..31c44325e828 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1630,8 +1630,6 @@ static int musb_gadget_vbus_draw(struct usb_gadget *gadget, unsigned mA)
 {
 	struct musb	*musb = gadget_to_musb(gadget);
 
-	if (!musb->xceiv || !musb->xceiv->set_power)
-		return -EOPNOTSUPP;
 	return usb_phy_set_power(musb->xceiv, mA);
 }
 

