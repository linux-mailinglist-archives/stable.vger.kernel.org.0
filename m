Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012944A6369
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiBASRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56296 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbiBASRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DD8C61418;
        Tue,  1 Feb 2022 18:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E72AC340EC;
        Tue,  1 Feb 2022 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739420;
        bh=L8zZDxhrh4UHMsvji51RGgp50rdq0IiMFZy+Kf18rns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkvhYE/s+fMk4kqW0FRdmi4jJoT/rkAucoCwPcOXwnrBr7kVc2gyVXuFipkyWSseS
         u2Kk83fOyWjvXmL0ORB8xw7nnHTW/UrPsBSy+zS9Iex29lgLPIzCP7n242BQ5MfB6l
         oJp/WBPXkKESn2lAPeKXjX7TQ8rIqqCFPcv9MTuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Williams <cang1@live.co.uk>
Subject: [PATCH 4.4 10/25] tty: Add support for Brainboxes UC cards.
Date:   Tue,  1 Feb 2022 19:16:34 +0100
Message-Id: <20220201180822.487981953@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Williams <cang1@live.co.uk>

commit 152d1afa834c84530828ee031cf07a00e0fc0b8c upstream.

This commit adds support for the some of the Brainboxes PCI range of
cards, including the UC-101, UC-235/246, UC-257, UC-268, UC-275/279,
UC-302, UC-310, UC-313, UC-320/324, UC-346, UC-357, UC-368
and UC-420/431.

Signed-off-by: Cameron Williams <cang1@live.co.uk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/AM5PR0202MB2564688493F7DD9B9C610827C45E9@AM5PR0202MB2564.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |  100 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5404,8 +5404,30 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_INTASHIELD, PCI_DEVICE_ID_INTASHIELD_IS400,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,    /* 135a.0dc0 */
 		pbn_b2_4_115200 },
+	/* Brainboxes Devices */
 	/*
-	 * BrainBoxes UC-260
+	* Brainboxes UC-101
+	*/
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0BA1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-235/246
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0AA1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_1_115200 },
+	/*
+	 * Brainboxes UC-257
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0861,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-260/271/701/756
 	 */
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0D21,
 		PCI_ANY_ID, PCI_ANY_ID,
@@ -5413,7 +5435,81 @@ static struct pci_device_id serial_pci_t
 		pbn_b2_4_115200 },
 	{	PCI_VENDOR_ID_INTASHIELD, 0x0E34,
 		PCI_ANY_ID, PCI_ANY_ID,
-		 PCI_CLASS_COMMUNICATION_MULTISERIAL << 8, 0xffff00,
+		PCI_CLASS_COMMUNICATION_MULTISERIAL << 8, 0xffff00,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-268
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0841,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-275/279
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0881,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_8_115200 },
+	/*
+	 * Brainboxes UC-302
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x08E1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-310
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08C1,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-313
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x08A3,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-320/324
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A61,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_1_115200 },
+	/*
+	 * Brainboxes UC-346
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0B02,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-357
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A81,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0A83,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_2_115200 },
+	/*
+	 * Brainboxes UC-368
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x0C41,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes UC-420/431
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x0921,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
 		pbn_b2_4_115200 },
 	/*
 	 * Perle PCI-RAS cards


