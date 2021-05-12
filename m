Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F277D37C319
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhELPRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233883AbhELPPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66BF761941;
        Wed, 12 May 2021 15:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831894;
        bh=Mf38KVZcLTNmYm1u9TmD8sxnXxtkHPltI+RSrxA/WkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEtSlS+dZP9Tz31rqgGpvCagUyqlw8mRTQUTfg3uRFcFbSvTqD3oHPJjLTiWg6pIX
         BHr3dSdQ3FIn3prwjqNOFrnbhAdgOK9HjJApDBXk7coVZPduBW1qo1W67bY99vUPal
         LE+XjMR1GBDoredi0+QSkAHRtDQLMzFb4rzc28WQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 058/530] FDDI: defxx: Make MMIO the configuration default except for EISA
Date:   Wed, 12 May 2021 16:42:48 +0200
Message-Id: <20210512144821.638529397@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 193ced4a79599352d63cb8c9e2f0c6043106eb6a upstream.

Recent versions of the PCI Express specification have deprecated support
for I/O transactions and actually some PCIe host bridges, such as Power
Systems Host Bridge 4 (PHB4), do not implement them.

The default kernel configuration choice for the defxx driver is the use
of I/O ports rather than MMIO for PCI and EISA systems.  It may have
made sense as a conservative backwards compatible choice back when MMIO
operation support was added to the driver as a part of TURBOchannel bus
support.  However nowadays this configuration choice makes the driver
unusable with systems that do not implement I/O transactions for PCIe.

Make DEFXX_MMIO the configuration default then, except where configured
for EISA.  This exception is because an EISA adapter can have its MMIO
decoding disabled with ECU (EISA Configuration Utility) and therefore
not available with the resource allocation infrastructure we implement,
while port I/O is always readily available as it uses slot-specific
addressing, directly mapped to the slot an option card has been placed
in and handled with our EISA bus support core.  Conversely a kernel that
supports modern systems which may not have I/O transactions implemented
for PCIe will usually not be expected to handle legacy EISA systems.

The change of the default will make it easier for people, including but
not limited to distribution packagers, to make a working choice for the
driver.

Update the option description accordingly and while at it replace the
potentially ambiguous PIO acronym with IOP for "port I/O" vs "I/O ports"
according to our nomenclature used elsewhere.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: e89a2cfb7d7b ("[TC] defxx: TURBOchannel support")
Cc: stable@vger.kernel.org # v2.6.21+
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/fddi/Kconfig |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/fddi/Kconfig
+++ b/drivers/net/fddi/Kconfig
@@ -40,17 +40,20 @@ config DEFXX
 
 config DEFXX_MMIO
 	bool
-	prompt "Use MMIO instead of PIO" if PCI || EISA
+	prompt "Use MMIO instead of IOP" if PCI || EISA
 	depends on DEFXX
-	default n if PCI || EISA
+	default n if EISA
 	default y
 	help
 	  This instructs the driver to use EISA or PCI memory-mapped I/O
-	  (MMIO) as appropriate instead of programmed I/O ports (PIO).
+	  (MMIO) as appropriate instead of programmed I/O ports (IOP).
 	  Enabling this gives an improvement in processing time in parts
-	  of the driver, but it may cause problems with EISA (DEFEA)
-	  adapters.  TURBOchannel does not have the concept of I/O ports,
-	  so MMIO is always used for these (DEFTA) adapters.
+	  of the driver, but it requires a memory window to be configured
+	  for EISA (DEFEA) adapters that may not always be available.
+	  Conversely some PCIe host bridges do not support IOP, so MMIO
+	  may be required to access PCI (DEFPA) adapters on downstream PCI
+	  buses with some systems.  TURBOchannel does not have the concept
+	  of I/O ports, so MMIO is always used for these (DEFTA) adapters.
 
 	  If unsure, say N.
 


