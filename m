Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572A04890CC
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbiAJHZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239357AbiAJHYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE447C061748;
        Sun,  9 Jan 2022 23:24:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 647B0B811FE;
        Mon, 10 Jan 2022 07:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B86C36AED;
        Mon, 10 Jan 2022 07:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799464;
        bh=LnLFJ+xIVJsUkFhZjuXEDQOZzQIYa+delUwR5pPXtiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/O1UQ3ZNqur5dVpvLPBzjGsA3QfZc4CwS33xrd7WYyGXh9euZSRV9cgPlHzrXxrh
         E3pJjCaqfUdfEp3p2lRytXu7fkJ1kX1z304J8FwgWl62YvX9NhGvdIIE5EdhWce3KE
         tzHLBBJ+ORR8rThMVLJZaqaTwxn9cg80g13TxCFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Toye <thomas@toye.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 08/14] rndis_host: support Hytera digital radios
Date:   Mon, 10 Jan 2022 08:22:47 +0100
Message-Id: <20220110071812.051326366@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071811.779189823@linuxfoundation.org>
References: <20220110071811.779189823@linuxfoundation.org>
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
@@ -616,6 +616,11 @@ static const struct usb_device_id	produc
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


