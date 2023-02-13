Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4296948E2
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBMOyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBMOyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622221043C
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13207B8125C
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D30C433D2;
        Mon, 13 Feb 2023 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300041;
        bh=yNhaBNpkBy+X/0ebLwxQL2wxf2clS3WJ8h+jXXyC/3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+gZpgAopJewcf9DPAiL7P+mS93CD12RptNklxJXzyEKGSp7ImBQCgE7hHZcmzmUS
         jt/PY9OWH6hXubKJIibu6r9qKs1faIV0Rpm/pSrh8owifwzvj8lAsrQCKnfQ95sAO+
         7Cw1kjQriBEv0CGiHYkl5K7S8aFmJ90DT4uFOKmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/114] drm/i915: Dont do the WM0->WM1 copy w/a if WM1 is already enabled
Date:   Mon, 13 Feb 2023 15:47:51 +0100
Message-Id: <20230213144744.016345273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 90d5e8301ac24550be80d193aa5582cab56c29fc ]

Due to a workaround we have to make sure the WM1 watermarks block/lines
values are sensible even when WM1 is disabled. To that end we copy those
values from WM0.

However since we now keep each wm level enabled on a per-plane basis
it doesn't seem necessary to do that copy when we already have an
enabled WM1 on the current plane. That is, we might be in a situation
where another plane can only do WM0 (and thus needs the copy) but
the current plane's WM1 is still perfectly valid (ie. fits into the
current DDB allocation).

Skipping the copy could avoid reprogramming the plane's registers
needlessly in some cases.

Fixes: a301cb0fca2d ("drm/i915: Keep plane watermarks enabled more aggressively")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230131002127.29305-1-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit c580c2d27ac8754cc6f01da1d715b7272f5f9cbb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 18178b01375e4..a7adf02476f6a 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -1587,7 +1587,8 @@ skl_crtc_allocate_plane_ddb(struct intel_atomic_state *state,
 				skl_check_wm_level(&wm->wm[level], ddb);
 
 			if (icl_need_wm1_wa(i915, plane_id) &&
-			    level == 1 && wm->wm[0].enable) {
+			    level == 1 && !wm->wm[level].enable &&
+			    wm->wm[0].enable) {
 				wm->wm[level].blocks = wm->wm[0].blocks;
 				wm->wm[level].lines = wm->wm[0].lines;
 				wm->wm[level].ignore_lines = wm->wm[0].ignore_lines;
-- 
2.39.0



