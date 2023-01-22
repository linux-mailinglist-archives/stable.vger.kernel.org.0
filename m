Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DB9677001
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjAVP12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjAVP11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:27:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0112F23130
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:27:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930DD60C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A578CC433EF;
        Sun, 22 Jan 2023 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401246;
        bh=xNYfhrYs0eS8qK+MjXX0BdqR62ONKUMrbk5NefCMW6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cos8LloI5RhLGbkRrAeXyW92p/zQ4CH9cRfHOxQA1N52ClDuPE1G6YM4odnLJuZui
         Co3ievIw+c90I8vlmgbPvzjXx4MJa3YeGporpdeI2hqgoKblV0F2ygjCwb9qzbe98o
         +MUO17be6OgpKM4+UtdQzZ4LWcrXLjtlI25NPShw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthew Howell <matthew.howell@sealevel.com>,
        stable <stable@kernel.org>
Subject: [PATCH 6.1 127/193] serial: exar: Add support for Sealevel 7xxxC serial cards
Date:   Sun, 22 Jan 2023 16:04:16 +0100
Message-Id: <20230122150252.114970636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Howell <matthew.howell@sealevel.com>

commit 14ee78d5932afeb710c8305196a676a715bfdea8 upstream.

Add support for Sealevel 7xxxC serial cards.

This patch:
* Adds IDs to recognize 7xxxC cards from Sealevel Systems.
* Updates exar_pci_probe() to set nr_ports to last two bytes of primary
  dev ID for these cards.

Signed-off-by: Matthew Howell <matthew.howell@sealevel.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2301191440010.22558@tstest-VirtualBox
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_exar.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -43,6 +43,12 @@
 #define PCI_DEVICE_ID_EXAR_XR17V4358		0x4358
 #define PCI_DEVICE_ID_EXAR_XR17V8358		0x8358
 
+#define PCI_DEVICE_ID_SEALEVEL_710xC		0x1001
+#define PCI_DEVICE_ID_SEALEVEL_720xC		0x1002
+#define PCI_DEVICE_ID_SEALEVEL_740xC		0x1004
+#define PCI_DEVICE_ID_SEALEVEL_780xC		0x1008
+#define PCI_DEVICE_ID_SEALEVEL_716xC		0x1010
+
 #define UART_EXAR_INT0		0x80
 #define UART_EXAR_8XMODE	0x88	/* 8X sampling rate select */
 #define UART_EXAR_SLEEP		0x8b	/* Sleep mode */
@@ -638,6 +644,8 @@ exar_pci_probe(struct pci_dev *pcidev, c
 		nr_ports = BIT(((pcidev->device & 0x38) >> 3) - 1);
 	else if (board->num_ports)
 		nr_ports = board->num_ports;
+	else if (pcidev->vendor == PCI_VENDOR_ID_SEALEVEL)
+		nr_ports = pcidev->device & 0xff;
 	else
 		nr_ports = pcidev->device & 0x0f;
 
@@ -864,6 +872,12 @@ static const struct pci_device_id exar_p
 	EXAR_DEVICE(COMMTECH, 4224PCI335, pbn_fastcom335_4),
 	EXAR_DEVICE(COMMTECH, 2324PCI335, pbn_fastcom335_4),
 	EXAR_DEVICE(COMMTECH, 2328PCI335, pbn_fastcom335_8),
+
+	EXAR_DEVICE(SEALEVEL, 710xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 720xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 740xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 780xC, pbn_exar_XR17V35x),
+	EXAR_DEVICE(SEALEVEL, 716xC, pbn_exar_XR17V35x),
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, exar_pci_tbl);


