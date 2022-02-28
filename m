Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40FF4C7341
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbiB1ReS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbiB1RdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:33:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5158C8E1B1;
        Mon, 28 Feb 2022 09:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB0C361359;
        Mon, 28 Feb 2022 17:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DA6C340E7;
        Mon, 28 Feb 2022 17:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069367;
        bh=TG+mq0mWCM/MrB0JN5FlEuzzUbsrlAfNgtd+H9v3LVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/vp1nGBM1U1bHcQZuYYcAs2KZ0AZvYOYINfNJezisZ6T9MOhi/qhy7rA5xQ9V8GQ
         H4w+Pbd/Jq7jGVIMPklQg3TmlWhMHTgZ0CFwDl+7WlNmkRTQ24VRdAUihhT69soVhG
         /ZioyUaJIujd0VzKz2lcKaeZViyaFp+d1I5t96ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 29/34] USB: serial: option: add Telit LE910R1 compositions
Date:   Mon, 28 Feb 2022 18:24:35 +0100
Message-Id: <20220228172210.803095098@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

commit cfc4442c642d568014474b6718ccf65dc7ca6099 upstream.

Add support for the following Telit LE910R1 compositions:

0x701a: rndis, tty, tty, tty
0x701b: ecm, tty, tty, tty
0x9201: tty

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Link: https://lore.kernel.org/r/20220218134552.4051-1-dnlplm@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1279,10 +1279,16 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x7011, 0xff),	/* Telit LE910-S1 (ECM) */
 	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x701a, 0xff),	/* Telit LE910R1 (RNDIS) */
+	  .driver_info = NCTRL(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x701b, 0xff),	/* Telit LE910R1 (ECM) */
+	  .driver_info = NCTRL(2) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9010),				/* Telit SBL FN980 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9200),				/* Telit LE910S1 flashing device */
 	  .driver_info = NCTRL(0) | ZLP },
+	{ USB_DEVICE(TELIT_VENDOR_ID, 0x9201),				/* Telit LE910R1 flashing device */
+	  .driver_info = NCTRL(0) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },


