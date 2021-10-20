Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0B743565F
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 01:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhJTXUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 19:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJTXUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 19:20:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED23C06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 16:17:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so1710719pjl.2
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 16:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmAxhqZ/qDXN3jl5uUqBa40we4vavlccN8HRNtmRBjo=;
        b=DPDaH/RkezXtN0idzH4Syc1+SsqMzr4yMjUZzdfeRXscRQPBE5okTja97VBkR4Sy8v
         dUX1gTvgvHkm1HUmvc0LBJJlgQLXrwbvVztlIHrL82E/ew9TAgSJ6C0s1nf1lpyPMH98
         EozvhWu7w2JyGQJO6ZDIU0j/j/Xb9ZFbE9VbI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xmAxhqZ/qDXN3jl5uUqBa40we4vavlccN8HRNtmRBjo=;
        b=O/3/nDg90NfuTXLOWG41hxdHqBByZ1r+BXjhxvETzzbiH5yPtFvmzreiPfHlw8bCoy
         hnOAVybwTzc3ke+r6WZzrYRZu8QzVry6CfOHsfDRKq/e/5hkWvEeGW3CYIYpuMFbQbiS
         zAe2iNex9xg20Xjaa2QmVSaaKnNBrpmmf9XDQXdxqFc4YDOxSsvHEbLdFcd8Yx0otGZ0
         JHz/jyFB64CF3Y7wXzTTzMGFQX0ExlUC0dQC44wSsBqMIaQNRWffHqP5gcsXeAN2g9Vz
         2RwxqSIdNPzmVu1aI7eGtbGcH6+ZDT4oyRpfr6KmoyZ4g7pcJuq/Bg0lEF6SsMHJzILt
         lwBA==
X-Gm-Message-State: AOAM533Y/wkOJSYHhiHGaaUGJCUzaN4+TERCIYqRDUQ8AeDUOxvTp9W6
        sJGRAjdPkJC/BVZZdWEBBxL/kq73ZBZNcA==
X-Google-Smtp-Source: ABdhPJy10j1PNwa7XNz+7pTguI6ICQBzzgQiMZZp5X2pn58l45H2/Rq64w/vkIsJdW2IpL1mtRa3OA==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr2042453pjb.129.1634771866681;
        Wed, 20 Oct 2021 16:17:46 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:ee8c:e73a:3f5e:717a])
        by smtp.gmail.com with UTF8SMTPSA id kb10sm7856013pjb.18.2021.10.20.16.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 16:17:46 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>
Cc:     Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        dri-devel@lists.freedesktop.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Zain Wang <wzz@rock-chips.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>
Subject: [PATCH] drm/bridge: analogix_dp: Make PSR-disable non-blocking
Date:   Wed, 20 Oct 2021 16:17:28 -0700
Message-Id: <20211020161724.1.I67612ea073c3306c71b46a87be894f79707082df@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prior to commit 6c836d965bad ("drm/rockchip: Use the helpers for PSR"),
"PSR disable" used non-blocking analogix_dp_send_psr_spd(). The refactor
accidentally (?) set blocking=true.

This can cause upwards of 60-100ms of unneeded latency when exiting
self-refresh, which can cause very noticeable lag when, say, moving a
cursor.

Presumbaly it's OK to let the display finish exiting refresh in parallel
with clocking out the next video frames, so we shouldn't hold up the
atomic_enable() step. This also brings behavior in line with the
downstream ("mainline-derived") variant of the driver currently deployed
to Chrome OS Rockchip systems.

Tested on a Samsung Chromebook Plus (i.e., Rockchip RK3399 Gru Kevin).

Fixes: 6c836d965bad ("drm/rockchip: Use the helpers for PSR")
Cc: <stable@vger.kernel.org>
Cc: Zain Wang <wzz@rock-chips.com>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
CC list is partially constructed from the commit message of the Fixed
commit

 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index b7d2e4449cfa..fbe6eb9df310 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1055,7 +1055,7 @@ static int analogix_dp_disable_psr(struct analogix_dp_device *dp)
 	psr_vsc.db[0] = 0;
 	psr_vsc.db[1] = 0;
 
-	return analogix_dp_send_psr_spd(dp, &psr_vsc, true);
+	return analogix_dp_send_psr_spd(dp, &psr_vsc, false);
 }
 
 /*
-- 
2.33.0.1079.g6e70778dc9-goog

