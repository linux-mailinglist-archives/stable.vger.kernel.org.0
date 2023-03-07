Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F376AEEE8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjCGSR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjCGSRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6595899C20
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:12:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F6BB819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD61C433EF;
        Tue,  7 Mar 2023 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212751;
        bh=UJdJdIk1sbDwHocVvrQhW3rwSxtZnabYMIcExhU07Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9BR7J4P4x1jShhhSWDVnCU6vkuE7XoKjjkYUqPfARmyMcU8OBPhwGNcY2/UFrxow
         ayOKTZZ+Wnl418ZTERqVKYtYQ1y63v0WbarjnhPdfuuqw89fh0W1OoJCJFj9QyL3Tm
         7mNS5jSNfTM9sNLf0b7w2rv6U9C8ygdaQPr0yEhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/885] drm/msm: clean event_thread->worker in case of an error
Date:   Tue,  7 Mar 2023 17:53:40 +0100
Message-Id: <20230307170014.459683089@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c79bb6b92defdcb834ceeeed9c1cf591beb1b71a ]

If worker creation fails, nullify the event_thread->worker, so that
msm_drm_uninit() doesn't try accessing invalid memory location. While we
are at it, remove duplicate assignment to the ret variable.

Fixes: 1041dee2178f ("drm/msm: use kthread_create_worker instead of kthread_run")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/490106/
Link: https://lore.kernel.org/r/20220617233328.1143665-2-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 681c1b889b31a..5a0ff112634b7 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -494,7 +494,7 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 		if (IS_ERR(priv->event_thread[i].worker)) {
 			ret = PTR_ERR(priv->event_thread[i].worker);
 			DRM_DEV_ERROR(dev, "failed to create crtc_event kthread\n");
-			ret = PTR_ERR(priv->event_thread[i].worker);
+			priv->event_thread[i].worker = NULL;
 			goto err_msm_uninit;
 		}
 
-- 
2.39.2



