Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35ADE5AEA1F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiIFNjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbiIFNht (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:37:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1931EEE7;
        Tue,  6 Sep 2022 06:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C8B2CE1771;
        Tue,  6 Sep 2022 13:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33BBC433D6;
        Tue,  6 Sep 2022 13:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662471274;
        bh=LzwaatPM3hNldsGc6C17lYweTPagmZOQHDFn+HmOCNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDf9myQNXbEbw0Pi7xAGf165ad6z5MJKc6tCoMYQruoWPIYmqfQATf1ViFysZ/8Qh
         x2DFbQil/8kw9Q4i8ObY4MPH30EIQV7xEp42pYqzkkefywK3rad6/IHfEMGebc3E5Z
         4FMDG2lKYT3Uy0SU1RdPrTTmZDA8Wi1ldwIQpLLsOlGsYGpyngKH4xxTjs1UPhrnsJ
         mJTM/GOkoO1FfY5E5sjcRFeHt7cKBmQawt0lbjZ082vT/Y4w0c6LKD3HJyhpjq73ne
         S4KBa/hoaG8oe64rG4v5IpxJRGPsthk5rBTNWX4vy2YQDi+fmOPtLjcNnHEq1AgotL
         YwOP8BQvvJdBA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVYit-0006sz-7j; Tue, 06 Sep 2022 15:34:39 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Subject: [PATCH stable-5.4 2/3] USB: serial: ch341: fix lost character on LCR updates
Date:   Tue,  6 Sep 2022 15:34:34 +0200
Message-Id: <20220906133435.26452-3-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906133435.26452-1-johan@kernel.org>
References: <20220906133435.26452-1-johan@kernel.org>
MIME-Version: 1.0
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

commit 8e83622ae7ca481c76c8fd9579877f6abae64ca2 upstream.

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
[ johan: adjust context to 5.4 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index f06a09e59d8b..be44d6c28df6 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -96,7 +96,9 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
 	unsigned long quirks;
+	u8 version;
 };
 
 static void ch341_set_termios(struct tty_struct *tty,
@@ -182,6 +184,9 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	if (r)
 		return r;
 
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 0x2518, lcr);
 	if (r)
 		return r;
@@ -233,7 +238,9 @@ static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
 	r = ch341_control_in(dev, CH341_REQ_READ_VERSION, 0, 0, buffer, size);
 	if (r < 0)
 		goto out;
-	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", buffer[0]);
+
+	priv->version = buffer[0];
+	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", priv->version);
 
 	r = ch341_control_out(dev, CH341_REQ_SERIAL_INIT, 0, 0);
 	if (r < 0)
-- 
2.35.1

