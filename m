Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D98D6DEF58
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjDLItl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjDLIth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519AD8A49
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71F2463150
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F34AC433D2;
        Wed, 12 Apr 2023 08:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289357;
        bh=kURrNZFOCRixyhpGhOj84iCQKJo1uVLAaTX/SGnFgTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzl/AURY9SkK9H9+FIArqKEtVS5eca5zYcjVJErXNd/Jryu49NWKa7T1GQbY4nMjB
         jqcn7rcAIMLy4J4wYTzYtcssqw51iNSSa2g8tS3u2BErQNR4f/hFQyQI5pFI3WXMfE
         pmLZ9FSMZCwfOmCrkAbApPHvRGbyDLfFE1f/g7ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Enrico Sau <enrico.sau@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.2 069/173] USB: serial: option: add Telit FE990 compositions
Date:   Wed, 12 Apr 2023 10:33:15 +0200
Message-Id: <20230412082840.856461194@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enrico Sau <enrico.sau@gmail.com>

commit 773e8e7d07b753474b2ccd605ff092faaa9e65b9 upstream.

Add the following Telit FE990 compositions:

0x1080: tty, adb, rmnet, tty, tty, tty, tty
0x1081: tty, adb, mbim, tty, tty, tty, tty
0x1082: rndis, tty, adb, tty, tty, tty, tty
0x1083: tty, adb, ecm, tty, tty, tty, tty

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
Link: https://lore.kernel.org/r/20230314090059.77876-1-enrico.sau@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1300,6 +1300,14 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990 (PCIe) */
 	  .driver_info = RSVD(0) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1080, 0xff),	/* Telit FE990 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1081, 0xff),	/* Telit FE990 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1082, 0xff),	/* Telit FE990 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1083, 0xff),	/* Telit FE990 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),


