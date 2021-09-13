Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFADC409569
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345866AbhIMOlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346229AbhIMOjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:39:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90E1261CA7;
        Mon, 13 Sep 2021 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541304;
        bh=vuugTzNiMwq7LAilvEM6yW1ZZMCPjEelgcrp15+4KuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ew0HfvTo+/Qc5/o8hCAglrsjrapb1WTUs3UbE3+jDLH1cCY9EjqfNzvGtdLBs2Jxo
         zsVosR1MwxUtPRg2vAsF77rPJzpkKFwhMXSALb0hlx3E1zVt32L/Kwl8jRDdyAJM1Y
         WFiV9ZtwNC/Q2sp67eMKw692WawIivByDc/fAY6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 237/334] drm/exynos: g2d: fix missing unlock on error in g2d_runqueue_worker()
Date:   Mon, 13 Sep 2021 15:14:51 +0200
Message-Id: <20210913131121.427555149@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b74a29fac6de62f39b594e8f545b3a26db7edb5e ]

Add the missing unlock before return from function g2d_runqueue_worker()
in the error handling case.

Fixes: 445d3bed75de ("drm/exynos: use pm_runtime_resume_and_get()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index cab4d2c370a7..0ed665501ac4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -897,13 +897,14 @@ static void g2d_runqueue_worker(struct work_struct *work)
 			ret = pm_runtime_resume_and_get(g2d->dev);
 			if (ret < 0) {
 				dev_err(g2d->dev, "failed to enable G2D device.\n");
-				return;
+				goto out;
 			}
 
 			g2d_dma_start(g2d, g2d->runqueue_node);
 		}
 	}
 
+out:
 	mutex_unlock(&g2d->runqueue_mutex);
 }
 
-- 
2.30.2



