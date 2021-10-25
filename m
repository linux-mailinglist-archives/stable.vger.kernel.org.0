Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6EC43A060
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhJYTaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235752AbhJYT3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43C7361078;
        Mon, 25 Oct 2021 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189953;
        bh=/KsF0UjpjpPV14qGhOM2740bFJUHNDwkudubi9zYW2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jy1p0FtGp8JMX3RPvX+ycutuHe6+avKnvGknMtT14Mse0I9JNg6zbv+6dH4UEMEnR
         IHWtnkoayGgwp67qK+Gw+Y2rDDxyGJZHjpGjqyovJoZj7aHvxchJJH7UQ+6iXLr2uj
         3X79WNHjdzG0ymdgugjPpVxFm63VwbjTmfKO2vGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/58] lan78xx: select CRC32
Date:   Mon, 25 Oct 2021 21:14:28 +0200
Message-Id: <20211025190939.333633375@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
References: <20211025190937.555108060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

[ Upstream commit 46393d61a328d7c4e3264252dae891921126c674 ]

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/usb/lan78xx.o: in function `lan78xx_set_multicast':
  lan78xx.c:(.text+0x48cf): undefined reference to `crc32_le'

The actual use of crc32_le() comes indirectly through ether_crc().

Fixes: 55d7de9de6c30 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index ca234d1a0e3b..d7005cc76ce9 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -117,6 +117,7 @@ config USB_LAN78XX
 	select PHYLIB
 	select MICROCHIP_PHY
 	select FIXED_PHY
+	select CRC32
 	help
 	  This option adds support for Microchip LAN78XX based USB 2
 	  & USB 3 10/100/1000 Ethernet adapters.
-- 
2.33.0



