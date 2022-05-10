Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CD352169A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242406AbiEJNQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242468AbiEJNQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:16:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B564A916;
        Tue, 10 May 2022 06:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79FB5615FC;
        Tue, 10 May 2022 13:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC22C385C6;
        Tue, 10 May 2022 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188305;
        bh=KrmrHxN/MRgGZte1TsTRlM3hbo4IwWi9CTaTAqB81dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MV6nTm+4OIdAeIH6fTVn3IcDlr7uNieJsX6RgRA2Nz89hqP/i8tfLCemMv6+MXJUl
         A0fQtwAgzBc8VhnLUVxLiA6SlxUpEPWeommKjPMs7VUNarxesqpxUDsnDXxsu1MGiN
         UvMKhTw1UliAzGVY67BWyYpK94EhaFUMDtrIBY/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 09/66] USB: serial: option: add Telit 0x1057, 0x1058, 0x1075 compositions
Date:   Tue, 10 May 2022 15:06:59 +0200
Message-Id: <20220510130730.042978438@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit f32c5a0423400e01f4d7c607949fa3a1f006e8fa upstream.

Add support for the following Telit FN980 and FN990 compositions:

0x1057: tty, adb, rmnet, tty, tty, tty, tty, tty
0x1058: tty, adb, tty, tty, tty, tty, tty
0x1075: adb, tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20220406141408.580669-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1195,6 +1195,10 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1056, 0xff),	/* Telit FD980 */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1057, 0xff),	/* Telit FN980 */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1058, 0xff),	/* Telit FN980 (PCIe) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1060, 0xff),	/* Telit LN920 (rmnet) */
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1061, 0xff),	/* Telit LN920 (MBIM) */
@@ -1211,6 +1215,8 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1073, 0xff),	/* Telit FN990 (ECM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990 (PCIe) */
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


