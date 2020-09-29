Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E0B27CBFE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732907AbgI2McS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729547AbgI2LXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:23:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6922206A5;
        Tue, 29 Sep 2020 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378447;
        bh=IoCVrsR79AYUsIpowAJgDUNoxfHUm/Ij+N8h1eGcPGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiRcA4e2N0KIJQyMbvbHa3ClyBijnkzqTI2XDTXjdI8i3NgxO6P6FhXBqGa//L+7w
         m2iAEbVoUzryCr1c7hhMUKmqf7M0emjx7kOdo/4i+as2G/nkFApxuTG2UdQwBF2wM1
         qHDwJOLHf51dPSQYwm/ni5aJOmRsnOyWBFQK4GiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/245] gma/gma500: fix a memory disclosure bug due to uninitialized bytes
Date:   Tue, 29 Sep 2020 12:57:40 +0200
Message-Id: <20200929105947.440547899@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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



