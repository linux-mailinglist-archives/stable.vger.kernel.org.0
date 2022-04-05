Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E157C4F2A28
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbiDEJiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244191AbiDEJJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBCB33E;
        Tue,  5 Apr 2022 01:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4D5061003;
        Tue,  5 Apr 2022 08:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8FCC385A1;
        Tue,  5 Apr 2022 08:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149136;
        bh=DGLMwc0aKxz+FQqD2YEpG77UF0UGtPZkVPr4ju27lBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KykZsF+XePv5y6f7PS6tSylgzGK6pofc2clvbG4oxGLtMMlm0redtFrJWRiDw7Qdo
         GRoL7SkQ1qzXdCp1Tcn0tbdCDMXrwJS/Z/FckRVUM1dxMsFGopyrwZQDmCgDZy67hC
         waL/XEkdiq2ttVmzD2dwmYiy56DksPopJL+0URYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Khaled Almahallawy <khaled.almahallawy@intel.com>,
        Charlton Lin <charlton.lin@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0608/1017] drm/i915/display: Do not re-enable PSR after it was marked as not reliable
Date:   Tue,  5 Apr 2022 09:25:21 +0200
Message-Id: <20220405070412.327169580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit 278da06c03655c2bb9bc36ebdf45b90a079b3bfd ]

If a error happens and sink_not_reliable is set, PSR should be disabled
for good but that is not happening.
It would be disabled by the function handling the PSR error but then
on the next fastset it would be enabled again in
_intel_psr_post_plane_update().
It would only be disabled for good in the next modeset where has_psr
will be set false.

v2:
- release psr lock before continue

Fixes: 9ce5884e5139 ("drm/i915/display: Only keep PSR enabled if there is active planes")
Reported-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reported-by: Charlton Lin <charlton.lin@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220311185149.110527-2-jose.souza@intel.com
(cherry picked from commit 15f26bdc81f7f03561aaea5a10d87bd6638e1459)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 3ba8b717e176..f7ade9c06386 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1793,6 +1793,9 @@ static void _intel_psr_post_plane_update(const struct intel_atomic_state *state,
 
 		mutex_lock(&psr->lock);
 
+		if (psr->sink_not_reliable)
+			goto exit;
+
 		drm_WARN_ON(&dev_priv->drm, psr->enabled && !crtc_state->active_planes);
 
 		/* Only enable if there is active planes */
@@ -1803,6 +1806,7 @@ static void _intel_psr_post_plane_update(const struct intel_atomic_state *state,
 		if (crtc_state->crc_enabled && psr->enabled)
 			psr_force_hw_tracking_exit(intel_dp);
 
+exit:
 		mutex_unlock(&psr->lock);
 	}
 }
-- 
2.34.1



