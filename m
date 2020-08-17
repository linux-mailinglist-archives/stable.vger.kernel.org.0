Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FDA2476B9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404250AbgHQTkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729744AbgHQPZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5203B2395A;
        Mon, 17 Aug 2020 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677935;
        bh=8B3cUnRmx62sFKs0qlloxzrRqSMU4MSjAFmvDjdYovk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQiA2KhGJIPsmz/sOFKHIQlqNCYYk7n0oyGz2gKdG+RZ0tVCOT849awo7YuVfXTO6
         CYa8msKdrp/170Xij1GmXbbCLE++Hn1CDOOMsRtFnNrWByZFVCP2ypbu6vClDk0CTK
         0sOQfEPuesukLfk+Lv0QK0SmU+vMSlOFfKOxlhtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 162/464] drm/etnaviv: Fix error path on failure to enable bus clk
Date:   Mon, 17 Aug 2020 17:11:55 +0200
Message-Id: <20200817143841.568807126@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit f8794feaf65cdc97767604cf864775d20b97f397 ]

Since commit 65f037e8e908 ("drm/etnaviv: add support for slave interface
clock") the reg clock is enabled before the bus clock and we need to undo
its enablement on error.

Fixes: 65f037e8e908 ("drm/etnaviv: add support for slave interface clock")
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index 7c9f3f9ba1235..4a512b062df8f 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1502,7 +1502,7 @@ static int etnaviv_gpu_clk_enable(struct etnaviv_gpu *gpu)
 	if (gpu->clk_bus) {
 		ret = clk_prepare_enable(gpu->clk_bus);
 		if (ret)
-			return ret;
+			goto disable_clk_reg;
 	}
 
 	if (gpu->clk_core) {
@@ -1525,6 +1525,9 @@ static int etnaviv_gpu_clk_enable(struct etnaviv_gpu *gpu)
 disable_clk_bus:
 	if (gpu->clk_bus)
 		clk_disable_unprepare(gpu->clk_bus);
+disable_clk_reg:
+	if (gpu->clk_reg)
+		clk_disable_unprepare(gpu->clk_reg);
 
 	return ret;
 }
-- 
2.25.1



