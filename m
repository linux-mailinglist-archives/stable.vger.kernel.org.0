Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F9661E3FF
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiKFRGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKFRF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:05:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9AB10FEF;
        Sun,  6 Nov 2022 09:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE979B80C6D;
        Sun,  6 Nov 2022 17:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B3C433D6;
        Sun,  6 Nov 2022 17:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754307;
        bh=/NiMo/wrEOascdcvbbrGjZmpvDphjSdGKHk1PUjRYWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpu/uX2pLsgX3IqrtJBlw1sFhlt4TmtYe+rUIcOWRY6zBqkhRUzJ8PvwdB4zhFT67
         AalqIhjq+j+A9rvKRw/cZSz3V3DhlN/AMjbKvO5isjQ1oyHBUyI7WmLGscjAZobqJf
         PmXwDyuFhRxBLdEmqTvkOSe8niaY+c+2/15BFa8Gs4tn9Sd5y4B79bqI8Oga5lGaXb
         XMRG+bneO3Gm62iQE7sxUxeZAaqhmZYRs6hwl0dLhGDlAkPOnCHKIqI2jFvBm1+/iz
         C41L6xLFnwXBlpM67lJjalreriUUiC8TNnJmKO2j/VTC87JywDkDsYJOYm6W/W47lY
         rM4EOOjWOKMIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 30/30] ACPI: scan: Add LATT2021 to acpi_ignore_dep_ids[]
Date:   Sun,  6 Nov 2022 12:03:42 -0500
Message-Id: <20221106170345.1579893-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fa153b7cddce795662d38f78a87612c166c0f692 ]

Some x86/ACPI laptops with MIPI cameras have a LATT2021 ACPI device
in the _DEP dependency list of the ACPI devices for the camera-sensors
(which have flags.honor_deps set).

The _DDN for the LATT2021 device is "Lattice FW Update Client Driver",
suggesting that this is used for firmware updates of something. There
is no Linux driver for this and if Linux gets support for updates it
will likely be in userspace through fwupd.

For now add the LATT2021 HID to acpi_ignore_dep_ids[] so that
acpi_dev_ready_for_enumeration() will return true once the other _DEP
dependencies are met.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 42cec8120f18..adfeb5770efd 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -796,6 +796,7 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
 static const char * const acpi_ignore_dep_ids[] = {
 	"PNP0D80", /* Windows-compatible System Power Management Controller */
 	"INT33BD", /* Intel Baytrail Mailbox Device */
+	"LATT2021", /* Lattice FW Update Client Driver */
 	NULL
 };
 
-- 
2.35.1

