Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6516B7454
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCMKky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCMKkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:40:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9176A1708
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 03:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3437CE0ED9
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 10:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9631DC433A0;
        Mon, 13 Mar 2023 10:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678704046;
        bh=t92TyBYbq8jLcGbwovuJbnUa8fNVFdaHk/veFO0SiAA=;
        h=Subject:To:Cc:From:Date:From;
        b=lLPOxjr4tYWoQneFHHpXLEfiJx/MGNd2pP9LAmMlkAuXNyXV65TS6/+hcoZemXymz
         Y5L0XCXbj+U0retUQt3U3T9hDhI0czvmhNNWRnHARv7qegcaH7S3Ct6gUGObOpFsxX
         Ot+1tS9U7Hro0wH5/RRpElpL83V2ChN9eaZoN5/k=
Subject: FAILED: patch "[PATCH] drm/msm/adreno: fix runtime PM imbalance at unbind" failed to apply to 6.1-stable tree
To:     johan+linaro@kernel.org, quic_bjorande@quicinc.com,
        robdclark@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Mar 2023 11:40:44 +0100
Message-ID: <1678704044222230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 6153c44392b04ff2da1e9aa82ba87da9ab9a0fc1
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678704044222230@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

6153c44392b0 ("drm/msm/adreno: fix runtime PM imbalance at unbind")
e752e5454e64 ("adreno: Shutdown the GPU properly")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6153c44392b04ff2da1e9aa82ba87da9ab9a0fc1 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Tue, 21 Feb 2023 11:14:27 +0100
Subject: [PATCH] drm/msm/adreno: fix runtime PM imbalance at unbind

A recent commit moved enabling of runtime PM from adreno_gpu_init() to
adreno_load_gpu() (called on first open()), which means that unbind()
may now be called with runtime PM disabled in case the device was never
opened in between.

Make sure to only forcibly suspend and disable runtime PM at unbind() in
case runtime PM has been enabled to prevent a disable count imbalance.

This specifically avoids leaving runtime PM disabled when the device
is later opened after a successful bind:

	msm_dpu ae01000.display-controller: [drm:adreno_load_gpu [msm]] *ERROR* Couldn't power up the GPU: -13

Fixes: 4b18299b3365 ("drm/msm/adreno: Defer enabling runpm until hw_init()")
Reported-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/lkml/20230203181245.3523937-1-quic_bjorande@quicinc.com
Cc: stable@vger.kernel.org	# 6.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/523549/
Link: https://lore.kernel.org/r/20230221101430.14546-2-johan+linaro@kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 36f062c7582f..c5c4c93b3689 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -558,7 +558,8 @@ static void adreno_unbind(struct device *dev, struct device *master,
 	struct msm_drm_private *priv = dev_get_drvdata(master);
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 
-	WARN_ON_ONCE(adreno_system_suspend(dev));
+	if (pm_runtime_enabled(dev))
+		WARN_ON_ONCE(adreno_system_suspend(dev));
 	gpu->funcs->destroy(gpu);
 
 	priv->gpu_pdev = NULL;

