Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043BC4A42F7
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376659AbiAaLPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:15:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377186AbiAaLNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:13:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2180C610B1;
        Mon, 31 Jan 2022 11:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF00AC340E8;
        Mon, 31 Jan 2022 11:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627626;
        bh=GrmP2LdJx98ffuqsRwZI2grsuwz4Mem8dZRt3G5Zfcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSH2v0l2u+QBMCAkQxhHXcl1M/V3EgQsFuZqxmqqNCed5hF36vZRIlOZbIEC1/Wqw
         /+uuVByOBqFs+4PCbV/4YucIyRdlCifD3fb15d03HDG7kLUrV80TTk0/MArrXF0RCY
         BEpVrljmrPimY/c6c0+PZ/r7UV4Dwdrl2yyo/IUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danylo Piliaiev <dpiliaiev@igalia.com>,
        Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/171] drm/msm/a6xx: Add missing suspend_count increment
Date:   Mon, 31 Jan 2022 11:56:51 +0100
Message-Id: <20220131105234.956756900@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
index 723074aae5b63..b681c45520bbd 100644
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



