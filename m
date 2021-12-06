Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6CB469EE4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbhLFPom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390545AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932D2C0698D5;
        Mon,  6 Dec 2021 07:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A99EB81116;
        Mon,  6 Dec 2021 15:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E859C34901;
        Mon,  6 Dec 2021 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804490;
        bh=LBiaArAi+dUPbDDMDgK0e4u4wpKzk8/elD9OeB/XVsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQesZQ6H+RaNtphVLBdi2iBUr4UlIVlmIIFIR1tX1wTw2UeU9ew1/mzKgUEK/I7pJ
         SQdAi63jcYhqx+QQNzlRziBXJt6x4U9kab3qcCNiT2AvssT0ny98M15dXB7wNMpX3W
         yKoKYkkX+jpSzHk3aFzfq0nWYftOlBnwPKVIwyC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.15 138/207] drm/msm: Do hw_init() before capturing GPU state
Date:   Mon,  6 Dec 2021 15:56:32 +0100
Message-Id: <20211206145615.004679060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

commit e4840d537c2c6b1189d4de16ee0f4820e069dcea upstream.

In particular, we need to ensure all the necessary blocks are switched
to 64b mode (a5xx+) otherwise the high bits of the address of the BO to
snapshot state into will be ignored, resulting in:

  *** gpu fault: ttbr0=0000000000000000 iova=0000000000012000 dir=READ type=TRANSLATION source=CP (0,0,0,0)
  platform 506a000.gmu: [drm:a6xx_gmu_set_oob] *ERROR* Timeout waiting for GMU OOB set BOOT_SLUMBER: 0x0

Fixes: 4f776f4511c7 ("drm/msm/gpu: Convert the GPU show function to use the GPU state")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20211108180122.487859-1-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/msm/msm_debugfs.c
+++ b/drivers/gpu/drm/msm/msm_debugfs.c
@@ -77,6 +77,7 @@ static int msm_gpu_open(struct inode *in
 		goto free_priv;
 
 	pm_runtime_get_sync(&gpu->pdev->dev);
+	msm_gpu_hw_init(gpu);
 	show_priv->state = gpu->funcs->gpu_state_get(gpu);
 	pm_runtime_put_sync(&gpu->pdev->dev);
 


