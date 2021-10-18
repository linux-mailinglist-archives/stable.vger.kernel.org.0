Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B8431E4D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhJRN76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234332AbhJRN55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAE8561A3C;
        Mon, 18 Oct 2021 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564476;
        bh=0rsfe9mmqY8tnE+T46VmcaziIkmYKMD0zuPjEuBhEhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pt3pcVH1dGgSBTl2zEfSi+yXwg4JqZ9XQXRbfcrKfsox+CbvVWAQkPqxCFfRUQJ5C
         wnptRNA7reLNojXiTh3K/nuDXXgLuSkbzZFxmbYeU4O5F8LUEdHiFIeYE6/e9ve1xt
         SFuXXC0QSYXNIyi7w5D/bHrKt3VWJ9hxF7555cEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Florian fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 102/151] net: korina: select CRC32
Date:   Mon, 18 Oct 2021 15:24:41 +0200
Message-Id: <20211018132343.995527495@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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
@@ -100,6 +100,7 @@ config JME
 config KORINA
 	tristate "Korina (IDT RC32434) Ethernet support"
 	depends on MIKROTIK_RB532 || COMPILE_TEST
+	select CRC32
 	select MII
 	help
 	  If you have a Mikrotik RouterBoard 500 or IDT RC32434


