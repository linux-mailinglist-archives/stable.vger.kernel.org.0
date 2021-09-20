Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D82E412507
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353474AbhITSlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381716AbhITSjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:39:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 064FE61AD1;
        Mon, 20 Sep 2021 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159031;
        bh=mnOLopWbem00e/FXaoiBru+k6HvVV2yFyy7ukuUgUuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3p7JQdwFoy7wFmBoctWER1PBj4nyPTkKxhWbc3vLgTvYXqkK4CypNbY8e0bW3OqG
         CPhr1qX2Po9g7r+BlP1uGyMnVuBgInTPaAPzgRSetXs91un+5vsFbFAW7nYWF+U7x7
         3dvQ2WdEHEqjtAcK/WMGICML4wjFTiUenaKw9PoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.14 027/168] drm/etnaviv: keep MMU context across runtime suspend/resume
Date:   Mon, 20 Sep 2021 18:42:45 +0200
Message-Id: <20210920163922.541113086@linuxfoundation.org>
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

commit 8f3eea9d01d7b0f95b0fe04187c0059019ada85b upstream.

The MMU state may be kept across a runtime suspend/resume cycle, as we
avoid a full hardware reset to keep the latency of the runtime PM small.

Don't pretend that the MMU state is lost in driver state. The MMU
context is pushed out when new HW jobs with a different context are
coming in. The only exception to this is when the GPU is unbound, in
which case we need to make sure to also free the last active context.

Cc: stable@vger.kernel.org # 5.4
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1590,9 +1590,6 @@ static int etnaviv_gpu_hw_suspend(struct
 		 */
 		etnaviv_gpu_wait_idle(gpu, 100);
 
-		etnaviv_iommu_context_put(gpu->mmu_context);
-		gpu->mmu_context = NULL;
-
 		gpu->fe_running = false;
 	}
 
@@ -1741,6 +1738,9 @@ static void etnaviv_gpu_unbind(struct de
 	etnaviv_gpu_hw_suspend(gpu);
 #endif
 
+	if (gpu->mmu_context)
+		etnaviv_iommu_context_put(gpu->mmu_context);
+
 	if (gpu->initialized) {
 		etnaviv_cmdbuf_free(&gpu->buffer);
 		etnaviv_iommu_global_fini(gpu);


