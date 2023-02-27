Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF6C6A36A2
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjB0CD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjB0CDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:03:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF64117CEF;
        Sun, 26 Feb 2023 18:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A053CE0F30;
        Mon, 27 Feb 2023 02:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC92C4339E;
        Mon, 27 Feb 2023 02:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463355;
        bh=Ewv5WwPQXNomcPfjqEAlk2GqZYo6lwOY7Yo9cJrazj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+HV99uLuQtHfiKdR0rWSrf+ONx/3avDbfppCeNNOagAs098vGIXsp4SVZU2PfTFN
         ehdGg6mPIdj0kIZCwBx2k+43TAgB3cY4Q0TqHMRqNfU/bYFG3nt6J9bpgO/SIY5zQN
         sgwYVNQ7aJ8weupMbptx3xpsVN3G9RRxaH9waXwbQW4N6GGdIoZwhLRAEaKxHlh9y2
         ffcZWSvFu7dQ0wBcOTI7m7PYTpWDgsXbc2m52ehxQA84OeAlUVQ/W0ptMv6hEFPcgP
         /PITut+Z3JRb2Y/eSqR9A1X45jQrzDmlZ9i+2yDn6l8hjNbF2BcBECp39DeFXkm/+l
         Q1lwxUY/lGHoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Lyude Paul <lyude@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 27/60] drm/drm_print: correct format problem
Date:   Sun, 26 Feb 2023 21:00:12 -0500
Message-Id: <20230227020045.1045105-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit d987150b539271b0394f24c1c648d2846662adb4 ]

[why & how]
__drm_dbg() parameter set format is wrong and not aligned with the
format under CONFIG_DRM_USE_DYNAMIC_DEBUG is on. Fix it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_print.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_print.h b/include/drm/drm_print.h
index a44fb7ef257f6..094ded23534c7 100644
--- a/include/drm/drm_print.h
+++ b/include/drm/drm_print.h
@@ -521,7 +521,7 @@ __printf(1, 2)
 void __drm_err(const char *format, ...);
 
 #if !defined(CONFIG_DRM_USE_DYNAMIC_DEBUG)
-#define __drm_dbg(fmt, ...)		___drm_dbg(NULL, fmt, ##__VA_ARGS__)
+#define __drm_dbg(cat, fmt, ...)		___drm_dbg(NULL, cat, fmt, ##__VA_ARGS__)
 #else
 #define __drm_dbg(cat, fmt, ...)					\
 	_dynamic_func_call_cls(cat, fmt, ___drm_dbg,			\
-- 
2.39.0

