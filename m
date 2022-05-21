Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE78452FD05
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 15:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbiEUN5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 09:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243991AbiEUN4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 09:56:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3633B3F0
        for <stable@vger.kernel.org>; Sat, 21 May 2022 06:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32ECC60C1F
        for <stable@vger.kernel.org>; Sat, 21 May 2022 13:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207A8C385A5;
        Sat, 21 May 2022 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653141393;
        bh=Urep+azBVGA9dWbO2ItU8Dcxz204QBImuhmzSy+PQOs=;
        h=Subject:To:Cc:From:Date:From;
        b=z12V9Yim2oulOLFFIJi4CdsxbZJxuqETG17TZ398nyVkmw0tmPkv1xot7/WTsDpx3
         YBMOMwCyuJRGVjkomLT3al2bIY/NwMtVYaN4e9u2FWFbvFjmxvEYmR3dkeSnI6Vjd4
         Dc/2OXHknj6Jg/UBWLKjowamJma6hv6KGc/ZVfl8=
Subject: FAILED: patch "[PATCH] PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold" failed to apply to 4.9-stable tree
To:     rafael.j.wysocki@intel.com, bhelgaas@google.com, gottwald@igel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 21 May 2022 15:56:30 +0200
Message-ID: <1653141390105188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 92597f97a40bf661bebceb92e26ff87c76d562d4 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Thu, 31 Mar 2022 19:38:51 +0200
Subject: [PATCH] PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold

If a Root Port on Elo i2 is put into D3cold and then back into D0, the
downstream device becomes permanently inaccessible, so add a bridge D3 DMI
quirk for that system.

This was exposed by 14858dcc3b35 ("PCI: Use pci_update_current_state() in
pci_enable_device_flags()"), but before that commit the Root Port in
question had never been put into D3cold for real due to a mismatch between
its power state retrieved from the PCI_PM_CTRL register (which was
accessible even though the platform firmware indicated that the port was in
D3cold) and the state of an ACPI power resource involved in its power
management.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215715
Link: https://lore.kernel.org/r/11980172.O9o76ZdvQC@kreacher
Reported-by: Stefan Gottwald <gottwald@igel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v5.15+

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 9ecce435fb3f..d25122fbe98a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2920,6 +2920,16 @@ static const struct dmi_system_id bridge_d3_blacklist[] = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
 			DMI_MATCH(DMI_BOARD_NAME, "X299 DESIGNARE EX-CF"),
 		},
+		/*
+		 * Downstream device is not accessible after putting a root port
+		 * into D3cold and back into D0 on Elo i2.
+		 */
+		.ident = "Elo i2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Elo Touch Solutions"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Elo i2"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "RevB"),
+		},
 	},
 #endif
 	{ }

