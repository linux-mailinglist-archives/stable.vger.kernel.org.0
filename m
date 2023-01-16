Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3266CC38
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbjAPRXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbjAPRWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2312038B5D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4B4160F7C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C862FC433F1;
        Mon, 16 Jan 2023 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888437;
        bh=6kVvReXFqfKaRjAdEWJeGUqGyBKDud1KD6GG1KxXpFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOyyPJafzWDE51W3+xgsaiN56N3VzCQC8H1GgY7XjzCMOWYOOXMvHh41fL2tUnjm2
         izrX5cQQzCV8myBQYXC4hd5VKG5mNPoYSzvIUnpSX7gVj60drGiZVqt3R28zpt1sFS
         ffHfXSB1d60Qy4M7H42eGBYWLzk1ED5KepVvyJJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frederic Barrat <fbarrat@linux.ibm.com>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 520/521] powerpc/powernv/eeh: Fix oops when probing cxl devices
Date:   Mon, 16 Jan 2023 16:53:02 +0100
Message-Id: <20230116154910.455731887@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Frederic Barrat <fbarrat@linux.ibm.com>

commit a8a30219ba78b1abb92091102b632f8e9bbdbf03 upstream.

Recent cleanup in the way EEH support is added to a device causes a
kernel oops when the cxl driver probes a device and creates virtual
devices discovered on the FPGA:

  BUG: Kernel NULL pointer dereference at 0x000000a0
  Faulting instruction address: 0xc000000000048070
  Oops: Kernel access of bad area, sig: 7 [#1]
  ...
  NIP eeh_add_device_late.part.9+0x50/0x1e0
  LR  eeh_add_device_late.part.9+0x3c/0x1e0
  Call Trace:
    _dev_info+0x5c/0x6c (unreliable)
    pnv_pcibios_bus_add_device+0x60/0xb0
    pcibios_bus_add_device+0x40/0x60
    pci_bus_add_device+0x30/0x100
    pci_bus_add_devices+0x64/0xd0
    cxl_pci_vphb_add+0xe0/0x130 [cxl]
    cxl_probe+0x504/0x5b0 [cxl]
    local_pci_probe+0x6c/0x110
    work_for_cpu_fn+0x38/0x60

The root cause is that those cxl virtual devices don't have a
representation in the device tree and therefore no associated pci_dn
structure. In eeh_add_device_late(), pdn is NULL, so edev is NULL and
we oops.

We never had explicit support for EEH for those virtual devices.
Instead, EEH events are reported to the (real) pci device and handled
by the cxl driver. Which can then forward to the virtual devices and
handle dependencies. The fact that we try adding EEH support for the
virtual devices is new and a side-effect of the recent cleanup.

This patch fixes it by skipping adding EEH support on powernv for
devices which don't have a pci_dn structure.

The cxl driver doesn't create virtual devices on pseries so this patch
doesn't fix it there intentionally.

Fixes: b905f8cdca77 ("powerpc/eeh: EEH for pSeries hot plug")
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Reviewed-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191016162833.22509-1-fbarrat@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/eeh-powernv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/eeh-powernv.c
+++ b/arch/powerpc/platforms/powernv/eeh-powernv.c
@@ -47,7 +47,7 @@ void pnv_pcibios_bus_add_device(struct p
 {
 	struct pci_dn *pdn = pci_get_pdn(pdev);
 
-	if (eeh_has_flag(EEH_FORCE_DISABLED))
+	if (!pdn || eeh_has_flag(EEH_FORCE_DISABLED))
 		return;
 
 	pr_debug("%s: EEH: Setting up device %s.\n", __func__, pci_name(pdev));


