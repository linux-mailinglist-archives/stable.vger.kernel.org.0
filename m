Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2901C5A78A8
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiHaIPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 04:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiHaIPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 04:15:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A9B67177;
        Wed, 31 Aug 2022 01:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860606198E;
        Wed, 31 Aug 2022 08:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED04C433C1;
        Wed, 31 Aug 2022 08:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661933735;
        bh=+7v+mKDgW+IHX/GhERatR6jBtG0aN65CVgOFZj60fjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiA32G8nKw2SXdNn1AShGphfXahL8TREP5HGgwmK28xdzoy8/C2hzzQKfclaG0SJl
         NwqNzqDtlJxcKhvWq5bK3RiiUnzr1RdWmXTK3b3dZE6jLc7zkptDs6YofhHac/twxz
         CGY0frtsQRDdoafslByShDYajCXpnBR5qw/yWU+qQjSnZ/RG/lFLq0TVb/VwYQbn90
         3H/MtXKUwL/N436BpvwfZVxd/FLVTQVw/OdkrAepv/6nIX+ZrvPErQ+MXNg8Gmi8Uf
         AVMdd9yYqBOI19xCf9S5soT8fkvOZhFc8E07U26j7iKJMa+J7m5TyAStcKQu99z8Ci
         Q/wbedYc6YYEg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oTIsn-0007xA-NM; Wed, 31 Aug 2022 10:15:33 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] USB: serial: ch341: fix lost character on LCR updates
Date:   Wed, 31 Aug 2022 10:15:24 +0200
Message-Id: <20220831081525.30557-2-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220831081525.30557-1-johan@kernel.org>
References: <20220831081525.30557-1-johan@kernel.org>
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

Disable LCR updates for pre-0x30 devices which use a different (unknown)
protocol for line control and where the current register write causes
the next received character to be lost.

Note that updating LCR using the INIT command has no effect on these
devices either.

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
Fixes: 55fa15b5987d ("USB: serial: ch341: fix baud rate and line-control handling")
Cc: stable@vger.kernel.org      # 4.10
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

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
-- 
2.35.1

