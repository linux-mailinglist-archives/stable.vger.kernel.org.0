Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD91F531D1E
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbiEWRSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240216AbiEWRRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCC569CEF;
        Mon, 23 May 2022 10:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C9A6B8121C;
        Mon, 23 May 2022 17:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81529C385A9;
        Mon, 23 May 2022 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326117;
        bh=riyIxm/6DV0D51V6qS4eIgtQ8gmXffvMp6/SrgHtugg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zhnelaajp4yDkd4ycE2hYvINNjzVR9L1vQhhoVxjZ1yKldvoovSaIg6fsKPPm7QOb
         3ARTSQ6v9stH7tlI4XHSCXnez+x2mRXpqwvoQKe8xWVRa0nuXSG6QDZSbQ7Uew7Elx
         QjjE+A7JR6++iVPWvsLd1mu/8QgVMvyxvA2V8DPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Gottwald <gottwald@igel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 29/68] PCI/PM: Avoid putting Elo i2 PCIe Ports in D3cold
Date:   Mon, 23 May 2022 19:04:56 +0200
Message-Id: <20220523165807.394701006@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 92597f97a40bf661bebceb92e26ff87c76d562d4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2613,6 +2613,16 @@ static const struct dmi_system_id bridge
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


