Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD606BB2D8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjCOMjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbjCOMis (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F88A3365
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2934CE19A2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9470AC4339B;
        Wed, 15 Mar 2023 12:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883863;
        bh=IohtKqLRilYWkcYcudSd0DdnkxCkv7AVf3kq+n9sKxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yqJdCexBCxU+MkxEEPcmhyk5HrJjlkSodhYxdsMWWUhOAwRbcp0yK6yLiFtI9JqVY
         Qdek9/dIwTxyE/hp/c39xrZKWBR+3wPa7MA/VqjHueVhtq0X9zm9CcMotUsu6S99oG
         LWuEVBSFY8+xRELP3kVmaW3ZcDhsMXmPwvlnTQ+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.2 017/141] drm/msm/adreno: fix runtime PM imbalance at unbind
Date:   Wed, 15 Mar 2023 13:12:00 +0100
Message-Id: <20230315115740.516209221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 6153c44392b04ff2da1e9aa82ba87da9ab9a0fc1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -558,7 +558,8 @@ static void adreno_unbind(struct device
 	struct msm_drm_private *priv = dev_get_drvdata(master);
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 
-	WARN_ON_ONCE(adreno_system_suspend(dev));
+	if (pm_runtime_enabled(dev))
+		WARN_ON_ONCE(adreno_system_suspend(dev));
 	gpu->funcs->destroy(gpu);
 
 	priv->gpu_pdev = NULL;


