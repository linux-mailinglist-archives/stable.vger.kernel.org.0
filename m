Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185B1431CF4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhJRNqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232432AbhJRNo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5533C6159A;
        Mon, 18 Oct 2021 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564114;
        bh=KKmFggWOIxdeFqORwrBzgJJYqzZ/XjUd8vhuuFwgfT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=km166xdSPT5khufNnpKZG7ZGH1+INTnK+VOuWhUeX0v+SlmoJMdY9Z//FTq0K8ydG
         mZ0n6Zb3wFXU5cenmKc+fflb6giz6uyBebm7NLDkgDLEpRGokTMbDzgcooIlmMYvZq
         RsVwz+RsAjTDnK015sS5z5h89XaI9p6JQmEsHp3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 070/103] net: arc: select CRC32
Date:   Mon, 18 Oct 2021 15:24:46 +0200
Message-Id: <20211018132337.089696612@linuxfoundation.org>
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

commit e599ee234ad4fdfe241d937bbabd96e0d8f9d868 upstream.

Fix the following build/link error by adding a dependency on the CRC32
routines:

  ld: drivers/net/ethernet/arc/emac_main.o: in function `arc_emac_set_rx_mode':
  emac_main.c:(.text+0xb11): undefined reference to `crc32_le'

The crc32_le() call comes through the ether_crc_le() call in
arc_emac_set_rx_mode().

[v2: moved the select to ARC_EMAC_CORE; the Makefile is a bit confusing,
but the error comes from emac_main.o, which is part of the arc_emac module,
which in turn is enabled by CONFIG_ARC_EMAC_CORE. Note that arc_emac is
different from emac_arc...]

Fixes: 775dd682e2b0ec ("arc_emac: implement promiscuous mode and multicast filtering")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Link: https://lore.kernel.org/r/20211012093446.1575-1-vegard.nossum@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/arc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -21,6 +21,7 @@ config ARC_EMAC_CORE
 	depends on ARC || ARCH_ROCKCHIP || COMPILE_TEST
 	select MII
 	select PHYLIB
+	select CRC32
 
 config ARC_EMAC
 	tristate "ARC EMAC support"


