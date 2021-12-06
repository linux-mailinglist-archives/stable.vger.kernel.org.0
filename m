Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE71469D1E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350765AbhLFP2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54540 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358683AbhLFPXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:23:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 251E8B81118;
        Mon,  6 Dec 2021 15:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B76DC341C1;
        Mon,  6 Dec 2021 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803999;
        bh=/WahLXFqrjQsDvFShH1lEVqasEOBgc9nuB1dpvbRTcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akMMjHMWRtGpklAqWf+RHk4GTOFGE9hxkovb5Fn8KidLCbqLC3oLJqWvhaMd9ce40
         XMtbEGnsWBbbVDT1RboPMqjVDvkNgiFSb8FbjPxER7u4Rl25Q5VYPFkdinSeEzdPS0
         lEcEBY9baPXvj8kjW5tU3rRPcGdSQ93tC1yW0inI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Gondois <Pierre.Gondois@arm.com>
Subject: [PATCH 5.10 121/130] serial: pl011: Add ACPI SBSA UART match id
Date:   Mon,  6 Dec 2021 15:57:18 +0100
Message-Id: <20211206145603.833367305@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre Gondois <Pierre.Gondois@arm.com>

commit ac442a077acf9a6bf1db4320ec0c3f303be092b3 upstream.

The document 'ACPI for Arm Components 1.0' defines the following
_HID mappings:
-'Prime cell UART (PL011)': ARMH0011
-'SBSA UART': ARMHB000

Use the sbsa-uart driver when a device is described with
the 'ARMHB000' _HID.

Note:
PL011 devices currently use the sbsa-uart driver instead of the
uart-pl011 driver. Indeed, PL011 devices are not bound to a clock
in ACPI. It is not possible to change their baudrate.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pierre Gondois <Pierre.Gondois@arm.com>
Link: https://lore.kernel.org/r/20211109172248.19061-1-Pierre.Gondois@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2791,6 +2791,7 @@ MODULE_DEVICE_TABLE(of, sbsa_uart_of_mat
 
 static const struct acpi_device_id sbsa_uart_acpi_match[] = {
 	{ "ARMH0011", 0 },
+	{ "ARMHB000", 0 },
 	{},
 };
 MODULE_DEVICE_TABLE(acpi, sbsa_uart_acpi_match);


