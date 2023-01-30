Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977E8680FB8
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbjA3N4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbjA3N4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945F239B8B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CF5061017
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20214C433EF;
        Mon, 30 Jan 2023 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086976;
        bh=4a+QTkMdc0mzJHSgqQaJuAN6fofa782hTTFz+JbDLoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEeGRrWmnMPFWgLfvl1C9v3x1cFYdkXg6f5cFVXHoY5bhlA9Rx2rQ9elUz27qkmIz
         baD24VTgUtHIWrnEV3lRjl5pfKrV+5xihjyZPGC66HtswHoC+CgdSdDwJI12W6y+qu
         y/Q9U+eKCW5LrECXmIPHvYcEM46cJYESOpWnNtZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/313] drm/msm/gpu: Fix potential double-free
Date:   Mon, 30 Jan 2023 14:48:13 +0100
Message-Id: <20230130134339.395561259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit a66f1efcf748febea7758c4c3c8b5bc5294949ef ]

If userspace was calling the MSM_SET_PARAM ioctl on multiple threads to
set the COMM or CMDLINE param, it could trigger a race causing the
previous value to be kfree'd multiple times.  Fix this by serializing on
the gpu lock.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: d4726d770068 ("drm/msm: Add a way to override processes comm/cmdline")
Patchwork: https://patchwork.freedesktop.org/patch/517778/
Link: https://lore.kernel.org/r/20230110212903.1925878-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c |  4 ++++
 drivers/gpu/drm/msm/msm_gpu.c           |  2 ++
 drivers/gpu/drm/msm/msm_gpu.h           | 12 ++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 5a0e8491cd3a..2e7531d2a5d6 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -351,6 +351,8 @@ int adreno_set_param(struct msm_gpu *gpu, struct msm_file_private *ctx,
 		/* Ensure string is null terminated: */
 		str[len] = '\0';
 
+		mutex_lock(&gpu->lock);
+
 		if (param == MSM_PARAM_COMM) {
 			paramp = &ctx->comm;
 		} else {
@@ -360,6 +362,8 @@ int adreno_set_param(struct msm_gpu *gpu, struct msm_file_private *ctx,
 		kfree(*paramp);
 		*paramp = str;
 
+		mutex_unlock(&gpu->lock);
+
 		return 0;
 	}
 	case MSM_PARAM_SYSPROF:
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 021f4e29b613..4f495eecc34b 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -335,6 +335,8 @@ static void get_comm_cmdline(struct msm_gem_submit *submit, char **comm, char **
 	struct msm_file_private *ctx = submit->queue->ctx;
 	struct task_struct *task;
 
+	WARN_ON(!mutex_is_locked(&submit->gpu->lock));
+
 	/* Note that kstrdup will return NULL if argument is NULL: */
 	*comm = kstrdup(ctx->comm, GFP_KERNEL);
 	*cmd  = kstrdup(ctx->cmdline, GFP_KERNEL);
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 58a72e6b1400..a89bfdc3d7f9 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -366,10 +366,18 @@ struct msm_file_private {
 	 */
 	int sysprof;
 
-	/** comm: Overridden task comm, see MSM_PARAM_COMM */
+	/**
+	 * comm: Overridden task comm, see MSM_PARAM_COMM
+	 *
+	 * Accessed under msm_gpu::lock
+	 */
 	char *comm;
 
-	/** cmdline: Overridden task cmdline, see MSM_PARAM_CMDLINE */
+	/**
+	 * cmdline: Overridden task cmdline, see MSM_PARAM_CMDLINE
+	 *
+	 * Accessed under msm_gpu::lock
+	 */
 	char *cmdline;
 
 	/**
-- 
2.39.0



