Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C544C2CFF
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiBXNcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 08:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbiBXNca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 08:32:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9EB3BBC4;
        Thu, 24 Feb 2022 05:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51907B825CD;
        Thu, 24 Feb 2022 13:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08064C340EC;
        Thu, 24 Feb 2022 13:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645709509;
        bh=aDgHwHLlaNIdtT43THiW9lzUoMz27o+RJiZVrVu89lA=;
        h=From:To:Cc:Subject:Date:From;
        b=Omn8gcOAjIRuISt5tat3NXRjzlGmWi7T2wUJ14F8/pN7QWw+zUUOYj1skVjaw7sGg
         F5CdZJinP5eRORKVojyF01K9Xsb+pNhv1M9lXETcLn/Qg0RGtnAlba8GyLeinovXpW
         kxlThjKdBDmOEG8ldZCOabHP0jfQnKBN3VP5bFxPclMovzoltwpPqgQEFnayjr6VWn
         N8wPH6mnLWjfNf5Zeg4FCSgzXYld6G45soYxWCJzxcWjPE9Wv3W0p5RGFM0SffTFHc
         fby1miGrzcV8vipUL4ujRbiW5+7YBykSFFQEGX0NzzNRfUm3B7a3vc2D3hBzZdF99x
         s6nNQXxO/5kuQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nNEDk-0003j0-Iy; Thu, 24 Feb 2022 14:31:49 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Becker <linux.felixbecker2@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: simple: add Nokia phone driver
Date:   Thu, 24 Feb 2022 14:31:09 +0100
Message-Id: <20220224133109.10523-1-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
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

Add a new "simple" driver for certain Nokia phones, including Nokia 130
(RM-1035) which exposes two serial ports in "charging only" mode.

Reported-by: Felix Becker <linux.felixbecker2@gmx.de>
Link: https://lore.kernel.org/r/20220208201506.6c65834d@gmx.de
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/Kconfig             | 1 +
 drivers/usb/serial/usb-serial-simple.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index de5c01257060..ef8d1c73c754 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -66,6 +66,7 @@ config USB_SERIAL_SIMPLE
 		- Libtransistor USB console
 		- a number of Motorola phones
 		- Motorola Tetra devices
+		- Nokia mobile phones
 		- Novatel Wireless GPS receivers
 		- Siemens USB/MPI adapter.
 		- ViVOtech ViVOpay USB device.
diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
index bd23a7cb1be2..c95dfe4a6f0f 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -91,6 +91,11 @@ DEVICE(moto_modem, MOTO_IDS);
 	{ USB_DEVICE(0x0cad, 0x9016) }	/* TPG2200 */
 DEVICE(motorola_tetra, MOTOROLA_TETRA_IDS);
 
+/* Nokia mobile phone driver */
+#define NOKIA_IDS()			\
+	{ USB_DEVICE(0x0421, 0x069a) }	/* Nokia 130 (RM-1035) */
+DEVICE_N(nokia, NOKIA_IDS, 2);
+
 /* Novatel Wireless GPS driver */
 #define NOVATEL_IDS()			\
 	{ USB_DEVICE(0x09d7, 0x0100) }	/* NovAtel FlexPack GPS */
@@ -123,6 +128,7 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&vivopay_device,
 	&moto_modem_device,
 	&motorola_tetra_device,
+	&nokia_device,
 	&novatel_gps_device,
 	&hp4x_device,
 	&suunto_device,
@@ -140,6 +146,7 @@ static const struct usb_device_id id_table[] = {
 	VIVOPAY_IDS(),
 	MOTO_IDS(),
 	MOTOROLA_TETRA_IDS(),
+	NOKIA_IDS(),
 	NOVATEL_IDS(),
 	HP4X_IDS(),
 	SUUNTO_IDS(),
-- 
2.34.1

