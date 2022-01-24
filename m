Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EAC499443
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388975AbiAXUkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39462 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386309AbiAXUfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:35:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E0A5B811F9;
        Mon, 24 Jan 2022 20:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87756C340E5;
        Mon, 24 Jan 2022 20:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056522;
        bh=PJa9pJriew9OaMlnsA9qTXusUtpxB4DAsf4xRVD7nJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12EJ+tR/iM1zwgjcdIJwkzxe2kTuOkWe3bxIzlbWqmyWm5fFTpV+6s2MriLJrJ2h9
         k32xv8wl8hB4wEVnfoCE7DOngDEYoQXOaJoMuV2pqL+5F7mLW+TQnghvRcanEu6GXF
         X4SYsSfpVJ/KD1C01bW+li71C7Js+6nmrjQLjO1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/846] ACPI / x86: Drop PWM2 device on Lenovo Yoga Book from always present table
Date:   Mon, 24 Jan 2022 19:40:30 +0100
Message-Id: <20220124184118.707485797@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



