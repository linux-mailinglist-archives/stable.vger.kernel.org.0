Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804D12F79F0
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388241AbhAOMjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:39:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388236AbhAOMi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:38:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC682223E0;
        Fri, 15 Jan 2021 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714299;
        bh=+vpoZ5thGZ6VaIQaWyDcx87Frcf0KFCkSBcWzTUVQGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHT82JC484kIOH2450BCd3wX6qRESugDmuLqvEsTQ7Lrs1gb2hvxlJ95UjC0aFB8L
         10KcQ9u97vFrXzYZ9muSQmAI9rmAnM6PFvsGXl0p3/1yLfaZ50sU7glN0H+cimBf2j
         oqS1E3jpXxEPmdn4WHBU6FtECUENtnK5C4jgPQ4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 074/103] qed: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:28:07 +0100
Message-Id: <20210115122009.610216148@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 2860d45a589818dd8ffd90cdc4bcf77f36a5a6be upstream.

Without this, the driver fails to link:

lpc_eth.c:(.text+0x1934): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_grc_dump':
qed_debug.c:(.text+0x4068): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_idle_chk_dump':
qed_debug.c:(.text+0x51fc): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_mcp_trace_dump':
qed_debug.c:(.text+0x6000): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_dbg_reg_fifo_dump':
qed_debug.c:(.text+0x66cc): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o:qed_debug.c:(.text+0x6aa4): more undefined references to `crc32_le' follow

Fixes: 7a4b21b7d1f0 ("qed: Add nvram selftest")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/qlogic/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -78,6 +78,7 @@ config QED
 	depends on PCI
 	select ZLIB_INFLATE
 	select CRC8
+	select CRC32
 	select NET_DEVLINK
 	help
 	  This enables the support for Marvell FastLinQ adapters family.


