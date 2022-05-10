Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B598521744
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242706AbiEJNW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242923AbiEJNVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA192BFBF7;
        Tue, 10 May 2022 06:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67A61CE1EE2;
        Tue, 10 May 2022 13:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7ABC385A6;
        Tue, 10 May 2022 13:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188446;
        bh=F2Tpis4W/aZ5znDIKQR2Yf3i8XNfZG6H6GiAGMBmcWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQ2sc7ue5aAUbi0HZenkJ7crLt5ZBJ1An0maAFH4IXYw/oG0b2DhVCz2Ktz/Aox7J
         p+enQzdc0PMRKRHKprz/xGX3hyDpozWldoDCYLNuJwOWwD+Jqs/W4J2qcvwN5S24MT
         qmv1VSsueD8ldTIqAwpT/+KU8UasxGGyIStIhSFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 11/78] USB: serial: cp210x: add PIDs for Kamstrup USB Meter Reader
Date:   Tue, 10 May 2022 15:06:57 +0200
Message-Id: <20220510130732.868168863@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruno Thomsen <bruno.thomsen@gmail.com>

commit 35a923a0b329c343e9e81d79518e2937eba06fcd upstream.

Wireless reading of water and heat meters using 868 MHz wM-Bus mode C1.

The two different product IDs allow detection of dongle antenna
solution:
- Internal antenna
- External antenna using SMA connector

https://www.kamstrup.com/en-en/water-solutions/water-meter-reading/usb-meter-reader

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Link: https://lore.kernel.org/r/20220414081202.5591-1-bruno.thomsen@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -198,6 +198,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ USB_DEVICE(0x17A8, 0x0001) }, /* Kamstrup Optical Eye/3-wire */
 	{ USB_DEVICE(0x17A8, 0x0005) }, /* Kamstrup M-Bus Master MultiPort 250D */
+	{ USB_DEVICE(0x17A8, 0x0101) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Int Ant) */
+	{ USB_DEVICE(0x17A8, 0x0102) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Ext Ant) */
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */
 	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */


