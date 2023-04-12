Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10386DEE1A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjDLIkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjDLIjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623246EB7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E092F62FF6
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02171C4339B;
        Wed, 12 Apr 2023 08:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288566;
        bh=RQjrIMy2/c/IM8r/8+NKjizSql/Zf3JUTVgIydCla1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdErwHGf19hU8KNuYgJ41VoLyzNwUmWfqJl06Tr4ZntDRy3ZWXaBg9DWLuWjJoTOO
         3uJSeOaaU32jrRzIsmmqvzjNHVmvbJ4xqL1NQkJxTt7lrvS4uDJ/uh3YtqVL0kszcR
         AyXyIuZE4C0Hd3sFuILy/Mxt8juEEIb51d3Di4aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthew Howell <matthew.howell@sealevel.com>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/93] serial: exar: Add support for Sealevel 7xxxC serial cards
Date:   Wed, 12 Apr 2023 10:33:20 +0200
Message-Id: <20230412082823.865230501@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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

From: Matthew Howell <matthew.howell@sealevel.com>

[ Upstream commit 14ee78d5932afeb710c8305196a676a715bfdea8 ]

Add support for Sealevel 7xxxC serial cards.

This patch:
* Adds IDs to recognize 7xxxC cards from Sealevel Systems.
* Updates exar_pci_probe() to set nr_ports to last two bytes of primary
  dev ID for these cards.

Signed-off-by: Matthew Howell <matthew.howell@sealevel.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2301191440010.22558@tstest-VirtualBox
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 7292917ac8784..c767636d9bb0f 100644
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
@@ -627,6 +633,8 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 		nr_ports = BIT(((pcidev->device & 0x38) >> 3) - 1);
 	else if (board->num_ports)
 		nr_ports = board->num_ports;
+	else if (pcidev->vendor == PCI_VENDOR_ID_SEALEVEL)
+		nr_ports = pcidev->device & 0xff;
 	else
 		nr_ports = pcidev->device & 0x0f;
 
@@ -853,6 +861,12 @@ static const struct pci_device_id exar_pci_tbl[] = {
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
-- 
2.39.2



