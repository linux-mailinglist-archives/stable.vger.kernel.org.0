Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3855C894
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiF0Lic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbiF0Lhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D08B64D1;
        Mon, 27 Jun 2022 04:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF62B8111D;
        Mon, 27 Jun 2022 11:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CFFC341C7;
        Mon, 27 Jun 2022 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329636;
        bh=zX/ShIUBNHcR9fNf0IX5Z2WYk4YDcYfU4+kcHHO4VZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDC83v6GUrJbsa6YIMGRtBei5x5yOgz2iBbxcmu+/9LfOdoE97IQ6iLxqz31cItCA
         MVEdg1KwaIYUxfyeCMRblU+Yjvp9eoZj2Npfmqg4h/uH0x6CEdE560O4mzxtIPyWtJ
         2GTLR5njwSm1KMiVVr3yO/TlxeTu0cYoTT1KJ6n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/135] drm/msm: Switch ordering of runpm put vs devfreq_idle
Date:   Mon, 27 Jun 2022 13:20:44 +0200
Message-Id: <20220627111939.235945076@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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
index 2c46cd968ac4..b01d0a521c90 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -658,7 +658,6 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 	msm_submit_retire(submit);
 
 	pm_runtime_mark_last_busy(&gpu->pdev->dev);
-	pm_runtime_put_autosuspend(&gpu->pdev->dev);
 
 	spin_lock_irqsave(&ring->submit_lock, flags);
 	list_del(&submit->node);
@@ -672,6 +671,8 @@ static void retire_submit(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 		msm_devfreq_idle(gpu);
 	mutex_unlock(&gpu->active_lock);
 
+	pm_runtime_put_autosuspend(&gpu->pdev->dev);
+
 	msm_gem_submit_put(submit);
 }
 
-- 
2.35.1



