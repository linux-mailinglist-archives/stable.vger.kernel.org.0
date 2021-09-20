Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54D34122E1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346180AbhITSS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359090AbhITSQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E870063298;
        Mon, 20 Sep 2021 17:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158538;
        bh=p2nrOskp0iRRoTcoMNP5Dms5l6f8VGcORY2JUqOtx0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYwYc0YTk9gEzI3l88Xgj8H64hFmSJWJRd5sVeDdmTFvrtjA0tCtfyxzUS0EK52+u
         7LLfLIpJKCQ1E0aU0+xfx/6S1tnh2pkNAFC00WvXBgS9JeqzEDLW1nyYPp0+nfb92M
         Mpr+G0dhG1WssUdTE7c1kJYhaZwRO9oUk0q1xlRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.4 203/260] drm/etnaviv: exec and MMU state is lost when resetting the GPU
Date:   Mon, 20 Sep 2021 18:43:41 +0200
Message-Id: <20210920163938.008762974@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 725cbc7884c37f3b4f1777bc1aea6432cded8ca5 upstream.

When the GPU is reset both the current exec state, as well as all MMU
state is lost. Move the driver side state tracking into the reset function
to keep hardware and software state from diverging.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -546,6 +546,8 @@ static int etnaviv_hw_reset(struct etnav
 	etnaviv_gpu_update_clock(gpu);
 
 	gpu->fe_running = false;
+	gpu->exec_state = -1;
+	gpu->mmu_context = NULL;
 
 	return 0;
 }
@@ -794,7 +796,6 @@ int etnaviv_gpu_init(struct etnaviv_gpu
 	/* Now program the hardware */
 	mutex_lock(&gpu->lock);
 	etnaviv_gpu_hw_init(gpu);
-	gpu->exec_state = -1;
 	mutex_unlock(&gpu->lock);
 
 	pm_runtime_mark_last_busy(gpu->dev);
@@ -998,8 +999,6 @@ void etnaviv_gpu_recover_hang(struct etn
 	spin_unlock(&gpu->event_spinlock);
 
 	etnaviv_gpu_hw_init(gpu);
-	gpu->exec_state = -1;
-	gpu->mmu_context = NULL;
 
 	mutex_unlock(&gpu->lock);
 	pm_runtime_mark_last_busy(gpu->dev);


