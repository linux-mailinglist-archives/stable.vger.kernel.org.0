Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83CC3CA97C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241775AbhGOTG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241771AbhGOTFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFAB613E5;
        Thu, 15 Jul 2021 19:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375743;
        bh=6mgecr9hT2o3vUpA0ZgxGUAH2GB6BHXEW9m2waH4tms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqXS4PeLR4oeR5Awh0jnYwR3XzgRZcHfc1OZAYvwwArT0+e/J21mlykoEKMVZPXcA
         D312FbNqvpD89hvX3aWNX2DqKUA2w5Sa7UGDR0IgLxQRhaRW1k7D/KW3GbrfmWDK9S
         arBfxy8ENlWtuC4duGuO8q8b69KUsU71u4JLGVl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Konstantin Kharlamov <Hi-Angel@yandex.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.12 218/242] PCI: Leave Apple Thunderbolt controllers on for s2idle or standby
Date:   Thu, 15 Jul 2021 20:39:40 +0200
Message-Id: <20210715182631.461806493@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Kharlamov <Hi-Angel@yandex.ru>

commit 4694ae373dc2114f9a82f6ae15737e65af0c6dea upstream.

On Macbook 2013, resuming from suspend-to-idle or standby resulted in the
external monitor no longer being detected, a stacktrace, and errors like
this in dmesg:

  pcieport 0000:06:00.0: can't change power state from D3hot to D0 (config space inaccessible)

The reason is that we know how to turn power to the Thunderbolt controller
*off* via the SXIO/SXFP/SXLF methods, but we don't know how to turn power
back on.  We have to rely on firmware to turn the power back on.

When going to the "suspend-to-idle" or "standby" system sleep states,
firmware is not involved either on the suspend side or the resume side, so
we can't use SXIO/SXFP/SXLF to turn the power off.

Skip SXIO/SXFP/SXLF when firmware isn't involved in suspend, e.g., when
we're going to the "suspend-to-idle" or "standby" system sleep states.

Fixes: 1df5172c5c25 ("PCI: Suspend/resume quirks for Apple thunderbolt")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212767
Link: https://lore.kernel.org/r/20210520235501.917397-1-Hi-Angel@yandex.ru
Signed-off-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -27,6 +27,7 @@
 #include <linux/nvme.h>
 #include <linux/platform_data/x86/apple.h>
 #include <linux/pm_runtime.h>
+#include <linux/suspend.h>
 #include <linux/switchtec.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
@@ -3668,6 +3669,16 @@ static void quirk_apple_poweroff_thunder
 		return;
 	if (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM)
 		return;
+
+	/*
+	 * SXIO/SXFP/SXLF turns off power to the Thunderbolt controller.
+	 * We don't know how to turn it back on again, but firmware does,
+	 * so we can only use SXIO/SXFP/SXLF if we're suspending via
+	 * firmware.
+	 */
+	if (!pm_suspend_via_firmware())
+		return;
+
 	bridge = ACPI_HANDLE(&dev->dev);
 	if (!bridge)
 		return;


