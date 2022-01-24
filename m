Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A672C49A386
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1847630AbiAXX6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846324AbiAXXPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:15:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891B2C06177C;
        Mon, 24 Jan 2022 13:23:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 456E4B8105C;
        Mon, 24 Jan 2022 21:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD7FC340E7;
        Mon, 24 Jan 2022 21:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059408;
        bh=PJa9pJriew9OaMlnsA9qTXusUtpxB4DAsf4xRVD7nJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLJsVU1PwzfyydRJKhRk4O4oQIvUbnZDY8InpdT3DloyHV043lXYZPo9RHuwK5trp
         Jx5UUz7w8uJWiv2+tbd2Zq8yYL1fcL5hQwkDIxAi6s+fKiZOM3osZscZ9eVIpXkijP
         Aaw8yMIJUWJZl8rtYthCcRAUSdS15WcBrSr8Cbms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0605/1039] ACPI / x86: Drop PWM2 device on Lenovo Yoga Book from always present table
Date:   Mon, 24 Jan 2022 19:39:54 +0100
Message-Id: <20220124184145.668191846@linuxfoundation.org>
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



