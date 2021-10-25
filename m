Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F204439F96
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhJYTWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234258AbhJYTVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA7D26112F;
        Mon, 25 Oct 2021 19:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189523;
        bh=u8O7nu3IFo70M67z9E3h7OH31dB0utrND8ayViNyC0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfUgAjrYAo8+IB9ZGIpzbY9mpwhq05hpyMFtxXYiAulVaxvBOkMSh39Upoy8qvVQL
         1LumkTvuyKjccvdTo9sOyWWRrpiF38heoBfnNxARhmXArzgpxXrQkWyZnR+BCnMIDI
         FiGuURgqkYCbyv1uNzqeL9EEAzN9it+KHRCqfdbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 25/50] r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256
Date:   Mon, 25 Oct 2021 21:14:12 +0200
Message-Id: <20211025190937.705278132@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
References: <20211025190932.542632625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 9973a43012b6ad1720dbc4d5faf5302c28635b8c upstream.

Fix the following build/link errors by adding a dependency on
CRYPTO, CRYPTO_HASH, CRYPTO_SHA256 and CRC32:

  ld: drivers/net/usb/r8152.o: in function `rtl8152_fw_verify_checksum':
  r8152.c:(.text+0x2b2a): undefined reference to `crypto_alloc_shash'
  ld: r8152.c:(.text+0x2bed): undefined reference to `crypto_shash_digest'
  ld: r8152.c:(.text+0x2c50): undefined reference to `crypto_destroy_tfm'
  ld: drivers/net/usb/r8152.o: in function `_rtl8152_set_rx_mode':
  r8152.c:(.text+0xdcb0): undefined reference to `crc32_le'

Fixes: 9370f2d05a2a1 ("r8152: support request_firmware for RTL8153")
Fixes: ac718b69301c7 ("net/usb: new driver for RTL8152")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -98,6 +98,10 @@ config USB_RTL8150
 config USB_RTL8152
 	tristate "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 	select MII
+	select CRC32
+	select CRYPTO
+	select CRYPTO_HASH
+	select CRYPTO_SHA256
 	help
 	  This option adds support for Realtek RTL8152 based USB 2.0
 	  10/100 Ethernet adapters and RTL8153 based USB 3.0 10/100/1000


