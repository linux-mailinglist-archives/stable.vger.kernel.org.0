Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6B4B4C28
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243652AbiBNKhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350261AbiBNKhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:37:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C249DA66F7;
        Mon, 14 Feb 2022 02:03:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33265B80DC8;
        Mon, 14 Feb 2022 10:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0DFC340F0;
        Mon, 14 Feb 2022 10:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833008;
        bh=6e54lmGimgKn631egJa57mEvUiKAcn1kkE1kiEEqHbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQJTsUj9reYBILzgcvAEagdOSvmCgc28cSXAkrqPRvmAoNakKmkMD5N9bvIrWPo6p
         VxZUEuNG90yCzUC5A5VhPKF8keBIGC6UjekAsx3dhQULKJEydT/v1wN21f92ZjwLn8
         OsLEXea5/NzcCLaEQ6D40ocgo8Q03v5xzwmi+47Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Williams <cang1@live.co.uk>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.16 177/203] USB: serial: ftdi_sio: add support for Brainboxes US-159/235/320
Date:   Mon, 14 Feb 2022 10:27:01 +0100
Message-Id: <20220214092516.262397216@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Williams <cang1@live.co.uk>

commit fbb9b194e15a63c56c5664e76ccd0e85c6100cea upstream.

This patch adds support for the Brainboxes US-159, US-235 and US-320
USB-to-Serial devices.

Signed-off-by: Cameron Williams <cang1@live.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    3 +++
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -969,6 +969,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_023_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_034_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_101_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_159_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_3_PID) },
@@ -977,12 +978,14 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_6_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_7_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_8_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_235_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_257_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_4_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_313_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_320_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_324_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_346_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_346_2_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1506,6 +1506,9 @@
 #define BRAINBOXES_VX_023_PID		0x1003 /* VX-023 ExpressCard 1 Port RS422/485 */
 #define BRAINBOXES_VX_034_PID		0x1004 /* VX-034 ExpressCard 2 Port RS422/485 */
 #define BRAINBOXES_US_101_PID		0x1011 /* US-101 1xRS232 */
+#define BRAINBOXES_US_159_PID		0x1021 /* US-159 1xRS232 */
+#define BRAINBOXES_US_235_PID		0x1017 /* US-235 1xRS232 */
+#define BRAINBOXES_US_320_PID		0x1019 /* US-320 1xRS422/485 */
 #define BRAINBOXES_US_324_PID		0x1013 /* US-324 1xRS422/485 1Mbaud */
 #define BRAINBOXES_US_606_1_PID		0x2001 /* US-606 6 Port RS232 Serial Port 1 and 2 */
 #define BRAINBOXES_US_606_2_PID		0x2002 /* US-606 6 Port RS232 Serial Port 3 and 4 */


