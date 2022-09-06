Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9645AE6C8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiIFLnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiIFLnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:43:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395AE33401
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF675B81684
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63013C433D7;
        Tue,  6 Sep 2022 11:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662464618;
        bh=9s9v0orFS6h1agJvPswPl08qthULOfshfn1gNh0oYu8=;
        h=Subject:To:Cc:From:Date:From;
        b=MqUZlb52V4uO9iqVjns0IHkuRtldTjZzRsh1q3g5+scaay5c+1U5zoLZOw4JOggq4
         3ng/eK7Ev1zumygfTLGQvCQpb1tPIXuohzP8R5sPbABvhzGIgILeHQA89op8kL8Jdu
         L8IWqnmPIFzfFqWvCsurwuBjJYgwX8H3+npjn+Is=
Subject: FAILED: patch "[PATCH] USB: serial: ch341: fix disabled rx timer on older devices" failed to apply to 5.15-stable tree
To:     johan@kernel.org, jwoithe@just42.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:42:08 +0200
Message-ID: <1662464528244161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Possible dependencies:

41ca302a697b ("USB: serial: ch341: fix disabled rx timer on older devices")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 41ca302a697b64a3dab4676e01d0d11bb184737d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 31 Aug 2022 10:15:25 +0200
Subject: [PATCH] USB: serial: ch341: fix disabled rx timer on older devices

At least one older CH341 appears to have the RX timer enable bit
inverted so that setting it disables the RX timer and prevents the FIFO
from emptying until it is full.

Only set the RX timer enable bit for devices with version newer than
0x27 (even though this probably affects all pre-0x30 devices).

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Tested-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
Cc: stable@vger.kernel.org      # 4.10
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 2bcce172355b..af01a462cc43 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -253,8 +253,12 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	/*
 	 * CH341A buffers data until a full endpoint-size packet (32 bytes)
 	 * has been received unless bit 7 is set.
+	 *
+	 * At least one device with version 0x27 appears to have this bit
+	 * inverted.
 	 */
-	val |= BIT(7);
+	if (priv->version > 0x27)
+		val |= BIT(7);
 
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
 			      CH341_REG_DIVISOR << 8 | CH341_REG_PRESCALER,

