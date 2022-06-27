Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C0E55DFCF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237951AbiF0LtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbiF0LsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31825BE00;
        Mon, 27 Jun 2022 04:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C14611BB;
        Mon, 27 Jun 2022 11:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE179C341CF;
        Mon, 27 Jun 2022 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330010;
        bh=NiBFSxYw9p6awrk2HMjxUuocnzIhb19bIwy+ia+nCtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPHn51Hpk4lpYunDyAhgFi9WVmc1vTTojRmOcBmnPTuzBTy47fQwyu4k+ARRdj+Me
         fGjDWOrZ5YwOCy8c0WVsRXduLYASr0lodHJQyJlalNVKn1pf0mtO75g35VKGZd21hb
         rSM2DnTX1q1rPkK49zqWpIkKLv+MEGOrCe7UV120=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 046/181] drm/msm: Switch ordering of runpm put vs devfreq_idle
Date:   Mon, 27 Jun 2022 13:20:19 +0200
Message-Id: <20220627111945.898166864@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 49e477610087a02c3604061b8f3ee3a25a493987 ]

In msm_devfreq_suspend() we cancel idle_work synchronously so that it
doesn't run after we power of the hw or in the resume path.  But this
means that we want to ensure that idle_work is not scheduled *after* we
no longer hold a runpm ref.  So switch the ordering of pm_runtime_put()
vs msm_devfreq_idle().

v2. Only move the runpm _put_autosuspend, and not the _mark_last_busy()

Fixes: 9bc95570175a ("drm/msm: Devfreq tuning")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20210927152928.831245-1-robdclark@gmail.com
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220608161334.2140611-1-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 58eb3e1662cb..7d27d7cee688 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -664,7 +664,6 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 	msm_submit_retire(submit);
 
 	pm_runtime_mark_last_busy(&gpu->pdev->dev);
-	pm_runtime_put_autosuspend(&gpu->pdev->dev);
 
 	spin_lock_irqsave(&ring->submit_lock, flags);
 	list_del(&submit->node);
@@ -678,6 +677,8 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 		msm_devfreq_idle(gpu);
 	mutex_unlock(&gpu->active_lock);
 
+	pm_runtime_put_autosuspend(&gpu->pdev->dev);
+
 	msm_gem_submit_put(submit);
 }
 
-- 
2.35.1



