Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174DE406C43
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhIJMi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhIJMgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F060961212;
        Fri, 10 Sep 2021 12:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277330;
        bh=yNeSV/+GvOhN4sGBzmArfpkfRCnC8Sxs6NJWjqbipQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YolKgoiuErrdQTJV/Q/gjf6XjkDPnyvWt0OmoaOT8nx9iAwaPD8VOsFm80736vrVW
         1J2EwTNnR8fXKtMQuMzBQrlhcHhzT5+63y40ZGfH0vHObhJb6bIqRf0V0iGUwpleim
         2Tw6JFXd+QOWtI3zt75nf4sZ03XYNHhqkhNEiHZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 37/37] PCI: Call Max Payload Size-related fixup quirks early
Date:   Fri, 10 Sep 2021 14:30:40 +0200
Message-Id: <20210910122918.373728688@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
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
@@ -3246,12 +3246,12 @@ static void fixup_mpss_256(struct pci_de
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
 
 /*
  * Intel 5000 and 5100 Memory controllers have an erratum with read completion


