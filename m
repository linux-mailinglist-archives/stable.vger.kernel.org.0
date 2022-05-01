Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6385165BB
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351082AbiEAQy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 12:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbiEAQxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 12:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F4FBEB
        for <stable@vger.kernel.org>; Sun,  1 May 2022 09:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2012B60F7A
        for <stable@vger.kernel.org>; Sun,  1 May 2022 16:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CF5C385C0;
        Sun,  1 May 2022 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651423810;
        bh=RyxBhPjwrAOFrNtxlPgRoBEPVcptKmcndggv8Qy4diw=;
        h=Subject:To:Cc:From:Date:From;
        b=AQ66jPIrRrvGwLqSawo2ijs+jz2bBHLHDOhrbyP5hZt7ioNqj1MXFOG0LY/GNZPcM
         OuowEC94VJZUq6kN7Tj9h9isP/okq3Wm/OYVlzpLC8n5ZP5IKffErYxa4aqJMlQP9h
         G++F+zgc7eM2TW4p7nGexb4qSjvqg87G4GH69FvY=
Subject: FAILED: patch "[PATCH] usb: phy: generic: Get the vbus supply" failed to apply to 4.14-stable tree
To:     sean.anderson@seco.com, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 18:40:57 +0200
Message-ID: <1651423257158114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03e607cbb2931374db1825f371e9c7f28526d3f4 Mon Sep 17 00:00:00 2001
From: Sean Anderson <sean.anderson@seco.com>
Date: Mon, 25 Apr 2022 13:14:09 -0400
Subject: [PATCH] usb: phy: generic: Get the vbus supply

While support for working with a vbus was added, the regulator was never
actually gotten (despite what was documented). Fix this by actually
getting the supply from the device tree.

Fixes: 7acc9973e3c4 ("usb: phy: generic: add vbus support")
Cc: stable <stable@kernel.org>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20220425171412.1188485-3-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index 661a229c105d..34b9f8140187 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -268,6 +268,13 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop)
 			return -EPROBE_DEFER;
 	}
 
+	nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");
+	if (PTR_ERR(nop->vbus_draw) == -ENODEV)
+		nop->vbus_draw = NULL;
+	if (IS_ERR(nop->vbus_draw))
+		return dev_err_probe(dev, PTR_ERR(nop->vbus_draw),
+				     "could not get vbus regulator\n");
+
 	nop->dev		= dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";

