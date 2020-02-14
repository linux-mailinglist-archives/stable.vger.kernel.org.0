Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0F715E5BF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393228AbgBNQm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405396AbgBNQWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FF53246E9;
        Fri, 14 Feb 2020 16:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697333;
        bh=+jis4DE3IIgqFeCmKzwXpOLiKwa1li8NWsKZs+Gltg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwQ8NQV7LjTlVhWAYP1AnExvpAjSClIIKCpKmLzQzKPktLGWlSiWJojNFEHI8a5C8
         s8vaWQAblzvH87X/bmMR/NjSodZq7HjgxcCCwDASU5N55qIymgAzYr4Seo8IsdFbsj
         8mj3RdE6dvRGlvO/iovwykSVRnznUBBGc1DV/ptc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 040/141] drm/gma500: remove set but not used variable 'is_hdmi','is_crt'
Date:   Fri, 14 Feb 2020 11:19:40 -0500
Message-Id: <20200214162122.19794-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
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
index 17db4b4749d5a..9854fdd7c51cf 100644
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

