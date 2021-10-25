Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA643A04F
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbhJYT3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235096AbhJYT1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C5D5610C7;
        Mon, 25 Oct 2021 19:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189849;
        bh=5tYRPSgD9ptvnUyJMOWtxQ/xLK9z0JyO6R7rJe5/Gkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHtmkbkiijQ3RLmAHNsIhSSHaF9714dh1LzbhFNOmKKvtdcUd7G6Kmm2lw+2YgclR
         ALuKIZMZ5HEHbbAtq8Y2AjpVGzWalncL+XYy7ehmbJvQkHmvLBWI2iUHmfUV4k2qxX
         XPCm6H8gCTK+IdBhEXULEHrPLXMIan5t04jZukTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/37] lan78xx: select CRC32
Date:   Mon, 25 Oct 2021 21:14:33 +0200
Message-Id: <20211025190929.904594844@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
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
index cc2fd1957765..23fa0e2a75ff 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -116,6 +116,7 @@ config USB_LAN78XX
 	select PHYLIB
 	select MICROCHIP_PHY
 	select FIXED_PHY
+	select CRC32
 	help
 	  This option adds support for Microchip LAN78XX based USB 2
 	  & USB 3 10/100/1000 Ethernet adapters.
-- 
2.33.0



