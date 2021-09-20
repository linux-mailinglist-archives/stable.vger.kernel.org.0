Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196AC412538
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382789AbhITSmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382337AbhITSkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C3E63333;
        Mon, 20 Sep 2021 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159068;
        bh=/YhzPuWJIkCArIATZHznT6wa6phJu78QNPO4qrXyVw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw4qCLxMDoA5j1E/esqTUSbo0pyMfrjDDugHzhpAMOlbgzL5yyHOzQXb3HPQL0F/y
         pRdgLp+fJbNgfMGRVyIvqbyjgQormgc03Ao0LI0j2T1IP2HmoXrbmeEjoTmzsB9Xwf
         m0NgyLowMKpRoGZ76+GPkpHyX0bmMtELxKjW1R8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.14 029/168] drm/etnaviv: fix MMU context leak on GPU reset
Date:   Mon, 20 Sep 2021 18:42:47 +0200
Message-Id: <20210920163922.605288738@linuxfoundation.org>
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
@@ -571,6 +571,8 @@ static int etnaviv_hw_reset(struct etnav
 
 	gpu->fe_running = false;
 	gpu->exec_state = -1;
+	if (gpu->mmu_context)
+		etnaviv_iommu_context_put(gpu->mmu_context);
 	gpu->mmu_context = NULL;
 
 	return 0;


