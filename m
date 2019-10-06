Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93ECCD5DB
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbfJFRkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731049AbfJFRkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:40:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D9D2087E;
        Sun,  6 Oct 2019 17:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383636;
        bh=6GqY/nqKTxCTGM2pwn0sZUAS7LmlMlK8LfSwH4hYi3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXHaj1Gz83sElH+ufgevVBXSJrCObnAYSUDVXMjCYbPZSy4Yp4XPYswM1hFxX7WLp
         FiToIFW3FfHic7Y6vicqDjjClrO22LZtfD1mZsd276QquVVCTHPjN/4tThFmvnc9yc
         HMOCZPE6DpXnj2+1mis85j9NgHHbAAHLHjP2JGVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <anthony.koo@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 006/166] drm/amd/display: add monitor patch to add T7 delay
Date:   Sun,  6 Oct 2019 19:19:32 +0200
Message-Id: <20191006171213.254184690@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



