Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34E54A458A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350282AbiAaLm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350277AbiAaLk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:40:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC18C061753;
        Mon, 31 Jan 2022 03:25:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B09612E1;
        Mon, 31 Jan 2022 11:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598F3C340E8;
        Mon, 31 Jan 2022 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628350;
        bh=9Paiirp5TS2e1cBE9aZOefDP4gRIXS1WodwPA4U4pHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipZylJFfYoYJmbDj5dvk8sA4ITdTAbsWI4JPrxS5i60jACJ810L8L9XElp64vnwFz
         CuT6ZMSl0fTlfxGxSU8sQqbCuHlMa4muD3eEhwaQDYA/OHacD1Dwl2L2fmZF3zRm1s
         IzVKkAKJVdJBrZOMlcyd4uwkyYelZKzKZacdPMp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danylo Piliaiev <dpiliaiev@igalia.com>,
        Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 171/200] drm/msm/a6xx: Add missing suspend_count increment
Date:   Mon, 31 Jan 2022 11:57:14 +0100
Message-Id: <20220131105239.305395468@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 860a7b2a87b7c743154824d0597b6c3eb3b53154 ]

Reported-by: Danylo Piliaiev <dpiliaiev@igalia.com>
Fixes: 3ab1c5cc3939 ("drm/msm: Add param for userspace to query suspend count")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220113163215.215367-1-robdclark@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 78aad5216a613..a305ff7e8c6fb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1557,6 +1557,8 @@ static int a6xx_pm_suspend(struct msm_gpu *gpu)
 		for (i = 0; i < gpu->nr_rings; i++)
 			a6xx_gpu->shadow[i] = 0;
 
+	gpu->suspend_count++;
+
 	return 0;
 }
 
-- 
2.34.1



