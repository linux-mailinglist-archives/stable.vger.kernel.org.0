Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B964C4122DE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377361AbhITSS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376865AbhITSQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20BFB63295;
        Mon, 20 Sep 2021 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158540;
        bh=Fkjka0ZUB9tSbs2BqjZxRBTvymRJ/aJl4Jvpnl9axfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iy/KekHAMlSbzaIcYXMi7+8B3BX38aQ4LSk0dW3Yk35v6Ixh6Z5n0KTRihJ1Rcehj
         bgxZzV22MSC2XdCILrsyL015+5TuxIqIfHxmqfNTEgTAT3OI1Rm1xvG7jiD0kow0Ca
         8pGIalQBNEUoflFjw2yC0+MuWzUXvDnVAO0aXx6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.4 204/260] drm/etnaviv: fix MMU context leak on GPU reset
Date:   Mon, 20 Sep 2021 18:43:42 +0200
Message-Id: <20210920163938.040995639@linuxfoundation.org>
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

commit f978a5302f5566480c58ffae64a16d34456801bd upstream.

After a reset the GPU is no longer using the MMU context and may be
restarted with a different context. While the mmu_state proeprly was
cleared, the context wasn't unreferenced, leading to a memory leak.

Cc: stable@vger.kernel.org # 5.4
Reported-by: Michael Walle <michael@walle.cc>
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
@@ -547,6 +547,8 @@ static int etnaviv_hw_reset(struct etnav
 
 	gpu->fe_running = false;
 	gpu->exec_state = -1;
+	if (gpu->mmu_context)
+		etnaviv_iommu_context_put(gpu->mmu_context);
 	gpu->mmu_context = NULL;
 
 	return 0;


