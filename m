Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF542EB06F
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbhAEQqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729592AbhAEQqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:46:36 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F822C061793
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 08:45:56 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id s6so14919934qvn.6
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 08:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aBm6ZT9oGLVCakfH8Hpy6tlKHEkp0qXnXJR7JSm6nAQ=;
        b=ZCtXuAxyux081ZvkuKevJgWiZtcIriX9z9mCdqFRiVb6MA43Fa2oWk/z/QiZb6S1V1
         c/phumsLilMCktii8eio8/w+PWMlUTTwBCJ/Ww14cPB/7sKBIkTKQBm+bw/O1pcY/FSJ
         MEo0Npn+xLKKpXuJKBbcaWTSlJPKa43PtrHgeA/a8VlfvBdIs59YHZ2HZfkMDYOGSurh
         2svSbUSFvOblFSltbFqvlwxvckXQzT9CbrO/CZjUp5UxoJBJhTlqJijVCICkgukz1QXS
         lWDL8WPgOQCyGmec2EDrDEBASw++PlvZBeSW4gyc3jEKiwtqeCzxn6G7k1kjvpiEIeTp
         OgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aBm6ZT9oGLVCakfH8Hpy6tlKHEkp0qXnXJR7JSm6nAQ=;
        b=WzOBS0WV9Mez+FRiZOyNwa5Bb9B5S6dApief7nE8MHvYGI79nP0vXANB/ZnS5SMf5X
         i3QericcpmSanQ37kyJX9RgeUl0YeuUiINOuQmKkZF0AU4S1fHIjA2h7O7jq2Cqq9k5r
         e+ZI+MCqNr0qpPNWzXJNO1k8LmOJMEaehGkESwzxbCbrbN/yzigt5huGz/TWKPFuxMjn
         CpePv7tnUnOnRB7KyS+TEi5ypA+/cwzXPM/1GHMUSC9RZEj9oRY09ta502Q9eE7CFCPB
         2Jz55MQGKucPn7J1UlFYYS9wMv2qJE9GjJ93uRYBVL9sNUk74yy34rpgtNY6TfN+U+Dj
         gvSQ==
X-Gm-Message-State: AOAM531/TtohdUUx2yOl95RRhGK/T1ZAZTE55ZWZO13q4wQfgqPg6NSW
        C4m8vcbn2j4vs0vUCo8uHfU=
X-Google-Smtp-Source: ABdhPJzJDiUxVbUAmBAWOnnLMe88Xfw33hnunLEdL4FaKQxE5ZKNzVXQkjwIXRCVaQ8TH9kJI+Mw/w==
X-Received: by 2002:a0c:f991:: with SMTP id t17mr370061qvn.6.1609865155307;
        Tue, 05 Jan 2021 08:45:55 -0800 (PST)
Received: from localhost.localdomain ([192.161.78.241])
        by smtp.gmail.com with ESMTPSA id a9sm301843qkk.39.2021.01.05.08.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 08:45:54 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Andre Tomt <andre@tomt.net>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable@vger.kernel.org
Subject: [PATCH] Revert "drm/amd/display: Fix memory leaks in S3 resume"
Date:   Tue,  5 Jan 2021 11:45:45 -0500
Message-Id: <20210105164545.963036-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit a135a1b4c4db1f3b8cbed9676a40ede39feb3362.

This leads to blank screens on some boards after replugging a
display.  Revert until we understand the root cause and can
fix both the leak and the blank screen after replug.

Cc: Stylon Wang <stylon.wang@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Andre Tomt <andre@tomt.net>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0d2e334be87a..318eb12f8de7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2385,8 +2385,7 @@ void amdgpu_dm_update_connector_after_detect(
 
 			drm_connector_update_edid_property(connector,
 							   aconnector->edid);
-			aconnector->num_modes = drm_add_edid_modes(connector, aconnector->edid);
-			drm_connector_list_update(connector);
+			drm_add_edid_modes(connector, aconnector->edid);
 
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
-- 
2.29.2

