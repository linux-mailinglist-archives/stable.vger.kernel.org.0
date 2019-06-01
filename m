Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC231EFD
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfFANTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbfFANTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:19:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF082725F;
        Sat,  1 Jun 2019 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395186;
        bh=NHp4Zus6V4JDtlhyZgmwXxF/CbFxoMXzr6qTYcrfCPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuiUhad7NAChNF9UZcoCgwfFn9BF/KQ8m6F3TGnJ5ul9mPMLLGFw7rd0UqzSll1ER
         6+yk36QjCl/ZGDeXH2kKjAGpP0JjGO5Qzfqsy4id4n+r3f1iQllGL0xtbagcvFpT/g
         4DiI0wNSwIYhjGtMvxfYX+M+ZfPGXEx7aStUYXnU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Karlman <jonas@kwiboo.se>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.0 002/173] media: rockchip/vpu: Add missing dont_use_autosuspend() calls
Date:   Sat,  1 Jun 2019 09:16:34 -0400
Message-Id: <20190601131934.25053-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 5c5b90f5cbad77dc15d8b5582efdb2e362bcd710 ]

Those calls are needed to restore a clean PM state when the probe fails
or when the driver is unloaded such that future ->probe() calls can
initialize runtime PM again.

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 33b556b3f0df8..d489b5dd54d7a 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -492,6 +492,7 @@ static int rockchip_vpu_probe(struct platform_device *pdev)
 	v4l2_device_unregister(&vpu->v4l2_dev);
 err_clk_unprepare:
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
+	pm_runtime_dont_use_autosuspend(vpu->dev);
 	pm_runtime_disable(vpu->dev);
 	return ret;
 }
@@ -512,6 +513,7 @@ static int rockchip_vpu_remove(struct platform_device *pdev)
 	v4l2_m2m_release(vpu->m2m_dev);
 	v4l2_device_unregister(&vpu->v4l2_dev);
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
+	pm_runtime_dont_use_autosuspend(vpu->dev);
 	pm_runtime_disable(vpu->dev);
 	return 0;
 }
-- 
2.20.1

