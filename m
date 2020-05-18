Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537241D8457
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgERSLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732840AbgERSEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587C820715;
        Mon, 18 May 2020 18:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825087;
        bh=FiutH8jg+tuRC8/Eo6Re2MpIXW0t6I7R4ZD2Wfsn7xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6QsPZdHI395g94aBmY+nrMLqB+LPSiDozw9IKTfu0gPj9aGM1lDJ8L7eJZI3Wl4H
         2HsFLduO/jHtdH23IBhbldeqvUksskJ/5wAN8NXQKPp35S6GhH7paO1MAyAb1NOp7A
         f3YZOk3x5gNcrwBP7T9KLgKgNE2p+pdBf0Wos97g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 085/194] drm/i915: Dont enable WaIncreaseLatencyIPCEnabled when IPC is disabled
Date:   Mon, 18 May 2020 19:36:15 +0200
Message-Id: <20200518173538.787800283@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

[ Upstream commit 421abe200321a2c907ede1a6208c558284ba0b75 ]

In commit 5a7d202b1574, a logical AND was erroneously changed to an OR,
causing WaIncreaseLatencyIPCEnabled to be enabled unconditionally for
kabylake and coffeelake, even when IPC is disabled. Fix the logic so
that WaIncreaseLatencyIPCEnabled is only used when IPC is enabled.

Fixes: 5a7d202b1574 ("drm/i915: Drop WaIncreaseLatencyIPCEnabled/1140 for cnl")
Cc: stable@vger.kernel.org # 5.3.x+
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200430214654.51314-1-sultan@kerneltoast.com
(cherry picked from commit 690d22dafa88b82453516387b475664047a6bd14)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index bd2d30ecc030f..53c7b1a1b3551 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4722,7 +4722,7 @@ static void skl_compute_plane_wm(const struct intel_crtc_state *crtc_state,
 	 * WaIncreaseLatencyIPCEnabled: kbl,cfl
 	 * Display WA #1141: kbl,cfl
 	 */
-	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) ||
+	if ((IS_KABYLAKE(dev_priv) || IS_COFFEELAKE(dev_priv)) &&
 	    dev_priv->ipc_enabled)
 		latency += 4;
 
-- 
2.20.1



