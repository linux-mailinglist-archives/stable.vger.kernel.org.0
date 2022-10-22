Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4FC6086E4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiJVHzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiJVHxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:53:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB0E66F0D;
        Sat, 22 Oct 2022 00:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93EF2B82DF1;
        Sat, 22 Oct 2022 07:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0279CC433D6;
        Sat, 22 Oct 2022 07:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424275;
        bh=4utioZOXlyo9oAiwlzw67riLL6LaXsoNJjJMJzcvKEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vahydwHKt+tKAaC1cVTTHKhc9h6xfbq9Ib9EMYCfi2AwGYKTzxGkao8VQpLi44EtN
         aAtC+/bOwAeWjh68EZdNcUMH/9ulRDe/8VM5zjDhFsudyIoibAh+gslpV4tcaCvSZD
         fb0xthaUELhYFstUQ8AMt28B5yh4wBG7Aney6ddk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.19 085/717] serial: 8250: Request full 16550A feature probing for OxSemi PCIe devices
Date:   Sat, 22 Oct 2022 09:19:24 +0200
Message-Id: <20221022072430.414870964@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 00b7a4d4ee42be1c515e56cb1e8ba0f25e271d8e upstream.

Oxford Semiconductor PCIe (Tornado) 950 serial port devices need to
operate in the enhanced mode via the EFR register for the Divide-by-M
N/8 baud rate generator prescaler to be used in their native UART mode.
Otherwise the prescaler is fixed at 1 causing grossly incorrect baud
rates to be programmed.

Accessing the EFR register requires 16550A features to have been probed
for, so request this to happen regardless of SERIAL_8250_16550A_VARIANTS
by setting UPF_FULL_PROBE in port flags.

Fixes: 366f6c955d4d ("serial: 8250: Add proper clock handling for OxSemi PCIe devices")
Cc: stable@vger.kernel.org # v5.19+
Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2209210005040.41633@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1232,6 +1232,10 @@ static void pci_oxsemi_tornado_set_mctrl
 	serial8250_do_set_mctrl(port, mctrl);
 }
 
+/*
+ * We require EFR features for clock programming, so set UPF_FULL_PROBE
+ * for full probing regardless of CONFIG_SERIAL_8250_16550A_VARIANTS setting.
+ */
 static int pci_oxsemi_tornado_setup(struct serial_private *priv,
 				    const struct pciserial_board *board,
 				    struct uart_8250_port *up, int idx)
@@ -1239,6 +1243,7 @@ static int pci_oxsemi_tornado_setup(stru
 	struct pci_dev *dev = priv->dev;
 
 	if (pci_oxsemi_tornado_p(dev)) {
+		up->port.flags |= UPF_FULL_PROBE;
 		up->port.get_divisor = pci_oxsemi_tornado_get_divisor;
 		up->port.set_divisor = pci_oxsemi_tornado_set_divisor;
 		up->port.set_mctrl = pci_oxsemi_tornado_set_mctrl;


