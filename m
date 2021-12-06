Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D65A469E89
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386020AbhLFPjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358084AbhLFPhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:37:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9711C08EADB;
        Mon,  6 Dec 2021 07:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 791556132A;
        Mon,  6 Dec 2021 15:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603ACC341C2;
        Mon,  6 Dec 2021 15:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804194;
        bh=NVYc831lTubR1pDQoit5Z7uxb0b0HMjCDCYurmDIRHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCXUftPVW6tL1H7T0x2Gi+w0hjs/kpzrKtQq4lGd8Jr9JSnBE0HrpgFmovIvGXik3
         1q86q++UjCIoZhhasEdOcDLV9C7lauCLmng2XxJ9UGpe0lN5yXEm6MxC4Kg4Pcd/Gy
         xF2zv0VMjH98kfY7v61KO/yAJH36PCmXm5EmwABg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/207] net: usb: r8152: Add MAC passthrough support for more Lenovo Docks
Date:   Mon,  6 Dec 2021 15:54:47 +0100
Message-Id: <20211206145611.372865535@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit f77b83b5bbab53d2be339184838b19ed2c62c0a5 ]

Like ThinkaPad Thunderbolt 4 Dock, more Lenovo docks start to use the original
Realtek USB ethernet chip ID 0bda:8153.

Lenovo Docks always use their own IDs for usb hub, even for older Docks.
If parent hub is from Lenovo, then r8152 should try MAC passthrough.
Verified on Lenovo TBT3 dock too.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f329e39100a7d..d3da350777a4d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9603,12 +9603,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
-	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
-		switch (le16_to_cpu(udev->descriptor.idProduct)) {
-		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
-		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
-			tp->lenovo_macpassthru = 1;
-		}
+	if (udev->parent &&
+			le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO) {
+		tp->lenovo_macpassthru = 1;
 	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-- 
2.33.0



