Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F185E29AFAE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755284AbgJ0OMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754751AbgJ0OGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:06:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF1A22263;
        Tue, 27 Oct 2020 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807612;
        bh=qLE5NmCD35w4LiiZyJYMTASa1iYX0u+VkyhveGOJTBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGtr+23wiBcEdQQ3D8pgGvuH094QywJ0A44WeSSISFZ9narjb6VlcVZDi1CrFnnqh
         pS09fUR/rRHW1Y6k02Z7vZpvjI8vthUcmwV3iYvmROjlS9FKmWnjv1Poe+0WiBib7J
         A54hN6LJ//5WxYHzl6G6b+QSmE8cvNMnMelf/20Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 099/139] media: exynos4-is: Fix a reference count leak
Date:   Tue, 27 Oct 2020 14:49:53 +0100
Message-Id: <20201027134906.839779467@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 64157b2cb1940449e7df2670e85781c690266588 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code, causing incorrect ref count if
pm_runtime_put_noidle() is not called in error handling paths.
Thus call pm_runtime_put_noidle() if pm_runtime_get_sync() fails.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/mipi-csis.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index befd9fc0adc4a..dc87c9cfa52ff 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -513,8 +513,10 @@ static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
 	if (enable) {
 		s5pcsis_clear_counters(state);
 		ret = pm_runtime_get_sync(&state->pdev->dev);
-		if (ret && ret != 1)
+		if (ret && ret != 1) {
+			pm_runtime_put_noidle(&state->pdev->dev);
 			return ret;
+		}
 	}
 
 	mutex_lock(&state->lock);
-- 
2.25.1



