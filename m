Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C085D15E0AB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403796AbgBNQOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392066AbgBNQOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:14:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7F8246D8;
        Fri, 14 Feb 2020 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696877;
        bh=GrMvaoHiW8mqPaedW80LgmLZTHUhiLrqAUih5cuG+FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1J9siBH/fZsT4Qml6hK4ZyfnlN0v7g25mciwRDFtdNJOam3OMweJ+VukYPupn0+kJ
         bJWajfaS/fVTho8kFfedIJwsyNXbfdzlMcQW+YoJubHmJnD6ttmpgJeAEpPV2AIqYo
         uTx4k8cKvNbLb/lfMSjWxcPKRUdF3qwPdQsk9qPY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Ekstrand <jason@jlekstrand.net>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 133/252] ACPI: button: Add DMI quirk for Razer Blade Stealth 13 late 2019 lid switch
Date:   Fri, 14 Feb 2020 11:09:48 -0500
Message-Id: <20200214161147.15842-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

