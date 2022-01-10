Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E432148917A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240787AbiAJHcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:32:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38028 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240010AbiAJHaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:30:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBF71611E0;
        Mon, 10 Jan 2022 07:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AD0C36AED;
        Mon, 10 Jan 2022 07:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799828;
        bh=1PC9Oavmy3rDsCgNb2kVCXK643NTyi/TUNXya1Ck5Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDWgWAq5nEONvnqZnBT8nImY224Zwa5ERje7KakYtPgnlHpx0LYX3cuOCEjmaukfv
         tfAjPp5YPVYhKGcsqpekmP+8p2uy+Li11qoxnTSEzHBcg/6KW2Dh0QG2HY1QIleH79
         ZBt0dGjO7oZZWt10bBxHBIp4QZq+pPebucMsQ4pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Toye <thomas@toye.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 29/43] rndis_host: support Hytera digital radios
Date:   Mon, 10 Jan 2022 08:23:26 +0100
Message-Id: <20220110071818.325434123@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Toye <thomas@toye.io>

commit 29262e1f773b4b6a43711120be564c57fca07cfb upstream.

Hytera makes a range of digital (DMR) radios. These radios can be
programmed to a allow a computer to control them over Ethernet over USB,
either using NCM or RNDIS.

This commit adds support for RNDIS for Hytera radios. I tested with a
Hytera PD785 and a Hytera MD785G. When these radios are programmed to
set up a Radio to PC Network using RNDIS, an USB interface will be added
with class 2 (Communications), subclass 2 (Abstract Modem Control) and
an interface protocol of 255 ("vendor specific" - lsusb even hints "MSFT
RNDIS?").

This patch is similar to the solution of this StackOverflow user, but
that only works for the Hytera MD785:
https://stackoverflow.com/a/53550858

To use the "Radio to PC Network" functionality of Hytera DMR radios, the
radios need to be programmed correctly in CPS (Hytera's Customer
Programming Software). "Forward to PC" should be checked in "Network"
(under "General Setting" in "Conventional") and the "USB Network
Communication Protocol" should be set to RNDIS.

Signed-off-by: Thomas Toye <thomas@toye.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/rndis_host.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -609,6 +609,11 @@ static const struct usb_device_id	produc
 				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
 	.driver_info = (unsigned long) &rndis_poll_status_info,
 }, {
+	/* Hytera Communications DMR radios' "Radio to PC Network" */
+	USB_VENDOR_AND_INTERFACE_INFO(0x238b,
+				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
+	.driver_info = (unsigned long)&rndis_info,
+}, {
 	/* RNDIS is MSFT's un-official variant of CDC ACM */
 	USB_INTERFACE_INFO(USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
 	.driver_info = (unsigned long) &rndis_info,


