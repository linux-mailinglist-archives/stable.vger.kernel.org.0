Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF4DBCCC9
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391720AbfIXQmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391573AbfIXQmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5DE20872;
        Tue, 24 Sep 2019 16:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343322;
        bh=6GqY/nqKTxCTGM2pwn0sZUAS7LmlMlK8LfSwH4hYi3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPcSCjgZmnkeUPqwJ++qmfI+CPzHYutPKKKEL0x0n0nUvXTtYkVHJsEqyMNBD7eWv
         S/lQfVI4Tl5yHOSb1UFLNrvumSa5LtmrQ29UmEHE98uvWWJ+unzAl73RoM50T7yjK/
         1kIeSbp1WFMnnwCW5sceFxalICBM+Z4am5CyFjhc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Koo <anthony.koo@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 08/87] drm/amd/display: add monitor patch to add T7 delay
Date:   Tue, 24 Sep 2019 12:40:24 -0400
Message-Id: <20190924164144.25591-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <anthony.koo@amd.com>

[ Upstream commit 88eac241a1fc500ce5274a09ddc4bd5fc2b5adb6 ]

[Why]
Specifically to one panel,
TCON is able to accept active video signal quickly, but
the Source Driver requires 2-3 frames of extra time.

It is a Panel issue since TCON needs to take care of
all Sink requirements including Source Driver. But in
this case it does not.

Customer is asking to add fixed T7 delay as panel
workaround.

[How]
Add monitor specific patch to add T7 delay

Signed-off-by: Anthony Koo <anthony.koo@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c | 4 ++++
 drivers/gpu/drm/amd/display/dc/dc_types.h          | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
index 2d019e1f61352..a9135764e5806 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_hwss.c
@@ -160,6 +160,10 @@ bool edp_receiver_ready_T7(struct dc_link *link)
 			break;
 		udelay(25); //MAx T7 is 50ms
 	} while (++tries < 300);
+
+	if (link->local_sink->edid_caps.panel_patch.extra_t7_ms > 0)
+		udelay(link->local_sink->edid_caps.panel_patch.extra_t7_ms * 1000);
+
 	return result;
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/dc_types.h b/drivers/gpu/drm/amd/display/dc/dc_types.h
index 6eabb6491a3df..ce6d73d21ccae 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -202,6 +202,7 @@ struct dc_panel_patch {
 	unsigned int dppowerup_delay;
 	unsigned int extra_t12_ms;
 	unsigned int extra_delay_backlight_off;
+	unsigned int extra_t7_ms;
 };
 
 struct dc_edid_caps {
-- 
2.20.1

