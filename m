Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE223C44E8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhGLGWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhGLGVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91E3161156;
        Mon, 12 Jul 2021 06:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070699;
        bh=kgtaJvA+7EPrqT0AesDI5to2E+p7OCd4wpqdTFGSVQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnmwrPrtvGsYEnNHe7mMhGwCE5UE372vaemsZtFTJ5NbKJD3vmIGwFHK0GieYam94
         BNE4jh11o28iQVjp9yhb/e8QdNV9nMbp95ctcMz0zbBEyx9klMU1cpKiAsd/hIqXrp
         vkNaEqTU0S2yO0AIVSRZGaw145Tcex82nEzDwDj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/348] drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
Date:   Mon, 12 Jul 2021 08:08:05 +0200
Message-Id: <20210712060715.063898481@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit d96b1b8c9f79b6bb234a31c80972a6f422079376 ]

ddr_perf_probe() misses to call ida_simple_remove() in an error path.
Jump to cpuhp_state_err to fix it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20210617122614.166823-1-jingxiangfeng@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 09f44c6e2eaf..726ed8f59868 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -562,8 +562,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
 	name = devm_kasprintf(&pdev->dev, GFP_KERNEL, DDR_PERF_DEV_NAME "%d",
 			      num);
-	if (!name)
-		return -ENOMEM;
+	if (!name) {
+		ret = -ENOMEM;
+		goto cpuhp_state_err;
+	}
 
 	pmu->devtype_data = of_device_get_match_data(&pdev->dev);
 
-- 
2.30.2



