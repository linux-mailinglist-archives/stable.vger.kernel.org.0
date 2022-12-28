Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DCD6584E7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiL1RDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiL1RDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B84A1DDC2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:57:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 053AEB8188B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1ABC433F0;
        Wed, 28 Dec 2022 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246654;
        bh=BrglO72aGgIDUCnSTd7qS7EwqALWhU6mg7lEWRQ2jfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZavCSwGiJ5W/g8bgngmTw+Ubjb2yrsn4o9E3OmOyVRb+OAHLHvhfctHO0VHzTtir
         eoMS/iLDVverQZk3hZ5zrYXYZ/Hhi3u+usIEOYe+l67nce21XY7CBB6iT6qpyssNR0
         kHSilbGLSiDRWexmPIXcWeP/Glj6MpTZzma3nRtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Sven=20Z=C3=BChlsdorf?= <sven.zuehlsdorf@vigem.de>,
        Enrik Berkhan <Enrik.Berkhan@inka.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 6.1 1114/1146] HID: mcp2221: dont connect hidraw
Date:   Wed, 28 Dec 2022 15:44:13 +0100
Message-Id: <20221228144400.409180355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enrik Berkhan <Enrik.Berkhan@inka.de>

commit 67c90d14018775556d5420382ace86521421f9ff upstream.

The MCP2221 driver should not connect to the hidraw userspace interface,
as it needs exclusive access to the chip.

If you want to use /dev/hidrawX with the MCP2221, you need to avoid
binding this driver to the device and use the hid generic driver instead
(e.g. using udev rules).

Cc: stable@vger.kernel.org
Reported-by: Sven Zühlsdorf <sven.zuehlsdorf@vigem.de>
Signed-off-by: Enrik Berkhan <Enrik.Berkhan@inka.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221103222714.21566-2-Enrik.Berkhan@inka.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -840,12 +840,19 @@ static int mcp2221_probe(struct hid_devi
 		return ret;
 	}
 
-	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	/*
+	 * This driver uses the .raw_event callback and therefore does not need any
+	 * HID_CONNECT_xxx flags.
+	 */
+	ret = hid_hw_start(hdev, 0);
 	if (ret) {
 		hid_err(hdev, "can't start hardware\n");
 		return ret;
 	}
 
+	hid_info(hdev, "USB HID v%x.%02x Device [%s] on %s\n", hdev->version >> 8,
+			hdev->version & 0xff, hdev->name, hdev->phys);
+
 	ret = hid_hw_open(hdev);
 	if (ret) {
 		hid_err(hdev, "can't open device\n");
@@ -870,8 +877,7 @@ static int mcp2221_probe(struct hid_devi
 	mcp->adapter.retries = 1;
 	mcp->adapter.dev.parent = &hdev->dev;
 	snprintf(mcp->adapter.name, sizeof(mcp->adapter.name),
-			"MCP2221 usb-i2c bridge on hidraw%d",
-			((struct hidraw *)hdev->hidraw)->minor);
+			"MCP2221 usb-i2c bridge");
 
 	ret = i2c_add_adapter(&mcp->adapter);
 	if (ret) {


