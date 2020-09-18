Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953B326F18E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbgIRCwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgIRCIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAAE2389E;
        Fri, 18 Sep 2020 02:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394894;
        bh=IoCVrsR79AYUsIpowAJgDUNoxfHUm/Ij+N8h1eGcPGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUbv+CKCY/dGTI7GFO1fxD3m9/l9ZOK4JN4aMTAVHnlLnwPn33CCAHDe6bAL3qTLs
         ykj8rBHW1JxvQR2DYjv0CeAF1WVzM/eOzuUZ88BsUr/riX5qu2KbfvGDMaml20d24E
         bIeXvj4eYDXUh9yBeRY8lYFkwJi6S+N71VyLqQZ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 009/206] gma/gma500: fix a memory disclosure bug due to uninitialized bytes
Date:   Thu, 17 Sep 2020 22:04:45 -0400
Message-Id: <20200918020802.2065198-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 57a25a5f754ce27da2cfa6f413cfd366f878db76 ]

`best_clock` is an object that may be sent out. Object `clock`
contains uninitialized bytes that are copied to `best_clock`,
which leads to memory disclosure and information leak.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20191018042953.31099-1-kjlu@umn.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/cdv_intel_display.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_display.c
index 17db4b4749d5a..2e8479744ca4a 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_display.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_display.c
@@ -415,6 +415,8 @@ static bool cdv_intel_find_dp_pll(const struct gma_limit_t *limit,
 	struct gma_crtc *gma_crtc = to_gma_crtc(crtc);
 	struct gma_clock_t clock;
 
+	memset(&clock, 0, sizeof(clock));
+
 	switch (refclk) {
 	case 27000:
 		if (target < 200000) {
-- 
2.25.1

