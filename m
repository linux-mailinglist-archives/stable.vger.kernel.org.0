Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19CB65133C
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiLST24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiLST2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:28:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56A7D5D
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 880FAB80F4B
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD685C433D2;
        Mon, 19 Dec 2022 19:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478096;
        bh=GwNPNgTrw9lFxqSpgIc/697osRh2UKoDqnLwDq4JGWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAc2nC2wSgljHgi/aZUN5HePfpV/KECx3m99m9sPLoLsgX+luE1EFsK+zaDuhfJgx
         j2MIXS4iVmOomQUUk5eKRRUcgOx8pLTrHGBPxnGWSZn0I0l7JRQWCLjuHjyyvsIHih
         nKjC2eP20ElzxRWJRzWijN75L9DnV2RUi/gAO6eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Reka Norman <rekanorman@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 10/18] xhci: Apply XHCI_RESET_TO_DEFAULT quirk to ADL-N
Date:   Mon, 19 Dec 2022 20:25:03 +0100
Message-Id: <20221219182941.013061951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
References: <20221219182940.701087296@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reka Norman <rekanorman@chromium.org>

commit fed70b61ef2c0aed54456db3d485b215f6cc3209 upstream.

ADL-N systems have the same issue as ADL-P, where a large boot firmware
delay is seen if USB ports are left in U3 at shutdown. So apply the
XHCI_RESET_TO_DEFAULT quirk to ADL-N as well.

This patch depends on commit 34cd2db408d5 ("xhci: Add quirk to reset
host back to default state at shutdown").

The issue it fixes is a ~20s boot time delay when booting from S5. It
affects ADL-N devices, and ADL-N support was added starting from v5.16.

Cc: stable@vger.kernel.org
Signed-off-by: Reka Norman <rekanorman@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221130091944.2171610-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI		0x51ed
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI	0x54ed
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -242,7 +243,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_MISSING_CAS;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+	    (pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_PCH_XHCI))
 		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&


