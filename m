Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F064B4890B5
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbiAJHYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239244AbiAJHYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA227C061748;
        Sun,  9 Jan 2022 23:24:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FEB0B81203;
        Mon, 10 Jan 2022 07:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BF6C36AED;
        Mon, 10 Jan 2022 07:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799447;
        bh=RBTUXFqEnQBlxgNUXJFmTdTEQYpRg5T5bUaiz8qWXZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZl4M3cUgaiAgwqMdesOuKLiReP9/8dmN1vwJsb/YtoH+ijn5OTbG+w6XrEj/3R2u
         9gVWZCHmenAlP1MalQ5udrZQhNwP7zQp8z1vE4FhOhTLgz0QhX+qLH7VPMCIl3suhO
         cmPLZXKUBXvbJe+7UP/0z2ryd8qqmREQKIaToP2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>,
        Alexander Aring <aahringo@redhat.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.4 03/14] ieee802154: atusb: fix uninit value in atusb_set_extended_addr
Date:   Mon, 10 Jan 2022 08:22:42 +0100
Message-Id: <20220110071811.890826187@linuxfoundation.org>
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
@@ -77,7 +77,9 @@ static int atusb_control_msg(struct atus
 
 	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
 			      value, index, data, size, timeout);
-	if (ret < 0) {
+	if (ret < size) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		atusb->err = ret;
 		dev_err(&usb_dev->dev,
 			"atusb_control_msg: req 0x%02x val 0x%x idx 0x%x, error %d\n",
@@ -567,9 +569,9 @@ static int atusb_get_and_show_build(stru
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


