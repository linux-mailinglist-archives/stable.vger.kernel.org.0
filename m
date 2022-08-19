Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B180A59A352
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353640AbiHSQmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354049AbiHSQlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:41:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4CC128466;
        Fri, 19 Aug 2022 09:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58788B82827;
        Fri, 19 Aug 2022 16:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E89BC433D6;
        Fri, 19 Aug 2022 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925409;
        bh=A1nAUVK//jHkR0gzE1aib0tNp0duQAedJXxIK8FXNBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDL6WDPa0nE3sNh+s6xc33qsHSMil3MJkYqazzll4YpO6C4r6gTWqgXHq5dLhF22U
         UojQ2j5iTqDcBkTMRbsTv+j425XhqjspN/gzdNmJkard6uRlYmy9lY+sex6M2+RIsX
         Ci4CW1hnYh13giavyNbLWovIelC9v8qUUioopNd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/545] serial: 8250: Dissociate 4MHz Titan ports from Oxford ports
Date:   Fri, 19 Aug 2022 17:44:13 +0200
Message-Id: <20220819153851.050831570@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit f771a34b141124a68265f91acae34cdb08aeb9e0 ]

Oxford Semiconductor PCIe (Tornado) serial port devices have their baud
base set incorrectly, however their `pciserial_board' entries have been
reused for Titan serial port devices.  Define own entries for the latter
devices then, carrying over the settings, so that Oxford entries can be
fixed.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2106100142310.5469@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 44 ++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index da2373787f85..c309a8a31621 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2983,6 +2983,10 @@ enum pci_board_num_t {
 	pbn_sunix_pci_4s,
 	pbn_sunix_pci_8s,
 	pbn_sunix_pci_16s,
+	pbn_titan_1_4000000,
+	pbn_titan_2_4000000,
+	pbn_titan_4_4000000,
+	pbn_titan_8_4000000,
 	pbn_moxa8250_2p,
 	pbn_moxa8250_4p,
 	pbn_moxa8250_8p,
@@ -3770,6 +3774,34 @@ static struct pciserial_board pci_boards[] = {
 		.base_baud      = 921600,
 		.uart_offset	= 0x8,
 	},
+	[pbn_titan_1_4000000] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 4000000,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_titan_2_4000000] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 2,
+		.base_baud	= 4000000,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_titan_4_4000000] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 4,
+		.base_baud	= 4000000,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_titan_8_4000000] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 4000000,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
 	[pbn_moxa8250_2p] = {
 		.flags		= FL_BASE1,
 		.num_ports      = 2,
@@ -4721,22 +4753,22 @@ static const struct pci_device_id serial_pci_tbl[] = {
 		pbn_b0_4_921600 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_100E,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_1_4000000 },
+		pbn_titan_1_4000000 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200E,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_2_4000000 },
+		pbn_titan_2_4000000 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_400E,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_4_4000000 },
+		pbn_titan_4_4000000 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_800E,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_8_4000000 },
+		pbn_titan_8_4000000 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200EI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_2_4000000 },
+		pbn_titan_2_4000000 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200EISI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_oxsemi_2_4000000 },
+		pbn_titan_2_4000000 },
 	{	PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_200V3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_2_921600 },
-- 
2.35.1



