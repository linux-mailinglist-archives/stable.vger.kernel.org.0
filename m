Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABA6411B6F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245660AbhITQ6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241958AbhITQ4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:56:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B440D61242;
        Mon, 20 Sep 2021 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156678;
        bh=7S7TV+4fh1G+GEn4kC3KzTkyaRuZU3TmOAvgbJxXe/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R92EXsWEaL4o/02wtV8g8rcXGO3eSmcaoZq+yPrG1XGoirlUm5L2OFdHUKNfNIrDP
         PI7J4noQeIA1lkcZDxpmBJMp+Gz5xpQ7g8bWWS+I3kNECwMerR8VpFo/rU5hWNYQ4B
         DPIHOchYXNeNecv70aa0Vdo2v2nRmasPkbmuVQH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.9 034/175] PCI: Call Max Payload Size-related fixup quirks early
Date:   Mon, 20 Sep 2021 18:41:23 +0200
Message-Id: <20210920163919.177532743@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit b8da302e2955fe4d41eb9d48199242674d77dbe0 upstream.

pci_device_add() calls HEADER fixups after pci_configure_device(), which
configures Max Payload Size.

Convert MPS-related fixups to EARLY fixups so pci_configure_mps() takes
them into account.

Fixes: 27d868b5e6cfa ("PCI: Set MPS to match upstream bridge")
Link: https://lore.kernel.org/r/20210624171418.27194-1-kabel@kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2994,12 +2994,12 @@ static void fixup_mpss_256(struct pci_de
 {
 	dev->pcie_mpss = 1; /* 256 bytes */
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
-			 PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_0, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
+			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
 
 /* Intel 5000 and 5100 Memory controllers have an errata with read completion
  * coalescing (which is enabled by default on some BIOSes) and MPS of 256B.


