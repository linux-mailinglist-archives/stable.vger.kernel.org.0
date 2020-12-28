Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EAE2E3CCC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438056AbgL1OHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437871AbgL1OGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06ADC2063A;
        Mon, 28 Dec 2020 14:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164358;
        bh=uM8wcElyPBmjDfjfNNcNHri8j5m52cm+OCrV4o6HK/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6zuHbWej235SpjS9AK7qOH+K+nSGrKQFWiY9AVNaignqIHHlwjkyFi0YbuQrHcb3
         LCYbFglM+ad68R56Dx/q//mro9lml+teXuCxYOCLOczaWx3p0T4THbtom6h0jQSvbs
         Gunw+02ecAtl96GsqgJvgRc3ejJC+gmjGKXyieAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/717] spi: mxs: fix reference leak in mxs_spi_probe
Date:   Mon, 28 Dec 2020 13:42:31 +0100
Message-Id: <20201228125028.288336213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 03fc41afaa6549baa2dab7a84e1afaf5cadb5b18 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in mxs_spi_probe, so we should fix it.

Fixes: b7969caf41a1d ("spi: mxs: implement runtime pm")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201106012421.95420-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 918918a9e0491..435309b09227e 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -607,6 +607,7 @@ static int mxs_spi_probe(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(ssp->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(ssp->dev);
 		dev_err(ssp->dev, "runtime_get_sync failed\n");
 		goto out_pm_runtime_disable;
 	}
-- 
2.27.0



