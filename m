Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FA640E001
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhIPQQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237857AbhIPQNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99746139D;
        Thu, 16 Sep 2021 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808589;
        bh=NFrGmOjQVLMvV/HpF5LMSqtHkHIDEbEEUZZB9yULr2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDZe+Uwob24n+Fx/vOqxx9iDjbeCVaNrsc+lxP0G5DQgmNkO2JV5Yhu0YZEBjZ/6F
         tczAGgVh7samShkGWnD3fbJ+4KzG5Bc2RX5+JWFThIFpOr56EgJsWYqe/fJMGeaBwq
         SH74b8ipw2gL1n4yMahhdhVclCx18O8HZ/g1vYec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Jacob <Anson.Jacob@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/306] drm/amd/amdgpu: Update debugfs link_settings output link_rate field in hex
Date:   Thu, 16 Sep 2021 17:58:14 +0200
Message-Id: <20210916155759.138442895@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

[ Upstream commit 1a394b3c3de2577f200cb623c52a5c2b82805cec ]

link_rate is updated via debugfs using hex values, set it to output
in hex as well.

eg: Resolution: 1920x1080@144Hz
cat /sys/kernel/debug/dri/0/DP-1/link_settings
Current:  4  0x14  0  Verified:  4  0x1e  0  Reported:  4  0x1e  16  Preferred:  0  0x0  0

echo "4 0x1e" > /sys/kernel/debug/dri/0/DP-1/link_settings

cat /sys/kernel/debug/dri/0/DP-1/link_settings
Current:  4  0x1e  0  Verified:  4  0x1e  0  Reported:  4  0x1e  16  Preferred:  4  0x1e  0

Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index e02a55fc1382..fbb65c95464b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -197,29 +197,29 @@ static ssize_t dp_link_settings_read(struct file *f, char __user *buf,
 
 	rd_buf_ptr = rd_buf;
 
-	str_len = strlen("Current:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Current:  %d  %d  %d  ",
+	str_len = strlen("Current:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Current:  %d  0x%x  %d  ",
 			link->cur_link_settings.lane_count,
 			link->cur_link_settings.link_rate,
 			link->cur_link_settings.link_spread);
 	rd_buf_ptr += str_len;
 
-	str_len = strlen("Verified:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Verified:  %d  %d  %d  ",
+	str_len = strlen("Verified:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Verified:  %d  0x%x  %d  ",
 			link->verified_link_cap.lane_count,
 			link->verified_link_cap.link_rate,
 			link->verified_link_cap.link_spread);
 	rd_buf_ptr += str_len;
 
-	str_len = strlen("Reported:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Reported:  %d  %d  %d  ",
+	str_len = strlen("Reported:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Reported:  %d  0x%x  %d  ",
 			link->reported_link_cap.lane_count,
 			link->reported_link_cap.link_rate,
 			link->reported_link_cap.link_spread);
 	rd_buf_ptr += str_len;
 
-	str_len = strlen("Preferred:  %d  %d  %d  ");
-	snprintf(rd_buf_ptr, str_len, "Preferred:  %d  %d  %d\n",
+	str_len = strlen("Preferred:  %d  0x%x  %d  ");
+	snprintf(rd_buf_ptr, str_len, "Preferred:  %d  0x%x  %d\n",
 			link->preferred_link_setting.lane_count,
 			link->preferred_link_setting.link_rate,
 			link->preferred_link_setting.link_spread);
-- 
2.30.2



