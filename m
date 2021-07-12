Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0AE3C521B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349824AbhGLHos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347724AbhGLHkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8783616EB;
        Mon, 12 Jul 2021 07:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075360;
        bh=GZThXBkEDJrPkBQ6gYuFdb3WkyY1+rD+VFNgn18u+z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NhGLq+CuocJjFAJPV/nPuDhFTSb/UEu/X2VIo+cGYEDzmIrqv7/U6/bCCRz3I/UC
         ri5aLzuYa/vT6kW5WHXM7D9nvIUJ9Sxd+E1JnL9oOqIAoujqVrg9b36nnnVUI+T0Y4
         +ymKUJe44fKCHc81oLddU6nFHX8CTzjTlK9QEARI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 192/800] drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
Date:   Mon, 12 Jul 2021 08:03:35 +0200
Message-Id: <20210712060940.054376017@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 2bbb93188064..7b87aaf267d5 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -705,8 +705,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
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



