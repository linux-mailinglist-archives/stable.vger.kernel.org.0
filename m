Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC60593D38
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345068AbiHOTxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345165AbiHOTwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:52:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42260500;
        Mon, 15 Aug 2022 11:50:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB884CE1277;
        Mon, 15 Aug 2022 18:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8521C433D6;
        Mon, 15 Aug 2022 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589437;
        bh=VjXw7mw98BXRNt1NRsj+eecy9hUP/8ZjEFUqTCTCbWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJKUpiUuG9ePB6KCOoR4IJ7kp7T+qd0X+ZIwD0pstpZt8s5HnUnsJvbqKrUlKI7N3
         sXPSV2HKWHOa1JeQ99/utnJQpr8TngcR4TebB2cLn1sOAOmrc2Db6baKk1T30SgWFL
         fcNWHgHTksjNB4IQ5sp9hN+dVNCDUy0HnpGYAbes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Williams <cang1@live.co.uk>,
        stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 717/779] tty: 8250: Add support for Brainboxes PX cards.
Date:   Mon, 15 Aug 2022 20:06:01 +0200
Message-Id: <20220815180408.097183815@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cameron Williams <cang1@live.co.uk>

[ Upstream commit ef5a03a26c87a760bc3d86b5af7b773e82f8b1b7 ]

Add support for some of the Brainboxes PCIe (PX) range of
serial cards, including the PX-101, PX-235/PX-246,
PX-203/PX-257, PX-260/PX-701, PX-310, PX-313,
PX-320/PX-324/PX-376/PX-387, PX-335/PX-346, PX-368, PX-420,
PX-803 and PX-846.

Signed-off-by: Cameron Williams <cang1@live.co.uk>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/AM5PR0202MB2564669252BDC59BF55A6E87C4879@AM5PR0202MB2564.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 109 +++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 1860fc969433..a16743856fc7 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -5475,6 +5475,115 @@ static const struct pci_device_id serial_pci_tbl[] = {
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0,
 		pbn_b2_4_115200 },
+	/*
+	 * Brainboxes PX-101
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4005,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b0_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4019,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_2_15625000 },
+	/*
+	 * Brainboxes PX-235/246
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4004,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b0_1_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4016,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_1_15625000 },
+	/*
+	 * Brainboxes PX-203/PX-257
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4006,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b0_2_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4015,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_4_15625000 },
+	/*
+	 * Brainboxes PX-260/PX-701
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x400A,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_4_15625000 },
+	/*
+	 * Brainboxes PX-310
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x400E,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_2_15625000 },
+	/*
+	 * Brainboxes PX-313
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x400C,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_2_15625000 },
+	/*
+	 * Brainboxes PX-320/324/PX-376/PX-387
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x400B,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_1_15625000 },
+	/*
+	 * Brainboxes PX-335/346
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x400F,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_4_15625000 },
+	/*
+	 * Brainboxes PX-368
+	 */
+	{       PCI_VENDOR_ID_INTASHIELD, 0x4010,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_4_15625000 },
+	/*
+	 * Brainboxes PX-420
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4000,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b0_4_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4011,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_4_15625000 },
+	/*
+	 * Brainboxes PX-803
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4009,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b0_1_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x401E,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_1_15625000 },
+	/*
+	 * Brainboxes PX-846
+	 */
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4008,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_b0_1_115200 },
+	{	PCI_VENDOR_ID_INTASHIELD, 0x4017,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0,
+		pbn_oxsemi_1_15625000 },
+
 	/*
 	 * Perle PCI-RAS cards
 	 */
-- 
2.35.1



