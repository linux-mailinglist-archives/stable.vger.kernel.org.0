Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9D54E768B
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354736AbiCYPPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376742AbiCYPNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39380D9E99;
        Fri, 25 Mar 2022 08:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B636E61C0D;
        Fri, 25 Mar 2022 15:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7139C340E9;
        Fri, 25 Mar 2022 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221022;
        bh=P/lsnn5grhN8sEQznsMV6FxHZF705gkLi4sAWV2jTrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnchYzyHOUxzt1NaDZvX7dPYSOSQ4z8j7NmI1h8PIjmCQ64zRyU2sS6nynBZGCmuS
         TR60xRjRUAn2CpsW9TSIo0AQDt0S/th6v/1SuW5vcn+tce+u5uJkLDQCZS9pLq9qhG
         j5CICq4ZeBSDQPwpm7dYlj0ZGdRJStIR+9m1z1rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Cilissen <mark@yotsuba.nl>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 29/38] ACPI / x86: Work around broken XSDT on Advantech DAC-BJ01 board
Date:   Fri, 25 Mar 2022 16:05:13 +0100
Message-Id: <20220325150420.585611210@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.757836392@linuxfoundation.org>
References: <20220325150419.757836392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Cilissen <mark@yotsuba.nl>

commit e702196bf85778f2c5527ca47f33ef2e2fca8297 upstream.

On this board the ACPI RSDP structure points to both a RSDT and an XSDT,
but the XSDT points to a truncated FADT. This causes all sorts of trouble
and usually a complete failure to boot after the following error occurs:

  ACPI Error: Unsupported address space: 0x20 (*/hwregs-*)
  ACPI Error: AE_SUPPORT, Unable to initialize fixed events (*/evevent-*)
  ACPI: Unable to start ACPI Interpreter

This leaves the ACPI implementation in such a broken state that subsequent
kernel subsystem initialisations go wrong, resulting in among others
mismapped PCI memory, SATA and USB enumeration failures, and freezes.

As this is an older embedded platform that will likely never see any BIOS
updates to address this issue and its default shipping OS only complies to
ACPI 1.0, work around this by forcing `acpi=rsdt`. This patch, applied on
top of Linux 5.10.102, was confirmed on real hardware to fix the issue.

Signed-off-by: Mark Cilissen <mark@yotsuba.nl>
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/acpi/boot.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1340,6 +1340,17 @@ static int __init disable_acpi_pci(const
 	return 0;
 }
 
+static int __init disable_acpi_xsdt(const struct dmi_system_id *d)
+{
+	if (!acpi_force) {
+		pr_notice("%s detected: force use of acpi=rsdt\n", d->ident);
+		acpi_gbl_do_not_use_xsdt = TRUE;
+	} else {
+		pr_notice("Warning: DMI blacklist says broken, but acpi XSDT forced\n");
+	}
+	return 0;
+}
+
 static int __init dmi_disable_acpi(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
@@ -1464,6 +1475,19 @@ static const struct dmi_system_id acpi_d
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	/*
+	 * Boxes that need ACPI XSDT use disabled due to corrupted tables
+	 */
+	{
+	 .callback = disable_acpi_xsdt,
+	 .ident = "Advantech DAC-BJ01",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "NEC"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "Bearlake CRB Board"),
+		     DMI_MATCH(DMI_BIOS_VERSION, "V1.12"),
+		     DMI_MATCH(DMI_BIOS_DATE, "02/01/2011"),
+		     },
+	 },
 	{}
 };
 


