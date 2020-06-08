Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D581F22AB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgFHXKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbgFHXJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47CF020890;
        Mon,  8 Jun 2020 23:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657796;
        bh=328IPl57uqoaTxlo/TjMr4hOM4xvcNmtfCE2JqOZE+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOTv3K+FSm+p9+o2kM6zaryVbykf4kxOTWbcrdNOiKOQeLlwu0xZXcgM4YwiznkhO
         BPYcmgrf2vzY0451xhrXyfqS7ik5daMGwdLO3nyiEpjwyq+xtRIwegj+lqFDApcg3r
         MUANMwg9GPpvXSeMS+O5saKgT6GTcl9H3TVO6BuM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 175/274] platform/x86: intel-vbtn: Use acpi_evaluate_integer()
Date:   Mon,  8 Jun 2020 19:04:28 -0400
Message-Id: <20200608230607.3361041-175-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 18937875a231d831c309716d6d8fc358f8381881 ]

Use acpi_evaluate_integer() instead of open-coding it.

This is a preparation patch for adding a intel_vbtn_has_switches()
helper function.

Fixes: de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet mode switch on 2-in-1's")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-vbtn.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index b5880936d785..191894d648bb 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -119,28 +119,21 @@ static void detect_tablet_mode(struct platform_device *device)
 	const char *chassis_type = dmi_get_system_info(DMI_CHASSIS_TYPE);
 	struct intel_vbtn_priv *priv = dev_get_drvdata(&device->dev);
 	acpi_handle handle = ACPI_HANDLE(&device->dev);
-	struct acpi_buffer vgbs_output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *obj;
+	unsigned long long vgbs;
 	acpi_status status;
 	int m;
 
 	if (!(chassis_type && strcmp(chassis_type, "31") == 0))
-		goto out;
+		return;
 
-	status = acpi_evaluate_object(handle, "VGBS", NULL, &vgbs_output);
+	status = acpi_evaluate_integer(handle, "VGBS", NULL, &vgbs);
 	if (ACPI_FAILURE(status))
-		goto out;
-
-	obj = vgbs_output.pointer;
-	if (!(obj && obj->type == ACPI_TYPE_INTEGER))
-		goto out;
+		return;
 
-	m = !(obj->integer.value & TABLET_MODE_FLAG);
+	m = !(vgbs & TABLET_MODE_FLAG);
 	input_report_switch(priv->input_dev, SW_TABLET_MODE, m);
-	m = (obj->integer.value & DOCK_MODE_FLAG) ? 1 : 0;
+	m = (vgbs & DOCK_MODE_FLAG) ? 1 : 0;
 	input_report_switch(priv->input_dev, SW_DOCK, m);
-out:
-	kfree(vgbs_output.pointer);
 }
 
 static int intel_vbtn_probe(struct platform_device *device)
-- 
2.25.1

