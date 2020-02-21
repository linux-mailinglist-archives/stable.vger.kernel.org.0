Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51591167578
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgBUI2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732493AbgBUIUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:20:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B33AE24673;
        Fri, 21 Feb 2020 08:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273245;
        bh=GrMvaoHiW8mqPaedW80LgmLZTHUhiLrqAUih5cuG+FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLkqvRxCSopf1KruuAe9Z5nsRhgjG8BR8FWNcktgSDbmpJSTAkpRbUB/xHyI9yu8n
         nYdFCWacrC8IeKXmd08eem0de25/CKaruMDcHFzg8kkP+XSL1OYyhD/rUn2WOlXqcQ
         wZpiMS4ZTgs8Ibz5gJt9/BTsKs9I3J/XeNXY86F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Ekstrand <jason@jlekstrand.net>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/191] ACPI: button: Add DMI quirk for Razer Blade Stealth 13 late 2019 lid switch
Date:   Fri, 21 Feb 2020 08:41:13 +0100
Message-Id: <20200221072303.080004751@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Ekstrand <jason@jlekstrand.net>

[ Upstream commit 0528904926aab19bffb2068879aa44db166c6d5f ]

Running evemu-record on the lid switch event shows that the lid reports
the first "close" but then never reports an "open".  This causes systemd
to continuously re-suspend the laptop every 30s.  Resetting the _LID to
"open" fixes the issue.

Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index a25d77b3a16ad..d5c19e25ddf59 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -102,6 +102,17 @@ static const struct dmi_system_id lid_blacklst[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Stealth 13 late 2019, notification of the LID device
+		 * only happens on close, not on open and _LID always returns closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Razer Blade Stealth 13 Late 2019"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{}
 };
 
-- 
2.20.1



