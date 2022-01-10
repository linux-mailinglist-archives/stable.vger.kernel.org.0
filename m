Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E28489169
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbiAJHbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38994 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiAJH36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C16B5611C1;
        Mon, 10 Jan 2022 07:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A6CC36B00;
        Mon, 10 Jan 2022 07:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799797;
        bh=W1D9UO82cgAo6aiHdohcnepskgBlIB9uzCRajtDZ34M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oooZBsjSt1A5i3wnwEgvKotNTRZKupxA5p+PaHjUdAyFth5jLAPS5UbcxUBd1yw1/
         pnkeNk8qLwc+z+ArRzufhTkL236jvwo5N6wEsojcYlsqYXt8uToHB/WtyPLhnK8Hw/
         /WMj0FND2iue4rI6w1WJiPlFFwCUMwljz16QEIEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Alexander Aring <aahringo@redhat.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.10 05/43] ieee802154: atusb: fix uninit value in atusb_set_extended_addr
Date:   Mon, 10 Jan 2022 08:23:02 +0100
Message-Id: <20220110071817.521262640@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

commit 754e4382354f7908923a1949d8dc8d05f82f09cb upstream.

Alexander reported a use of uninitialized value in
atusb_set_extended_addr(), that is caused by reading 0 bytes via
usb_control_msg().

Fix it by validating if the number of bytes transferred is actually
correct, since usb_control_msg() may read less bytes, than was requested
by caller.

Fail log:

BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
 ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
 atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
 atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
 usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396

Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
Reported-by: Alexander Potapenko <glider@google.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20220104182806.7188-1-paskripkin@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/atusb.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -93,7 +93,9 @@ static int atusb_control_msg(struct atus
 
 	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
 			      value, index, data, size, timeout);
-	if (ret < 0) {
+	if (ret < size) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		atusb->err = ret;
 		dev_err(&usb_dev->dev,
 			"%s: req 0x%02x val 0x%x idx 0x%x, error %d\n",
@@ -861,9 +863,9 @@ static int atusb_get_and_show_build(stru
 	if (!build)
 		return -ENOMEM;
 
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_BUILD, ATUSB_REQ_FROM_DEV, 0, 0,
-				build, ATUSB_BUILD_SIZE, 1000);
+	/* We cannot call atusb_control_msg() here, since this request may read various length data */
+	ret = usb_control_msg(atusb->usb_dev, usb_rcvctrlpipe(usb_dev, 0), ATUSB_BUILD,
+			      ATUSB_REQ_FROM_DEV, 0, 0, build, ATUSB_BUILD_SIZE, 1000);
 	if (ret >= 0) {
 		build[ret] = 0;
 		dev_info(&usb_dev->dev, "Firmware: build %s\n", build);


