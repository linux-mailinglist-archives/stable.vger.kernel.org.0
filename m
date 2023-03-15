Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6604E6BB25D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjCOMfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjCOMfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A234340DC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FE16B81DF6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953BBC433EF;
        Wed, 15 Mar 2023 12:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883598;
        bh=apa1y8Q/ns1Gd4XsuRc8riReIyig5E2TJ3PLBC7iJhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCfTy5+DKQXEI5iRe/7D9BKAtP9uXIsoLphWmOPVd6IYpkEmbl+DGZiSk3Y+8JbPU
         97E9Cbu9R9RQKEGMOWHzoPvv4XohmCOvr960ZDTYsAxPF2bgva8MKuWCAXutSQtKhh
         N94jRZQcIF0oXtfroTot1oPHgByo2VM40aXIEJ0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/143] drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register
Date:   Wed, 15 Mar 2023 13:12:26 +0100
Message-Id: <20230315115742.352131205@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a7a4c19c36de1e4b99b06e4060ccc8ab837725bc ]

Rather than writing CP_PREEMPT_ENABLE_GLOBAL twice, follow the vendor
kernel and set CP_PREEMPT_ENABLE_LOCAL register instead. a5xx_submit()
will override it during submission, but let's get the sequence correct.

Fixes: b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/522638/
Link: https://lore.kernel.org/r/20230214020956.164473-2-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 3dcec7acb3840..f8634fbeffda0 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -151,8 +151,8 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	OUT_RING(ring, 1);
 
 	/* Enable local preemption for finegrain preemption */
-	OUT_PKT7(ring, CP_PREEMPT_ENABLE_GLOBAL, 1);
-	OUT_RING(ring, 0x02);
+	OUT_PKT7(ring, CP_PREEMPT_ENABLE_LOCAL, 1);
+	OUT_RING(ring, 0x1);
 
 	/* Allow CP_CONTEXT_SWITCH_YIELD packets in the IB2 */
 	OUT_PKT7(ring, CP_YIELD_ENABLE, 1);
-- 
2.39.2



