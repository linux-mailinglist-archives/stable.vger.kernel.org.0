Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA835B774A
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiIMRGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiIMRGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:06:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECA383F37;
        Tue, 13 Sep 2022 08:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4FE5B80F93;
        Tue, 13 Sep 2022 14:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C47C433B5;
        Tue, 13 Sep 2022 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079579;
        bh=HwcKgcx3YUW4O5fZ2Dy56K8an7bFPB5SAM8Cc7hYdjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JycDiVG3WxZgYxXeB8FI3lh/mBbcrIkej/L1cQ9DOVYTHw4lgT9xRyZp+rRWZpkit
         cU9f3Wk8215O6D1+EC9gCACSzuJMeogxTi3lBm6yrUp5U94Zk9tCvo3jgwdrMFnV8w
         tgpm4TvyLu14tg2skmk7Vz0D5tPr1Me3a/60kDLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Woithe <jwoithe@just42.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 74/79] USB: serial: ch341: fix lost character on LCR updates
Date:   Tue, 13 Sep 2022 16:07:32 +0200
Message-Id: <20220913140352.462146395@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
@@ -96,6 +96,8 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
+	u8 version;
 };
 
 static void ch341_set_termios(struct tty_struct *tty,
@@ -181,6 +183,9 @@ static int ch341_set_baudrate_lcr(struct
 	if (r)
 		return r;
 
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 0x2518, lcr);
 	if (r)
 		return r;
@@ -232,7 +237,9 @@ static int ch341_configure(struct usb_de
 	r = ch341_control_in(dev, CH341_REQ_READ_VERSION, 0, 0, buffer, size);
 	if (r < 0)
 		goto out;
-	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", buffer[0]);
+
+	priv->version = buffer[0];
+	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", priv->version);
 
 	r = ch341_control_out(dev, CH341_REQ_SERIAL_INIT, 0, 0);
 	if (r < 0)


