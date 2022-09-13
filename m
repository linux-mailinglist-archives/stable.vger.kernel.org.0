Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D695B7664
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 18:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiIMQYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiIMQXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 12:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE82A98FD;
        Tue, 13 Sep 2022 08:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 072C8614CE;
        Tue, 13 Sep 2022 14:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F886C433D6;
        Tue, 13 Sep 2022 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079767;
        bh=/FD+XJlkiYnUlmeTNebsc0OZTkHSly0huwW07NOq6uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhD5onltNePqUP5a0vuNlXC9Zhc1iIR2UjxCjzIKll3cP1ELxFAz7dGb8luV+Ss92
         AALB+j/KgVzUqyCti7fUyq4nGyXyl5ii5yeBq//dUYPXfFvKVT2IxLM206Hn/O9KwL
         91S5iArkBe1e6uCLV638pzFdS6qCIRGQTSJp7Xr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Woithe <jwoithe@just42.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 58/61] USB: serial: ch341: fix lost character on LCR updates
Date:   Tue, 13 Sep 2022 16:08:00 +0200
Message-Id: <20220913140349.360305890@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Johan Hovold <johan@kernel.org>

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
[ johan: adjust context to 4.19 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -99,6 +99,8 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
+	u8 version;
 };
 
 static void ch341_set_termios(struct tty_struct *tty,
@@ -184,6 +186,9 @@ static int ch341_set_baudrate_lcr(struct
 	if (r)
 		return r;
 
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 0x2518, lcr);
 	if (r)
 		return r;
@@ -235,7 +240,9 @@ static int ch341_configure(struct usb_de
 	r = ch341_control_in(dev, CH341_REQ_READ_VERSION, 0, 0, buffer, size);
 	if (r < 0)
 		goto out;
-	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", buffer[0]);
+
+	priv->version = buffer[0];
+	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", priv->version);
 
 	r = ch341_control_out(dev, CH341_REQ_SERIAL_INIT, 0, 0);
 	if (r < 0)


