Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C59411684
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 16:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhITOOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 10:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237435AbhITOOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 10:14:16 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB99BC061764
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 07:12:49 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e15so29929744lfr.10
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 07:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/V7PO4oKi+Cdn3boVLzzbggsDJhCE3vfiLfp0i9c8rA=;
        b=JuQc1D7eggnCJORwmJNKVRhuCGoZrE608OuQeEreGHUosyUeSjKhdov70YzPFDmRge
         BsfU0v9yrOoDCHoepSExTAJsQbbJ1AtekwYK3Cj31xc850uEuYHsL/WI6nUVj4RdKd5k
         Tl0KQyQeoBqeG+aMQ9vmSc1Np4p245bj1ALUQF/Z5vwxSH/G+vMuQO/WN2Oi3hJ65EA9
         1ehEIevF8wNc+M4IT4+xRjQ0pcEwy+8dpbRGcRIpYWEq0iOI5iQqwAog+ae4CsOkgeTV
         zxjtEVgie3Si+z/wGD8iiMQAQv+JoxNSXGHYiDNxuVghWQwG0qqontIfVMLA0jUSBfVp
         1a3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/V7PO4oKi+Cdn3boVLzzbggsDJhCE3vfiLfp0i9c8rA=;
        b=Ncod5OhG2h7egzFdLwys43Yyxqk/z30bsSVhJ411k9RskhMDYmqbAEDhZkF+Q7qEzi
         FObvdwgfksQSoMF0N2VkZhfQpwHTdUPjjUXYrkhtHCtKyc61hqGvu/za9XrKSObbMFuB
         fG9SSbpw/6pBUbXs3BbRvyQsWJ5MQUTgq+hwUCwKMlecye8gbGFGNvuypoUVeTrtR/4p
         nHxtblKp9/Nvbarka6I1pRRoqkXHJJxIufsWkppgBpO4vRZOyFI7w8KaZq3brt6J0Vko
         2E/xrv0Mudcx4KKZkcmoveDJHhYC9h4aKF6PO8N98TEMFY7GFvRBp+JF+x5UVlJbqM9N
         k3sg==
X-Gm-Message-State: AOAM531mjj/c/2klhpmjc3teKkeZYQ7slB5+6KsSc9zUZQp7SxISsue9
        YHhwcfXW4OsFJCNR2Ww9Zen+zA==
X-Google-Smtp-Source: ABdhPJw3fSrrEgjePCdoFq/02ePMQn26eyLTxe8tnNccEoy/DKbaqGEAhKjOZq/GbDQMuJEKrGiUtg==
X-Received: by 2002:a05:6512:118c:: with SMTP id g12mr18941294lfr.143.1632147091114;
        Mon, 20 Sep 2021 07:11:31 -0700 (PDT)
Received: from lmajczak1-l.roam.corp.google.com ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id a6sm1389505lfs.160.2021.09.20.07.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:11:30 -0700 (PDT)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Jose Roberto de Souza <jose.souza@intel.com>,
        Shawn C Lee <shawn.c.lee@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        upstream@semihalf.com, Lukasz Majczak <lma@semihalf.com>,
        stable@vger.kernel.org
Subject: [PATCH v1] drm/i915/bdb: Fix version check
Date:   Mon, 20 Sep 2021 16:11:01 +0200
Message-Id: <20210920141101.194959-1-lma@semihalf.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With patch "drm/i915/vbt: Fix backlight parsing for VBT 234+"
the size of bdb_lfp_backlight_data structure has been increased,
causing if-statement in the parse_lfp_backlight function
that comapres this structure size to the one retrieved from BDB,
always to fail for older revisions.
This patch fixes it by comparing a total size of all fileds from
the structure (present before the change) with the value gathered from BDB.
Tested on Chromebook Pixelbook (Nocturne) (reports bdb->version = 221)

Cc: <stable@vger.kernel.org> # 5.4+
Tested-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
---
 drivers/gpu/drm/i915/display/intel_bios.c     | 4 +++-
 drivers/gpu/drm/i915/display/intel_vbt_defs.h | 5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 3c25926092de..052a19b455d1 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -452,7 +452,9 @@ parse_lfp_backlight(struct drm_i915_private *i915,
 
 	i915->vbt.backlight.type = INTEL_BACKLIGHT_DISPLAY_DDI;
 	if (bdb->version >= 191 &&
-	    get_blocksize(backlight_data) >= sizeof(*backlight_data)) {
+	    get_blocksize(backlight_data) >= (sizeof(backlight_data->entry_size) +
+					      sizeof(backlight_data->data) +
+					      sizeof(backlight_data->level))) {
 		const struct lfp_backlight_control_method *method;
 
 		method = &backlight_data->backlight_control[panel_type];
diff --git a/drivers/gpu/drm/i915/display/intel_vbt_defs.h b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
index 330077c2e588..fff456bf8783 100644
--- a/drivers/gpu/drm/i915/display/intel_vbt_defs.h
+++ b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
@@ -814,6 +814,11 @@ struct lfp_brightness_level {
 	u16 reserved;
 } __packed;
 
+/*
+ * Changing struct bdb_lfp_backlight_data might affect its
+ * size comparation to the value hold in BDB.
+ * (e.g. in parse_lfp_backlight())
+ */
 struct bdb_lfp_backlight_data {
 	u8 entry_size;
 	struct lfp_backlight_data_entry data[16];
-- 
2.33.0.464.g1972c5931b-goog

