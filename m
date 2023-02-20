Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA96069CE81
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjBTN7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjBTN7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:59:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DE91F4B4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A9DB80D49
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119BEC433EF;
        Mon, 20 Feb 2023 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901525;
        bh=jsi0axqrZFCbYs/Gy4DKCjVDjXOMtMdpeqjk7VGK0JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwDo8qZXVV+j1KrjS6x4OaYAJDoKlbbAred6Xqo2xFVkOlhU11FktpxES4Vn794Me
         Hd6BljDHf5Z7yTRDg54bVZiA8lO/cP58HR+mrweJpnr9BqOlz+EC+qonvq+JuFi786
         QQvkgEaTh5vbqr+/kSbieNOoOlMxd5VVdSsdFy2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Cromie <jim.cromie@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Maxime Ripard <maxime@cerno.tech>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 050/118] drm: Disable dynamic debug as broken
Date:   Mon, 20 Feb 2023 14:36:06 +0100
Message-Id: <20230220133602.450259586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit bb2ff6c27bc9e1da4d3ec5e7b1d6b9df1092cb5a upstream.

CONFIG_DRM_USE_DYNAMIC_DEBUG breaks debug prints for (at least modular)
drm drivers. The debug prints can be reinstated by manually frobbing
/sys/module/drm/parameters/debug after the fact, but at that point the
damage is done and all debugs from driver probe are lost. This makes
drivers totally undebuggable.

There's a more complete fix in progress [1], with further details, but
we need this fixed in stable kernels. Mark the feature as broken and
disable it by default, with hopes distros follow suit and disable it as
well.

[1] https://lore.kernel.org/r/20230125203743.564009-1-jim.cromie@gmail.com

Fixes: 84ec67288c10 ("drm_print: wrap drm_*_dbg in dyndbg descriptor factory macro")
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Jim Cromie <jim.cromie@gmail.com>
Acked-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230207143337.2126678-1-jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 315cbdf61979..9abfb482b615 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -53,7 +53,8 @@ config DRM_DEBUG_MM
 
 config DRM_USE_DYNAMIC_DEBUG
 	bool "use dynamic debug to implement drm.debug"
-	default y
+	default n
+	depends on BROKEN
 	depends on DRM
 	depends on DYNAMIC_DEBUG || DYNAMIC_DEBUG_CORE
 	depends on JUMP_LABEL
-- 
2.39.1



