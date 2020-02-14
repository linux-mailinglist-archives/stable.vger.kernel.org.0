Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406CB15E42D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406019AbgBNQZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405472AbgBNQZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:25:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FADC24795;
        Fri, 14 Feb 2020 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697501;
        bh=QUa6HHul+EgbSuyu11j4V5t3voz5h0XBOwJQ324DJU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwipQ9uu6ZMZqP9ORulsD6y/gkNDBDdl4OYlR9xHoDxOLF9grvDtrNb8drM/6H94t
         pbKTmVqMAKSPVPtYSXG4wqa3Bx0YR93WgqI+Rk/d0cr/SbrB+9mfe84CjDnbZ1jncn
         mpYX5TAeBFmuultTerq/7B3dxnxCizKKoM+Xminw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.4 029/100] drm/gma500: remove set but not used variable 'is_hdmi','is_crt'
Date:   Fri, 14 Feb 2020 11:23:13 -0500
Message-Id: <20200214162425.21071-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 834c43a97f341d319aa7b74099bbce2c4e75bc72 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/gma500/cdv_intel_display.c: In function cdv_intel_crtc_mode_set:
drivers/gpu/drm/gma500/cdv_intel_display.c:594:7: warning: variable is_hdmi set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/gma500/cdv_intel_display.c: In function cdv_intel_crtc_mode_set:
drivers/gpu/drm/gma500/cdv_intel_display.c:593:7: warning: variable is_crt set but not used [-Wunused-but-set-variable]

They are not used since commit acd7ef927e06 ("gma500:
Update the Cedarview clock handling")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1573828027-122323-4-git-send-email-zhengbin13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/cdv_intel_display.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_display.c
index 7d47b3d5cc0d0..52c2895f714ed 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_display.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_display.c
@@ -590,8 +590,8 @@ static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
 	struct gma_clock_t clock;
 	u32 dpll = 0, dspcntr, pipeconf;
 	bool ok;
-	bool is_crt = false, is_lvds = false, is_tv = false;
-	bool is_hdmi = false, is_dp = false;
+	bool is_lvds = false, is_tv = false;
+	bool is_dp = false;
 	struct drm_mode_config *mode_config = &dev->mode_config;
 	struct drm_connector *connector;
 	const struct gma_limit_t *limit;
@@ -615,10 +615,7 @@ static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
 			is_tv = true;
 			break;
 		case INTEL_OUTPUT_ANALOG:
-			is_crt = true;
-			break;
 		case INTEL_OUTPUT_HDMI:
-			is_hdmi = true;
 			break;
 		case INTEL_OUTPUT_DISPLAYPORT:
 			is_dp = true;
-- 
2.20.1

