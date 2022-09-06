Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33605AE684
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239730AbiIFLXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiIFLXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:23:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C71032BB9
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0882B81731
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C86C433D6;
        Tue,  6 Sep 2022 11:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463431;
        bh=SgiOEIS9TYpXnyxqCPkNODR4ZriHCRniwa7r0KfU49k=;
        h=Subject:To:Cc:From:Date:From;
        b=FbuB9C8PymTIuIpmUkd1ZhioHWRFpDBoaAPPoZQczO0qqDsyIzhpTp8iVX87I8qbN
         mwd/NgOeThYgN5RffiB70pNBYCWB4m9wc06vXknWcD8skD+rPg3DJEUAk298mU8DFQ
         BTfSRS3W2e0Ac4359qsg6QmVEd8SHkIHnXBq+LUw=
Subject: FAILED: patch "[PATCH] USB: serial: ch341: fix lost character on LCR updates" failed to apply to 4.14-stable tree
To:     johan@kernel.org, jwoithe@just42.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:23:42 +0200
Message-ID: <1662463422197244@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8e83622ae7ca481c76c8fd9579877f6abae64ca2 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 31 Aug 2022 10:15:24 +0200
Subject: [PATCH] USB: serial: ch341: fix lost character on LCR updates

Disable LCR updates for pre-0x30 devices which use a different (unknown)
protocol for line control and where the current register write causes
the next received character to be lost.

Note that updating LCR using the INIT command has no effect on these
devices either.

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Tested-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
Fixes: 55fa15b5987d ("USB: serial: ch341: fix baud rate and line-control handling")
Cc: stable@vger.kernel.org      # 4.10
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 2798fca71261..2bcce172355b 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -97,7 +97,10 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
 	unsigned long quirks;
+	u8 version;
+
 	unsigned long break_end;
 };
 
@@ -265,6 +268,9 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	 * (stop bits, parity and word length). Version 0x30 and above use
 	 * CH341_REG_LCR only and CH341_REG_LCR2 is always set to zero.
 	 */
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
 			      CH341_REG_LCR2 << 8 | CH341_REG_LCR, lcr);
 	if (r)
@@ -308,7 +314,9 @@ static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
 	r = ch341_control_in(dev, CH341_REQ_READ_VERSION, 0, 0, buffer, size);
 	if (r)
 		return r;
-	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", buffer[0]);
+
+	priv->version = buffer[0];
+	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", priv->version);
 
 	r = ch341_control_out(dev, CH341_REQ_SERIAL_INIT, 0, 0);
 	if (r < 0)

