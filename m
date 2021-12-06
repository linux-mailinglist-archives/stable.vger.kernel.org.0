Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF058469BE1
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359312AbhLFPRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349052AbhLFPNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:13:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49582B810E7;
        Mon,  6 Dec 2021 15:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C4BC341C2;
        Mon,  6 Dec 2021 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803421;
        bh=xMOzHqDdSi1YHqpq/z02+iNcFFwZGMKPqB1DAsbBxkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX0X1ERXVwzP99NDzYLSgG5jTEIG4NTn6MjN7jYGWUfxI3ULu4D0P7RAKX2RbofCg
         THfOvIID07kThb3GJpc3+5IvRPuKasQr2Q+OzgUzxjpND1DCY07lvCT5cZKIxYUpCQ
         uG+nDoLp7Ml4I+uhF6ydv5+yVrdwxdDm6Wy7TENg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>
Subject: [PATCH 4.19 36/48] drm/msm: Do hw_init() before capturing GPU state
Date:   Mon,  6 Dec 2021 15:56:53 +0100
Message-Id: <20211206145550.070591236@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
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
@@ -83,6 +83,7 @@ static int msm_gpu_open(struct inode *in
 		goto free_priv;
 
 	pm_runtime_get_sync(&gpu->pdev->dev);
+	msm_gpu_hw_init(gpu);
 	show_priv->state = gpu->funcs->gpu_state_get(gpu);
 	pm_runtime_put_sync(&gpu->pdev->dev);
 


