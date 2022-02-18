Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13514BBAA4
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbiBROcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:32:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiBROcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:32:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C29244D9E
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:32:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A0DAB82657
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88063C340E9;
        Fri, 18 Feb 2022 14:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645194721;
        bh=o7qiBqlE6quEeakgRkocE/VJvop86UJSjFHrNuwu6Zs=;
        h=Subject:To:Cc:From:Date:From;
        b=WxPXrXnysrGCM6/TkGmh6nfpL0sSJeugY8UyGk0ZCaxE+7yO7xS+J/PXwr+xY9VL9
         aTlZ6ex4SP3xaR84wLPG36tOBaV+AGDKvBfChEP7ar4HIjB/Id/StAtOR/ySKGkxhK
         yrOvhaQe3w/7gaYW5/tFWReH/U8DwGy6/KgIiZ2Q=
Subject: FAILED: patch "[PATCH] net: dsa: lan9303: fix reset on probe" failed to apply to 4.14-stable tree
To:     mans@mansr.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:31:58 +0100
Message-ID: <1645194718215180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

From 6bb9681a43f34f2cab4aad6e2a02da4ce54d13c5 Mon Sep 17 00:00:00 2001
From: Mans Rullgard <mans@mansr.com>
Date: Wed, 9 Feb 2022 14:54:54 +0000
Subject: [PATCH] net: dsa: lan9303: fix reset on probe

The reset input to the LAN9303 chip is active low, and devicetree
gpio handles reflect this.  Therefore, the gpio should be requested
with an initial state of high in order for the reset signal to be
asserted.  Other uses of the gpio already use the correct polarity.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Mans Rullgard <mans@mansr.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fianelil <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220209145454.19749-1-mans@mansr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index d55784d19fa4..873a5588171b 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1310,7 +1310,7 @@ static int lan9303_probe_reset_gpio(struct lan9303 *chip,
 				     struct device_node *np)
 {
 	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
-						   GPIOD_OUT_LOW);
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(chip->reset_gpio))
 		return PTR_ERR(chip->reset_gpio);
 

