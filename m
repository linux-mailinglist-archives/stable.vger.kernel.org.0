Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30A2291F94
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgJRTS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbgJRTSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0631522280;
        Sun, 18 Oct 2020 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048703;
        bh=xiwjw8KknXFMOt4RJcbvZ1zq8+I/nkRinEzUKgcWbIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQq2xG64PmZNyyM3DfSdVAqjMYnk2Hqy3Ufp+FPWu9YtR1B6Okv1HBn57VMQgC5PQ
         cX3sA0yVyEMW2Z8lMRRxLbGh06IbiSD93uLoBQeXbXu8rRsRYU/L2VE1B5eqI16OjI
         NsymeRrTsPs7fRYO6S6/Ni8WI2dZwpsJL5AX35e0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 012/111] media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync
Date:   Sun, 18 Oct 2020 15:16:28 -0400
Message-Id: <20201018191807.4052726-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit c47f7c779ef0458a58583f00c9ed71b7f5a4d0a2 ]

On calling pm_runtime_get_sync() the reference count of the device
is incremented. In case of failure, decrement the
reference count before returning the error.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 16dd660137a8d..0bc8c23112db4 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -484,8 +484,10 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 		return -ENXIO;
 
 	ret = pm_runtime_get_sync(fmd->pmf);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put(fmd->pmf);
 		return ret;
+	}
 
 	fmd->num_sensors = 0;
 
-- 
2.25.1

