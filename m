Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B15615EB31
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394364AbgBNRTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391624AbgBNQKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C27D2469C;
        Fri, 14 Feb 2020 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696646;
        bh=We/SMqES5kF9MPTnXDpKNKHaq6SPjYDZobbxfBZQkFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpTW8/vUAWhY2b7zPOHm0QmJS/WtFBHsup+W8Hy2x+1OWQ3ISo2SZ6BcOj2KUDJbF
         A34LACR3/XX61l7tl6BIJgFBkkhpqW87emN2KZ1eMGUW1avcvtYqUjrfGqkcBChq32
         9iM/Sut53N6sGmOCDLRqv1Vu4mbflQIZa067Sz5A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dor Askayo <dor.askayo@gmail.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 422/459] drm/amd/display: do not allocate display_mode_lib unnecessarily
Date:   Fri, 14 Feb 2020 11:01:12 -0500
Message-Id: <20200214160149.11681-422-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dor Askayo <dor.askayo@gmail.com>

[ Upstream commit bb67bfd2e7101bf2ac5327b0b7a847cd9fb9723f ]

This allocation isn't required and can fail when resuming from suspend.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/1009
Signed-off-by: Dor Askayo <dor.askayo@gmail.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 4b8819c27fcda..4704aac336c29 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2267,12 +2267,7 @@ void dc_set_power_state(
 	enum dc_acpi_cm_power_state power_state)
 {
 	struct kref refcount;
-	struct display_mode_lib *dml = kzalloc(sizeof(struct display_mode_lib),
-						GFP_KERNEL);
-
-	ASSERT(dml);
-	if (!dml)
-		return;
+	struct display_mode_lib *dml;
 
 	switch (power_state) {
 	case DC_ACPI_CM_POWER_STATE_D0:
@@ -2294,6 +2289,12 @@ void dc_set_power_state(
 		 * clean state, and dc hw programming optimizations will not
 		 * cause any trouble.
 		 */
+		dml = kzalloc(sizeof(struct display_mode_lib),
+				GFP_KERNEL);
+
+		ASSERT(dml);
+		if (!dml)
+			return;
 
 		/* Preserve refcount */
 		refcount = dc->current_state->refcount;
@@ -2307,10 +2308,10 @@ void dc_set_power_state(
 		dc->current_state->refcount = refcount;
 		dc->current_state->bw_ctx.dml = *dml;
 
+		kfree(dml);
+
 		break;
 	}
-
-	kfree(dml);
 }
 
 void dc_resume(struct dc *dc)
-- 
2.20.1

