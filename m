Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE6840E76F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348424AbhIPRcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353249AbhIPRaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:30:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 068E26105A;
        Thu, 16 Sep 2021 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810811;
        bh=0VuDnS1DAK7hb8SAqykRlDJ6nfW5xSYDmzzXZ/RcX50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZj//WcbQ8iht+R9rmyomK3QkfN+iLG5Zr/4Wayq422TvlTS37r7x6qU5EWp0DXx+
         tLQcTdw2yYPXbmLG3RvNhcNKtVyQeZyOTsCpg7m4X2vt5Lq4z/rZgcush/71up7Ah9
         fXhBrLxsNmL+05YYkquAWJZOCSqoyWrcA8qK3ag0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 277/432] drm/msm: mdp4: drop vblank get/put from prepare/complete_commit
Date:   Thu, 16 Sep 2021 18:00:26 +0200
Message-Id: <20210916155820.196697830@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 56bd931ae506730c9ab1e4cc4bfefa43fc2d18fa ]

msm_atomic is doing vblank get/put's already,
currently there no need to duplicate the effort in MDP4

Fix warning:
...
WARNING: CPU: 3 PID: 79 at drivers/gpu/drm/drm_vblank.c:1194 drm_vblank_put+0x1cc/0x1d4
...
and multiple vblank time-outs:
...
msm 5100000.mdp: vblank time out, crtc=1
...

Tested on Nexus 7 2013 (deb), LTS 5.10.50.

Introduced by: 119ecb7fd3b5 ("drm/msm/mdp4: request vblank during modeset")

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210715060925.7880-1-david@ixit.cz
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 0712752742f4..1f12bccee2b8 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -89,13 +89,6 @@ static void mdp4_disable_commit(struct msm_kms *kms)
 
 static void mdp4_prepare_commit(struct msm_kms *kms, struct drm_atomic_state *state)
 {
-	int i;
-	struct drm_crtc *crtc;
-	struct drm_crtc_state *crtc_state;
-
-	/* see 119ecb7fd */
-	for_each_new_crtc_in_state(state, crtc, crtc_state, i)
-		drm_crtc_vblank_get(crtc);
 }
 
 static void mdp4_flush_commit(struct msm_kms *kms, unsigned crtc_mask)
@@ -114,12 +107,6 @@ static void mdp4_wait_flush(struct msm_kms *kms, unsigned crtc_mask)
 
 static void mdp4_complete_commit(struct msm_kms *kms, unsigned crtc_mask)
 {
-	struct mdp4_kms *mdp4_kms = to_mdp4_kms(to_mdp_kms(kms));
-	struct drm_crtc *crtc;
-
-	/* see 119ecb7fd */
-	for_each_crtc_mask(mdp4_kms->dev, crtc, crtc_mask)
-		drm_crtc_vblank_put(crtc);
 }
 
 static long mdp4_round_pixclk(struct msm_kms *kms, unsigned long rate,
-- 
2.30.2



