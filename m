Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F16373A49
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhEEMJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhEEMI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:08:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689B061182;
        Wed,  5 May 2021 12:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216449;
        bh=vZwxj9y87MI0CzeUTtAorS9lYzBHNDZVYh4Iv2vx3kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y20I0Ej2eKGmiodW65yCThPgin/3NJGzedx6mQTSukw+C3Su1ck9hfPGaFGLT3ou0
         sxOodpXFr6INxT4YOSEftQr9Ik4qgcFiXfv9ceVhE0SIGzSIferEQsZDzZmp6pmwB2
         ala9PiG4zUrfnliXaz+ogoS0xjTa5GMiSF/O3WLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 03/29] net: usb: ax88179_178a: initialize local variables before use
Date:   Wed,  5 May 2021 14:05:06 +0200
Message-Id: <20210505112326.309761787@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
References: <20210505112326.195493232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

commit bd78980be1a68d14524c51c4b4170782fada622b upstream.

Use memset to initialize local array in drivers/net/usb/ax88179_178a.c, and
also set a local u16 and u32 variable to 0. Fixes a KMSAN found uninit-value bug
reported by syzbot at:
https://syzkaller.appspot.com/bug?id=00371c73c72f72487c1d0bfe0cc9d00de339d5aa

Reported-by: syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -296,12 +296,12 @@ static int ax88179_read_cmd(struct usbne
 	int ret;
 
 	if (2 == size) {
-		u16 buf;
+		u16 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
-		u32 buf;
+		u32 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
@@ -1296,6 +1296,8 @@ static void ax88179_get_mac_addr(struct
 {
 	u8 mac[ETH_ALEN];
 
+	memset(mac, 0, sizeof(mac));
+
 	/* Maybe the boot loader passed the MAC address via device tree */
 	if (!eth_platform_get_mac_address(&dev->udev->dev, mac)) {
 		netif_dbg(dev, ifup, dev->net,


