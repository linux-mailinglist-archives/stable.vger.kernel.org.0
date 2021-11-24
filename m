Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAE745BAD5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243667AbhKXMOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243423AbhKXMOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4190A6108F;
        Wed, 24 Nov 2021 12:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755725;
        bh=goLH+zDirGBuw9U04IOpnl9PZoD1BMOzb/miVVV89RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmJx7VSDl9KHyg/RjPJXK0FDUfI58omCcUTkjjQeyKwQGlFvmjjMtR+Y9t8PkFcEC
         6lbJZP3+FLJi5zvy+OjBOB+EJRsFrHFzK6tHCjP+uOJP/TudujCwQ1hhiWMC1bYY3Y
         DmTXtrXq5f6Dlz/HJwPXgDI8RZ/8scyllBh8NRKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingmar Klein <ingmar_klein@web.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.9 035/207] PCI: Mark Atheros QCA6174 to avoid bus reset
Date:   Wed, 24 Nov 2021 12:55:06 +0100
Message-Id: <20211124115705.081694972@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingmar Klein <ingmar_klein@web.de>

commit e3f4bd3462f6f796594ecc0dda7144ed2d1e5a26 upstream.

When passing the Atheros QCA6174 through to a virtual machine, the VM hangs
at the point where the ath10k driver loads.

Add a quirk to avoid bus resets on this device, which avoids the hang.

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/08982e05-b6e8-5a8d-24ab-da1488ee50a8@web.de
Signed-off-by: Ingmar Klein <ingmar_klein@web.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3370,6 +3370,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003e, quirk_no_bus_reset);
 
 /*
  * Some TI KeyStone C667X devices do not support bus/hot reset.  The PCIESS


