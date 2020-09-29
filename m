Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6079D27C9E0
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgI2Lh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbgI2Lgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E39F823AAA;
        Tue, 29 Sep 2020 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379106;
        bh=CaRo9/AHPZPm51FSWlzZAZXiIvY/hOJpN6jhNEj6A9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GXrBt9E/niBuEgB1oiehcSOAflUAMu7sK6Gk4uSmpmEYkYCMxAycBgpX6ziiXpPw
         6OW06me6oEFKtw1yxWE9/o9o7rRRRajfxJD9+62bBmd+/Tb2z9btVO3Ca+aipvsitv
         c0k9LN9VCHE4w6qAjwKarKR+4lgQT6LEmc+sP2k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/388] gma/gma500: fix a memory disclosure bug due to uninitialized bytes
Date:   Tue, 29 Sep 2020 12:55:48 +0200
Message-Id: <20200929110011.317978186@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f56852a503e8d..8b784947ed3b9 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_display.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_display.c
@@ -405,6 +405,8 @@ static bool cdv_intel_find_dp_pll(const struct gma_limit_t *limit,
 	struct gma_crtc *gma_crtc = to_gma_crtc(crtc);
 	struct gma_clock_t clock;
 
+	memset(&clock, 0, sizeof(clock));
+
 	switch (refclk) {
 	case 27000:
 		if (target < 200000) {
-- 
2.25.1



