Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D8F431CF9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhJRNqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233355AbhJRNor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD67615A6;
        Mon, 18 Oct 2021 13:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564117;
        bh=q+Ip6i/+WzA/KoTLt78D0dcC50zHzkKA8f5+oyMaaOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmlUKUQB1Bvp+Emd1wcqGnad+0sZFbqDvatabPkkk/Y6aokCX1SMqKfV9QV6uWh4g
         1jiTKToXpsfkRbHLEoWHbzM8wwZxsv8EabZQrdAuen6L6Lc+ecvsMHOnSvw9c1QSHb
         XDES7mOYVZbHBkf9S9wCgF+2+7Tv0d5/DSUh6FcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Florian fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 071/103] net: korina: select CRC32
Date:   Mon, 18 Oct 2021 15:24:47 +0200
Message-Id: <20211018132337.122666636@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 427f974d9727ca681085ddcd0530c97ab5811ae0 upstream.

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/ethernet/korina.o: in function `korina_multicast_list':
  korina.c:(.text+0x1af): undefined reference to `crc32_le'

Fixes: ef11291bcd5f9 ("Add support the Korina (IDT RC32434) Ethernet MAC")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Florian fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211012152509.21771-1-vegard.nossum@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -99,6 +99,7 @@ config JME
 config KORINA
 	tristate "Korina (IDT RC32434) Ethernet support"
 	depends on MIKROTIK_RB532
+	select CRC32
 	help
 	  If you have a Mikrotik RouterBoard 500 or IDT RC32434
 	  based system say Y. Otherwise say N.


