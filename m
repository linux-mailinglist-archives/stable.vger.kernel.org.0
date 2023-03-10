Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1EE6B4546
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjCJOcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjCJOcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78CE121408
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 191AA618C9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFB0C433D2;
        Fri, 10 Mar 2023 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458678;
        bh=jTLgpo7gljTulJEX9xVYN2mnfeaDVRdWJVjaRYNTPfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7kcYXXlpoKhR1mT+3CtQ3JCz2iFV1MLfWl/zBFkx+ir/HOT8jziii6uQkJap/DQD
         3fjC3dWpEo/FlRoLbbonTHGkK9ijRn4pS6r/65APwlfUii2fcNo24leZMVE3lRXGsq
         lVnBy1pYreBDHxmOvqDin29u/FifawvZUSSzJSB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/357] drm/msm/dpu: Add check for cstate
Date:   Fri, 10 Mar 2023 14:36:37 +0100
Message-Id: <20230310133739.410666686@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit c96988b7d99327bb08bd9efd29a203b22cd88ace ]

As kzalloc may fail and return NULL pointer,
it should be better to check cstate
in order to avoid the NULL pointer dereference
in __drm_atomic_helper_crtc_reset.

Fixes: 1cff7440a86e ("drm/msm: Convert to using __drm_atomic_helper_crtc_reset() for reset.")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/514163/
Link: https://lore.kernel.org/r/20221206080517.43786-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 4aed5e9a84a45..d61c3855670dd 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -651,7 +651,10 @@ static void dpu_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		dpu_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	if (cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 /**
-- 
2.39.2



