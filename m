Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B1C4F34A7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242161AbiDEIhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239038AbiDEITo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5601A75E6D;
        Tue,  5 Apr 2022 01:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46588B81A32;
        Tue,  5 Apr 2022 08:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82191C385A1;
        Tue,  5 Apr 2022 08:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146201;
        bh=40R9kc5aBeoKOIfKNAfHBDLpStxymn0Zg5mTScWioOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcUWbMk5AX0W6L7wXYL8IKTQjcUJq05un+KZO0G+dNtXXlyoBFY3S6qA62tWYBinI
         6kTLCkw2qGXOKayynDmQuiIldf9vhice1jlQWkaFhBjo72hcAkYsaitsB/KoYBK9nw
         x9WeQaVuY5B7bETAKWfrZz2IWFunGssJ0H4WKhK4=
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
Subject: [PATCH 5.17 0672/1126] drm/i915/display: Do not re-enable PSR after it was marked as not reliable
Date:   Tue,  5 Apr 2022 09:23:39 +0200
Message-Id: <20220405070427.351205777@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 00279e8c2775..b00de57cc957 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1816,6 +1816,9 @@ static void _intel_psr_post_plane_update(const struct intel_atomic_state *state,
 
 		mutex_lock(&psr->lock);
 
+		if (psr->sink_not_reliable)
+			goto exit;
+
 		drm_WARN_ON(&dev_priv->drm, psr->enabled && !crtc_state->active_planes);
 
 		/* Only enable if there is active planes */
@@ -1826,6 +1829,7 @@ static void _intel_psr_post_plane_update(const struct intel_atomic_state *state,
 		if (crtc_state->crc_enabled && psr->enabled)
 			psr_force_hw_tracking_exit(intel_dp);
 
+exit:
 		mutex_unlock(&psr->lock);
 	}
 }
-- 
2.34.1



