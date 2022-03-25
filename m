Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6864E75D3
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359547AbiCYPId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359619AbiCYPHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:07:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8CDDA09D;
        Fri, 25 Mar 2022 08:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D3AFB828F8;
        Fri, 25 Mar 2022 15:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEBDC340F1;
        Fri, 25 Mar 2022 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220746;
        bh=gZbiEnHbTTXCK6xT8y02Ptf0o6I0H8OviTJ3cr3WOjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xj2V2cVRIjwa4ka8ye8373l+8H+0Z5z731G9UfiS9m1tbEhyVABxEz8IBtTyPrvpD
         mqFmOQ0znPhMy0SvlJWw++xPQUkv0keyZrxN1ORU6jvcfadDJ4yk3c2MpJUHDljaJv
         w8S7WS7r4NIu9OGNgaFbNkf1JmRkCNQkUDN/wiIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Cilissen <mark@yotsuba.nl>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 13/17] ACPI / x86: Work around broken XSDT on Advantech DAC-BJ01 board
Date:   Fri, 25 Mar 2022 16:04:47 +0100
Message-Id: <20220325150417.149072490@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150416.756136126@linuxfoundation.org>
References: <20220325150416.756136126@linuxfoundation.org>
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
@@ -1343,6 +1343,17 @@ static int __init disable_acpi_pci(const
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
@@ -1463,6 +1474,19 @@ static const struct dmi_system_id acpi_d
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
 


