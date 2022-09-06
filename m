Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033CA5AE807
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbiIFMZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbiIFMYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:24:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5853501B4;
        Tue,  6 Sep 2022 05:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81F86614F0;
        Tue,  6 Sep 2022 12:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD631C433C1;
        Tue,  6 Sep 2022 12:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662466889;
        bh=PQWS0UART7yS+jRUH51JOWBPjnSkBvCuooSFXqUjy8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1EtzBcEUDpU92w9/S9s7gdjXxkdOUxTnKy6iEzlIN4tA339wI2fzQzS1YQ9YQelR
         79WGO+u/Thh7YkFtsXNDiWcND8PJHVjZlEbldGgLJNHU39vWVT2wkfBDwI15ryJTeZ
         MyVRBgHJcu7lup5LKLXMv9cS5baFj5J/39OWIOlGSxcxYHHb6Q1PZ63mqrjPpjY+qt
         hafn1sa+PeTKB8LCtCUhjmzMop6aXmOGB7tNvYREelZTz54JWMG/uRwb72f+lr6x/P
         3i0weEk4SfwgLu280RQ0fZ1wlN+67svFbzc3X3NzfYIPmR5p5cGBZ7S54k7Ms5lvSc
         a0QzbOC2T9OwA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVXaA-00089U-Af; Tue, 06 Sep 2022 14:21:34 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Subject: [PATCH stable-5.15 1/2] USB: serial: ch341: fix lost character on LCR updates
Date:   Tue,  6 Sep 2022 14:21:26 +0200
Message-Id: <20220906122127.31321-2-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906122127.31321-1-johan@kernel.org>
References: <20220906122127.31321-1-johan@kernel.org>
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
[ johan: adjust context to 5.15 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index b5a1864e9cfd..b787533aec64 100644
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
 
@@ -271,6 +274,9 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	 * (stop bits, parity and word length). Version 0x30 and above use
 	 * CH341_REG_LCR only and CH341_REG_LCR2 is always set to zero.
 	 */
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
 			      CH341_REG_LCR2 << 8 | CH341_REG_LCR, lcr);
 	if (r)
@@ -323,7 +329,9 @@ static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
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

