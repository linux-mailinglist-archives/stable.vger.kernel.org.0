Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0642412531
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382749AbhITSmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382296AbhITSkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C909863337;
        Mon, 20 Sep 2021 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159055;
        bh=9A8ZX1RVAc+j25h7pZFOtT9Q7NIQTF4XHDRkB2r3/V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRMpxHI1pAMQaIO4pGnX7arc0ySGsiM8fTN1MwKd6qIzfktDniI0Z2/dTkBNLLsqE
         irsZCErald77L9GxL1nm7P+lrW7eM+jbGF/8SNE3EAfWTW5yr3v2b75j93O9oVWtNl
         8WtIH32Akhth7RmcqcOrErdIQTZ8N/mr5KlAiwkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.14 028/168] drm/etnaviv: exec and MMU state is lost when resetting the GPU
Date:   Mon, 20 Sep 2021 18:42:46 +0200
Message-Id: <20210920163922.573728379@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -570,6 +570,8 @@ static int etnaviv_hw_reset(struct etnav
 	etnaviv_gpu_update_clock(gpu);
 
 	gpu->fe_running = false;
+	gpu->exec_state = -1;
+	gpu->mmu_context = NULL;
 
 	return 0;
 }
@@ -830,7 +832,6 @@ int etnaviv_gpu_init(struct etnaviv_gpu
 	/* Now program the hardware */
 	mutex_lock(&gpu->lock);
 	etnaviv_gpu_hw_init(gpu);
-	gpu->exec_state = -1;
 	mutex_unlock(&gpu->lock);
 
 	pm_runtime_mark_last_busy(gpu->dev);
@@ -1055,8 +1056,6 @@ void etnaviv_gpu_recover_hang(struct etn
 	spin_unlock(&gpu->event_spinlock);
 
 	etnaviv_gpu_hw_init(gpu);
-	gpu->exec_state = -1;
-	gpu->mmu_context = NULL;
 
 	mutex_unlock(&gpu->lock);
 	pm_runtime_mark_last_busy(gpu->dev);


