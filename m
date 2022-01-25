Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53D499F90
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841568AbiAXW7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588121AbiAXWbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44298C02B86B;
        Mon, 24 Jan 2022 12:56:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9DE460916;
        Mon, 24 Jan 2022 20:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7283C340E7;
        Mon, 24 Jan 2022 20:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057773;
        bh=WpOyy6PjwGpfsS2pWgBqOag+9MmARwpgbKe9wRIksXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKFZ/W+EyF5deTdMRPVKYZ7Ow9alcn3mGa3ZvgjOqmon3iM2ESh63X5SAeZ6GQ49t
         Ur86ahDRIDDLnMa2Dc5dvohQGNvDZDNeG5yV/RqtyS4z0M01lIsqq/frrJbCiMDqtd
         LyWC8ZgFHBvBonSXtTkANr5HJwBnUt42i84b66dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Bingner <sam@bingner.com>,
        Yifeng Li <tomli@tomli.me>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [PATCH 5.16 0074/1039] PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller
Date:   Mon, 24 Jan 2022 19:31:03 +0100
Message-Id: <20220124184127.660334615@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit e445375882883f69018aa669b67cbb37ec873406 upstream.

Like other SATA controller chips in the Marvell 88SE91xx series, the
Marvell 88SE9125 has the same DMA requester ID hardware bug that prevents
it from working under IOMMU.  Add it to the list of devices that need the
quirk.

Without this patch, device initialization fails with DMA errors:

  ata8: softreset failed (1st FIS failed)
  DMAR: DRHD: handling fault status reg 2
  DMAR: [DMA Write NO_PASID] Request device [03:00.1] fault addr 0xfffc0000 [fault reason 0x02] Present bit in context entry is clear
  DMAR: DRHD: handling fault status reg 2
  DMAR: [DMA Read NO_PASID] Request device [03:00.1] fault addr 0xfffc0000 [fault reason 0x02] Present bit in context entry is clear

After applying the patch, the controller can be successfully initialized:

  ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 330)
  ata8.00: ATAPI: PIONEER BD-RW   BDR-207M, 1.21, max UDMA/100
  ata8.00: configured for UDMA/100
  scsi 7:0:0:0: CD-ROM            PIONEER  BD-RW   BDR-207M 1.21 PQ: 0 ANSI: 5

Link: https://lore.kernel.org/r/YahpKVR+McJVDdkD@work
Reported-by: Sam Bingner <sam@bingner.com>
Tested-by: Sam Bingner <sam@bingner.com>
Tested-by: Yifeng Li <tomli@tomli.me>
Signed-off-by: Yifeng Li <tomli@tomli.me>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4103,6 +4103,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_M
 			 quirk_dma_func1_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9123,
 			 quirk_dma_func1_alias);
+/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c136 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9125,
+			 quirk_dma_func1_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9128,
 			 quirk_dma_func1_alias);
 /* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c14 */


