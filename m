Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF17491533
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245639AbiARC0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245655AbiARCYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:24:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9279C06177B;
        Mon, 17 Jan 2022 18:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 661D460AB6;
        Tue, 18 Jan 2022 02:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E853DC36AE3;
        Tue, 18 Jan 2022 02:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472639;
        bh=PJa9pJriew9OaMlnsA9qTXusUtpxB4DAsf4xRVD7nJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugbzTIbfNQFTzXoQUCeKbVNfPDQyUMEbkqvP5oNyP+RBQQIb71nYtRINaMNmWFZ38
         2YToeYBx/MhUS0HNQj/NVnfpcx+UYh47bU4KDqIfgs11gU3FU1qZDHLi5ehkZE8If2
         PAgO6ZsRSSSVBWRPP/WExfo3Y1mxVL7YIJwOn8RUm3DqliMlxOFEthMvwBXEhiYVL3
         3Byl/iTcWSKR0menVj0M6d9kJE/yFqCy4fHkTv/6uTexvs2nMFZegl6y82Y0gB8915
         pWRgfFoC7dlehLHwGZEsAoNnF6jF/M12xzRXB+lqBzPkj66X/Ok1HyOgoMuN4n5Byx
         aHFCWGGESj8sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mario.limonciello@amd.com, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 084/217] ACPI / x86: Drop PWM2 device on Lenovo Yoga Book from always present table
Date:   Mon, 17 Jan 2022 21:17:27 -0500
Message-Id: <20220118021940.1942199-84-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d431dfb764b145369be820fcdfd50f2159b9bbc2 ]

It turns out that there is a WMI object which controls the PWM2 device
used for the keyboard backlight and that WMI object also provides some
other useful functionality.

The upcoming lenovo-yogabook-wmi driver will offer both backlight
control and the other functionality, so there no longer is a need
to have the lpss-pwm driver binding to PWM2 for backlight control;
and this is now actually undesirable because this will cause both
the WMI code and the lpss-pwm driver to poke at the same PWM
controller.

Drop the always-present quirk for the PWM2 ACPI-device, so that the
 lpss-pwm controller will no longer bind to it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index f22f23933063b..3bcac98f6eca6 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -54,10 +54,6 @@ static const struct always_present_id always_present_ids[] = {
 	ENTRY("80860F09", "1", X86_MATCH(ATOM_SILVERMONT), {}),
 	ENTRY("80862288", "1", X86_MATCH(ATOM_AIRMONT), {}),
 
-	/* Lenovo Yoga Book uses PWM2 for keyboard backlight control */
-	ENTRY("80862289", "2", X86_MATCH(ATOM_AIRMONT), {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9"),
-		}),
 	/*
 	 * The INT0002 device is necessary to clear wakeup interrupt sources
 	 * on Cherry Trail devices, without it we get nobody cared IRQ msgs.
-- 
2.34.1

