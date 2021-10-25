Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963D6439FA1
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhJYTWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234505AbhJYTVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C742601FF;
        Mon, 25 Oct 2021 19:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189543;
        bh=yv4RZWeAP8xaERlvArIBsNSnH4pyc2GV012z6VHt/4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5CVPLFyQZmVORoyEP1gRv21kZpURGxYnIePuPboG9wkequYi8XkqMBYGLM+W55OH
         3ovmiv8y2sKFos5lNimc6ZR7s1qNnMsGNzNIbc6+AlmTM4klH5AP7onFPUwKv5sGO1
         Vt7mm211AeXf+uvddD/23UNdy6y7NK7fJ6q1F3KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 15/50] net: arc: select CRC32
Date:   Mon, 25 Oct 2021 21:14:02 +0200
Message-Id: <20211025190935.891157942@linuxfoundation.org>
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
@@ -19,6 +19,7 @@ config ARC_EMAC_CORE
 	tristate
 	select MII
 	select PHYLIB
+	select CRC32
 
 config ARC_EMAC
 	tristate "ARC EMAC support"


