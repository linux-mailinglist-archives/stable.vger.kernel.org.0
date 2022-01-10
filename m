Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDA348924A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241192AbiAJHls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbiAJHgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:36:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6030DC025187;
        Sun,  9 Jan 2022 23:31:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F52B81212;
        Mon, 10 Jan 2022 07:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDFCC36AE9;
        Mon, 10 Jan 2022 07:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799899;
        bh=LWMxIqdPLrruG753ovFKYiDSZqY2xr4yMtOUiZIOR7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnWqmGdCVvGFn2fy86yIOnIbw8F5POvos80LzpG84PpryhjomdA2vFAemuPJuQ+Qd
         ypP1/aES55nQe824OKmloCxkBZQ9vLFLrhypUF1sJ3XC5fbW6gpyGDz12rkXzTH7FF
         k8gLGh9l7oQtvZrT5pKzdN5Lcf0eu+ylklJqGyrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 10/72] Revert "net: usb: r8152: Add MAC passthrough support for more Lenovo Docks"
Date:   Mon, 10 Jan 2022 08:22:47 +0100
Message-Id: <20220110071821.868066147@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

commit 00fcf8c7dd564c44448ff6a39728d2ca0c8efbd8 upstream.

This reverts commit f77b83b5bbab53d2be339184838b19ed2c62c0a5.

This change breaks multiple usb to ethernet dongles attached on Lenovo
USB hub.

Fixes: f77b83b5bbab ("net: usb: r8152: Add MAC passthrough support for more Lenovo Docks")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Link: https://lore.kernel.org/r/20220105155102.8557-1-aaron.ma@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9638,9 +9638,12 @@ static int rtl8152_probe(struct usb_inte
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
-	if (udev->parent &&
-			le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO) {
-		tp->lenovo_macpassthru = 1;
+	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
+		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
+			tp->lenovo_macpassthru = 1;
+		}
 	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&


