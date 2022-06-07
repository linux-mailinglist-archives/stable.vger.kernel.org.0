Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5754065A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344600AbiFGRem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347967AbiFGRb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C248311CB55;
        Tue,  7 Jun 2022 10:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A851B822B0;
        Tue,  7 Jun 2022 17:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFBBC385A5;
        Tue,  7 Jun 2022 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622936;
        bh=2j7o75Snrv7Dgn8DW99eVATPtDQZVnpiMo3Wkpu2h+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkxP9h2pVqObs+2aOi/q7pcMy5/vbNuujNH45b+baRtqY/pTX+ptKP1BO6Z5tDeUq
         +q227GMNB3irO3AYgqOhs6d/T1OzUQTueYI5FLl1O9RfqEoSuex5qvbcZMN3TG9a7M
         RKBVStEGcEyR0Mlg6rkx3hImMb9a4e6k7d0zM59Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/452] drm: msm: fix possible memory leak in mdp5_crtc_cursor_set()
Date:   Tue,  7 Jun 2022 19:01:32 +0200
Message-Id: <20220607164915.563387026@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 06f19ef5dbf3..ff4f207cbdea 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -983,8 +983,10 @@ static int mdp5_crtc_cursor_set(struct drm_crtc *crtc,
 
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



