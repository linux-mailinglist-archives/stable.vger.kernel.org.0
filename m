Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152D25AE9E5
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbiIFNey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240528AbiIFNeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:34:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C941776458;
        Tue,  6 Sep 2022 06:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21D1DB8162F;
        Tue,  6 Sep 2022 13:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10802C433C1;
        Tue,  6 Sep 2022 13:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471196;
        bh=zg/sOoQpE0AjjldedRJe+dc3QpG3rVgfQcCR/ffvN9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+z/m6qhTcMGqYx6dvEJe+YzdttGa2k3OiH3msDUyG0reyPla+dC5SsuAwF7yEk2S
         yVdMKe9kaWHEUlJ2ERZWdGi6kj9RW48kYbq7nr4at/mGv7aYepfmH+inGCMTMXQx+5
         R3/7pfCfUl9w0fXw0ExtFHsII+MYdoT5sQmfwnHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niek Nooijens <niek.nooijens@omron.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 31/80] USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id
Date:   Tue,  6 Sep 2022 15:30:28 +0200
Message-Id: <20220906132818.263246100@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Niek Nooijens <niek.nooijens@omron.com>

commit 001047ea241a9646010b2744451dfbc7289542f3 upstream.

works perfectly with:
modprobe ftdi_sio
echo "0590 00b2" | tee
/sys/module/ftdi_sio/drivers/usb-serial\:ftdi_sio/new_id > /dev/null

but doing this every reboot is a pain in the ass.

Signed-off-by: Niek Nooijens <niek.nooijens@omron.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1045,6 +1045,8 @@ static const struct usb_device_id id_tab
 	/* IDS GmbH devices */
 	{ USB_DEVICE(IDS_VID, IDS_SI31A_PID) },
 	{ USB_DEVICE(IDS_VID, IDS_CM31A_PID) },
+	/* Omron devices */
+	{ USB_DEVICE(OMRON_VID, OMRON_CS1W_CIF31_PID) },
 	/* U-Blox devices */
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ZED_PID) },
 	{ USB_DEVICE(UBLOX_VID, UBLOX_C099F9P_ODIN_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -662,6 +662,12 @@
 #define INFINEON_TRIBOARD_TC2X7_PID	0x0043 /* DAS JTAG TriBoard TC2X7 V1.0 */
 
 /*
+ * Omron corporation (https://www.omron.com)
+ */
+ #define OMRON_VID			0x0590
+ #define OMRON_CS1W_CIF31_PID		0x00b2
+
+/*
  * Acton Research Corp.
  */
 #define ACTON_VID		0x0647	/* Vendor ID */


