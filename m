Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8957249164E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345749AbiARCb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239879AbiARCYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:24:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A99C0613A0;
        Mon, 17 Jan 2022 18:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FB0F60AB1;
        Tue, 18 Jan 2022 02:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB12EC36AEB;
        Tue, 18 Jan 2022 02:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472646;
        bh=gHZDIl4ijtbPfwSZrWODXsLXyJ1ff7iEnfrh/2hqDMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsbKubfcrOy3u060KCuJp4JHJYZGeUOk+qB12dVt+/mbTzKIofTHv+HZS/OsLDIVE
         9q2xrZe7WamHbeVip+4Oao3WD68ivCBACCreHOqc5z6OqO7Mry6JyLxLhQT+50NJus
         KfMh1+nud0IgB0jibUD6nFNJiChjDrLwO8covZDHcjNUq0s2/sREy0Hb6kGOl9P6OA
         6VtxfZVL6PAKUQx1QUKwmuw278BxYzpFGlvtR6uMz2Q2jr7jarSToo6iPUSgeWoAwx
         n0tbD5RnhqzTpS7DIdXSmqs9Cuhz3shGgi5nbDCCeLne1pkLeiJUAmQqV8faVxelIw
         iMNLnz5p1QUcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mario.limonciello@amd.com, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 086/217] ACPI / x86: Allow specifying acpi_device_override_status() quirks by path
Date:   Mon, 17 Jan 2022 21:17:29 -0500
Message-Id: <20220118021940.1942199-86-sashal@kernel.org>
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

[ Upstream commit ba46e42e925b5d09b4e441f8de3db119cc7df58f ]

Not all ACPI-devices have a HID + UID, allow specifying quirks for
acpi_device_override_status() by path too.

Note this moves the path/HID+UID check to after the CPU + DMI checks
since the path lookup is somewhat costly.

This way this lookup is only done on devices where the other checks
match.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 42 ++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index edb4f3fd93dc3..190bfc2ab3f26 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -38,22 +38,30 @@ struct override_status_id {
 	struct x86_cpu_id cpu_ids[2];
 	struct dmi_system_id dmi_ids[2]; /* Optional */
 	const char *uid;
+	const char *path;
 	unsigned long long status;
 };
 
-#define ENTRY(status, hid, uid, cpu_model, dmi...) {			\
+#define ENTRY(status, hid, uid, path, cpu_model, dmi...) {		\
 	{ { hid, }, {} },						\
 	{ X86_MATCH_INTEL_FAM6_MODEL(cpu_model, NULL), {} },		\
 	{ { .matches = dmi }, {} },					\
 	uid,								\
+	path,								\
 	status,								\
 }
 
 #define PRESENT_ENTRY_HID(hid, uid, cpu_model, dmi...) \
-	ENTRY(ACPI_STA_DEFAULT, hid, uid, cpu_model, dmi)
+	ENTRY(ACPI_STA_DEFAULT, hid, uid, NULL, cpu_model, dmi)
 
 #define NOT_PRESENT_ENTRY_HID(hid, uid, cpu_model, dmi...) \
-	ENTRY(0, hid, uid, cpu_model, dmi)
+	ENTRY(0, hid, uid, NULL, cpu_model, dmi)
+
+#define PRESENT_ENTRY_PATH(path, cpu_model, dmi...) \
+	ENTRY(ACPI_STA_DEFAULT, "", NULL, path, cpu_model, dmi)
+
+#define NOT_PRESENT_ENTRY_PATH(path, cpu_model, dmi...) \
+	ENTRY(0, "", NULL, path, cpu_model, dmi)
 
 static const struct override_status_id override_status_ids[] = {
 	/*
@@ -120,13 +128,6 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(override_status_ids); i++) {
-		if (acpi_match_device_ids(adev, override_status_ids[i].hid))
-			continue;
-
-		if (!adev->pnp.unique_id ||
-		    strcmp(adev->pnp.unique_id, override_status_ids[i].uid))
-			continue;
-
 		if (!x86_match_cpu(override_status_ids[i].cpu_ids))
 			continue;
 
@@ -134,6 +135,27 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
 		    !dmi_check_system(override_status_ids[i].dmi_ids))
 			continue;
 
+		if (override_status_ids[i].path) {
+			struct acpi_buffer path = { ACPI_ALLOCATE_BUFFER, NULL };
+			bool match;
+
+			if (acpi_get_name(adev->handle, ACPI_FULL_PATHNAME, &path))
+				continue;
+
+			match = strcmp((char *)path.pointer, override_status_ids[i].path) == 0;
+			kfree(path.pointer);
+
+			if (!match)
+				continue;
+		} else {
+			if (acpi_match_device_ids(adev, override_status_ids[i].hid))
+				continue;
+
+			if (!adev->pnp.unique_id ||
+			    strcmp(adev->pnp.unique_id, override_status_ids[i].uid))
+				continue;
+		}
+
 		*status = override_status_ids[i].status;
 		ret = true;
 		break;
-- 
2.34.1

