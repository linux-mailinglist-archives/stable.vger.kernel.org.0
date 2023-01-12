Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0124F667708
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbjALOjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbjALOiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:38:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6B561470
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:28:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75BF2B8113E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CD9C433D2;
        Thu, 12 Jan 2023 14:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533701;
        bh=BrglO72aGgIDUCnSTd7qS7EwqALWhU6mg7lEWRQ2jfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaZxasjp8M17NjdKLqwgM6M6CHgnE9dQzo7JeWFzak9yed+8KNdL4gfJmtwwp/gfh
         rffwHE40Jj9uUUtGyOE0QbpGSoOGFyz9Ltq9Cd7s7TI1SzfX1mwewAyQc+VVyy2vOv
         AtfPilEDlZazPqsJaO1dl4j+xJhQYesoq7Z2GzsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Sven=20Z=C3=BChlsdorf?= <sven.zuehlsdorf@vigem.de>,
        Enrik Berkhan <Enrik.Berkhan@inka.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.10 562/783] HID: mcp2221: dont connect hidraw
Date:   Thu, 12 Jan 2023 14:54:38 +0100
Message-Id: <20230112135550.305660489@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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


