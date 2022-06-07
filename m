Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB1B541484
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358779AbiFGUSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376309AbiFGUQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:16:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AD41CD34D;
        Tue,  7 Jun 2022 11:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C976EB81FF8;
        Tue,  7 Jun 2022 18:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229C0C385A2;
        Tue,  7 Jun 2022 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626534;
        bh=FYj3e4Dru2Jo9FvmGlnE8Gi8G7I9SD2Vl7ijBLyRvuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugG3kkip3gzK0sPobLafisVxqfVxI6qP4ev6y8vU2svM5hj+Zr+Ped2u094D1p23P
         pU/nAJGmxy1QJEH0zB27Wn5ENs+AmLrNQK0Q1SuJWqEJhO5iFNub5wQUDlvkWQoR1M
         PXDcORIBmJxPTC7UPukIySswUbCSWXIh/AZD/z2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 412/772] drm: msm: fix possible memory leak in mdp5_crtc_cursor_set()
Date:   Tue,  7 Jun 2022 19:00:04 +0200
Message-Id: <20220607165001.146947224@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 947a844bb3ebff0f4736d244d792ce129f6700d7 ]

drm_gem_object_lookup will call drm_gem_object_get inside. So cursor_bo
needs to be put when msm_gem_get_and_pin_iova fails.

Fixes: e172d10a9c4a ("drm/msm/mdp5: Add hardware cursor support")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220509061125.18585-1-hbh25y@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index 477cda4ec23b..0e02e252ff89 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -989,8 +989,10 @@ static int mdp5_crtc_cursor_set(struct drm_crtc *crtc,
 
 	ret = msm_gem_get_and_pin_iova(cursor_bo, kms->aspace,
 			&mdp5_crtc->cursor.iova);
-	if (ret)
+	if (ret) {
+		drm_gem_object_put(cursor_bo);
 		return -EINVAL;
+	}
 
 	pm_runtime_get_sync(&pdev->dev);
 
-- 
2.35.1



