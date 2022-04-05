Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374324F3A57
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244723AbiDELoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354573AbiDEKOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044E56BDC2;
        Tue,  5 Apr 2022 03:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9460961676;
        Tue,  5 Apr 2022 10:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F159C385A1;
        Tue,  5 Apr 2022 10:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152872;
        bh=mofzU+Ioylql3jwYOzUHQ6X/mwJ6eaP22Z7z4ZDyVcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AhEkmqC9y0wvksfX+j6RsmuiDrmAdBJ5+5+9+VW1VYnWWgR/DBYhIUGJaXvzw35Y
         zehDdKAyE8rCeVJPTwfb/F6vHadtkJEZ/fgJZo7FaQfXDjXyllq+cFG7O+AfEQLono
         w3FXpChg8XzPWTdvlr2neU/z1QhYm/mUOMRUyisM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 002/599] USB: serial: pl2303: add IBM device IDs
Date:   Tue,  5 Apr 2022 09:24:56 +0200
Message-Id: <20220405070258.882801139@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Eddie James <eajames@linux.ibm.com>

commit e1d15646565b284e9ef2433234d6cfdaf66695f1 upstream.

IBM manufactures a PL2303 device for UPS communications. Add the vendor
and product IDs so that the PL2303 driver binds to the device.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20220301224446.21236-1-eajames@linux.ibm.com
Cc: stable@vger.kernel.org
[ johan: amend the SoB chain ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -116,6 +116,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530GC_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -35,6 +35,9 @@
 #define ATEN_PRODUCT_UC232B	0x2022
 #define ATEN_PRODUCT_ID2	0x2118
 
+#define IBM_VENDOR_ID		0x04b3
+#define IBM_PRODUCT_ID		0x4016
+
 #define IODATA_VENDOR_ID	0x04bb
 #define IODATA_PRODUCT_ID	0x0a03
 #define IODATA_PRODUCT_ID_RSAQ5	0x0a0e


