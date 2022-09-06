Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9549A5AE809
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240097AbiIFMZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239790AbiIFMYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:24:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6E27F0A5;
        Tue,  6 Sep 2022 05:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F201B818B3;
        Tue,  6 Sep 2022 12:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12500C43140;
        Tue,  6 Sep 2022 12:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662466890;
        bh=UazPhnVpTJHRjiUmKc2QQMoFoLORH7z85kfQ7iHso9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FhZR3ffNhItupbQPCx9kPqPygsVPhMlg2qGnK/tDU/WUo+1TMyTbeGOO4cQBHTuGo
         KiKZM8IU1Zf5p4HflNlMteVCXYVJSzx4NxYioQDW7EG8MfBpEQmiUo5so1JMqV91e4
         5n7gZhO+xXUo3JSvcDXOxCsOggghEpPdSUfMq057HKIF2MzPlqF+TPFI4UHyGfPFA+
         tpL8EFCzeIPZ4AZUFBXpP2ChS30jST3iRqTYK9NopBJwpDaWq0PJDYFpJpMTaQbDsW
         Xz11wIETYbgnL5YRClTQiz/tEu+5Ie10prnp6gGhPR9FmAA22YVsJ//pMq7RYHvQM9
         UNNcXMycafeEQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVXaA-00089W-Cq; Tue, 06 Sep 2022 14:21:34 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Subject: [PATCH stable-5.15 2/2] USB: serial: ch341: fix disabled rx timer on older devices
Date:   Tue,  6 Sep 2022 14:21:27 +0200
Message-Id: <20220906122127.31321-3-johan@kernel.org>
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

commit 41ca302a697b64a3dab4676e01d0d11bb184737d upstream.

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
---
 drivers/usb/serial/ch341.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index b787533aec64..752daa952abd 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -259,8 +259,12 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
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
-- 
2.35.1

