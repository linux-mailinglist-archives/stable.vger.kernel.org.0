Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB7551E99
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245019AbiFTOAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352174AbiFTN4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31703586B;
        Mon, 20 Jun 2022 06:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D11260FF1;
        Mon, 20 Jun 2022 13:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9471CC3411B;
        Mon, 20 Jun 2022 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731327;
        bh=+5shk+eauZhl+KC0dXVhipM9m38Ll0zkCxApQYigSeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDGFCmj4ZmWOD6h00u6eClE6D1SSFL+5tRtCIFfzu3nNNruS78gjnidIIxSNwCoeH
         u53wovqE+RJiqKvZhVPtlFqRHRzjBxypOec6czQXhsetCiNLQMqHlPQYGiXauzIRJx
         GldidxQwLxgZdI+hxWCPUYVt4zom+/s7qkR5PcgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Eckelmann <longnoserob@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 223/240] USB: serial: io_ti: add Agilent E5805A support
Date:   Mon, 20 Jun 2022 14:52:04 +0200
Message-Id: <20220620124745.426185819@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Eckelmann <longnoserob@gmail.com>

commit 908e698f2149c3d6a67d9ae15c75545a3f392559 upstream.

Add support for Agilent E5805A (rebranded ION Edgeport/4) to io_ti.

Signed-off-by: Robert Eckelmann <longnoserob@gmail.com>
Link: https://lore.kernel.org/r/20220521230808.30931eca@octoberrain
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_ti.c      |    2 ++
 drivers/usb/serial/io_usbvend.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -168,6 +168,7 @@ static const struct usb_device_id edgepo
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_8S) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416B) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_E5805A) },
 	{ }
 };
 
@@ -206,6 +207,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_8S) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416) },
 	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_TI_EDGEPORT_416B) },
+	{ USB_DEVICE(USB_VENDOR_ID_ION, ION_DEVICE_ID_E5805A) },
 	{ }
 };
 
--- a/drivers/usb/serial/io_usbvend.h
+++ b/drivers/usb/serial/io_usbvend.h
@@ -212,6 +212,7 @@
 //
 // Definitions for other product IDs
 #define ION_DEVICE_ID_MT4X56USB			0x1403	// OEM device
+#define ION_DEVICE_ID_E5805A			0x1A01  // OEM device (rebranded Edgeport/4)
 
 
 #define	GENERATION_ID_FROM_USB_PRODUCT_ID(ProductId)				\


