Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4385F4123AC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346698AbhITS0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378271AbhITSYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 766CC632B7;
        Mon, 20 Sep 2021 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158688;
        bh=vE2INCWV22/gVkyOdYeFrysmkn7Bb/vdTSS76qfAwEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEsTUIw3jzCn/PuPn4xc3SeCbl3ode9U2hxQdFsdkJc5KumKnrRoliVL9BcQ5EkZC
         n80slcwJ8vFUL2sYhkSEIc3ZRvur6hIzGhtzC7TwY/V9uJWiTV3Xnlo4VAZfL4/093
         lzn43/RAAyKkS1Ud5PtI1woAV3FWApnI9+vmEjVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.10 011/122] drm/etnaviv: put submit prev MMU context when it exists
Date:   Mon, 20 Sep 2021 18:43:03 +0200
Message-Id: <20210920163916.140266469@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit cda7532916f7bc860b36a1806cb8352e6f63dacb upstream.

The prev context is the MMU context at the time of the job
queueing in hardware. As a job might be queued multiple times
due to recovery after a GPU hang, we need to make sure to put
the stale prev MMU context from a prior queuing, to avoid the
reference and thus the MMU context leaking.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1356,6 +1356,8 @@ struct dma_fence *etnaviv_gpu_submit(str
 		gpu->mmu_context = etnaviv_iommu_context_get(submit->mmu_context);
 		etnaviv_gpu_start_fe_idleloop(gpu);
 	} else {
+		if (submit->prev_mmu_context)
+			etnaviv_iommu_context_put(submit->prev_mmu_context);
 		submit->prev_mmu_context = etnaviv_iommu_context_get(gpu->mmu_context);
 	}
 


