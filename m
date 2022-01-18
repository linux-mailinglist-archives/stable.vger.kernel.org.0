Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F5D491AD2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243150AbiARDC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344449AbiARC5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:57:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49A1C035419;
        Mon, 17 Jan 2022 18:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44C2E612DE;
        Tue, 18 Jan 2022 02:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B0DC36AEF;
        Tue, 18 Jan 2022 02:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473893;
        bh=dxlHkkDhrDWGJRS2ZBt0S7lqBxv/VVktAClM8xc6FqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTEHS6TZihmRPOMfQpa0sCgyWW73XDJlscZ4sALae6o59yFWve1ncBdcGU3TsIzID
         WqmQbjqlfcdYRGMq6j7cNhzFjJYRKiQ8JTJrhZjdmUuqBjRQ6bfajrdE7ZYdvuUyaA
         zlJrNkqg75qC0Na6U0vloO0+54M4sS9GUAOjPwm4P9xuuzoo64iPPP6M5aZDz1ztFC
         Kkej+LLfzXAj1pahaMw7Y0mvUdYUpu4disKVEXcIHYwS9bLWlqSoo1gmocnLSHJP7a
         ETf4A3ZjuNr1yg3cjpfSXL+lsyJETeFZR3M3A4/DzwljuIXeEt6JA3iRiN+CN8ckQl
         bIwJHW5UJNfMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Yauhen Kharuzhy <jekhor@gmail.com>,
        Simon Ser <contact@emersion.fr>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 10/73] drm: panel-orientation-quirks: Add quirk for the Lenovo Yoga Book X91F/L
Date:   Mon, 17 Jan 2022 21:43:29 -0500
Message-Id: <20220118024432.1952028-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bc30c3b0c8a1904d83d5f0d60fb8650a334b207b ]

The Lenovo Yoga Book X91F/L uses a panel which has been mounted
90 degrees rotated. Add a quirk for this.

Cc: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Simon Ser <contact@emersion.fr>
Tested-by: Yauhen Kharuzhy <jekhor@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211106130227.11927-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index a950d5db211c5..9d1bd8f491ad7 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -248,6 +248,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
+		.matches = {
+		  /* Non exact match to match all versions */
+		  DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* OneGX1 Pro */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "SYSTEM_MANUFACTURER"),
-- 
2.34.1

