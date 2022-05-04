Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9951A750
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354763AbiEDRC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354645AbiEDQ65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F842E9E3;
        Wed,  4 May 2022 09:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6333D61851;
        Wed,  4 May 2022 16:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7306C385BA;
        Wed,  4 May 2022 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683049;
        bh=/fDkFj3pEhoeI1sFT3M8MLiYrpip6OpAH/05OyCgCrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVoSQH3YE9ihCal7+3pi0k6dJDRvxds3L6jSgcYKDNullVrAploFoCwvgKn2K2MbE
         zRhxaoc+22qLFO+nnftqeLKDANv+8rUPeAQJ+4XTWoSPOlP55tXLw3zCakN6aqFIjO
         D7W+/MOLe6RLpQzrWhrbFZFRORdUPHYbDvJzX28c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        stable <stable@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.10 030/129] serial: 8250: Correct the clock for EndRun PTP/1588 PCIe device
Date:   Wed,  4 May 2022 18:43:42 +0200
Message-Id: <20220504153023.711036240@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 637674fa40059cddcc3ad2212728965072f62ea3 upstream.

The EndRun PTP/1588 dual serial port device is based on the Oxford
Semiconductor OXPCIe952 UART device with the PCI vendor:device ID set
for EndRun Technologies and is therefore driven by a fixed 62.5MHz clock
input derived from the 100MHz PCI Express clock.  The clock rate is
divided by the oversampling rate of 16 as it is supplied to the baud
rate generator, yielding the baud base of 3906250.

Replace the incorrect baud base of 4000000 with the right value of
3906250 then, complementing commit 6cbe45d8ac93 ("serial: 8250: Correct
the clock for OxSemi PCIe devices").

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable <stable@kernel.org>
Fixes: 1bc8cde46a159 ("8250_pci: Added driver for Endrun Technologies PTP PCIe card.")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2204181515270.9383@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -2940,7 +2940,7 @@ enum pci_board_num_t {
 	pbn_panacom2,
 	pbn_panacom4,
 	pbn_plx_romulus,
-	pbn_endrun_2_4000000,
+	pbn_endrun_2_3906250,
 	pbn_oxsemi,
 	pbn_oxsemi_1_4000000,
 	pbn_oxsemi_2_4000000,
@@ -3468,10 +3468,10 @@ static struct pciserial_board pci_boards
 	* signal now many ports are available
 	* 2 port 952 Uart support
 	*/
-	[pbn_endrun_2_4000000] = {
+	[pbn_endrun_2_3906250] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 2,
-		.base_baud	= 4000000,
+		.base_baud	= 3906250,
 		.uart_offset	= 0x200,
 		.first_offset	= 0x1000,
 	},
@@ -4386,7 +4386,7 @@ static const struct pci_device_id serial
 	*/
 	{	PCI_VENDOR_ID_ENDRUN, PCI_DEVICE_ID_ENDRUN_1588,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		pbn_endrun_2_4000000 },
+		pbn_endrun_2_3906250 },
 	/*
 	 * Quatech cards. These actually have configurable clocks but for
 	 * now we just use the default.


