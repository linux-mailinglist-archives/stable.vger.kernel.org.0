Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB143BB0C0
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhGDXJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231594AbhGDXJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A86CD61405;
        Sun,  4 Jul 2021 23:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439982;
        bh=ht5TsiapjXMHML+LcVLYQqsFvSYjeNKVivTIumc8ekE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBQxGmdrKNUBSWsYEqrG2abO9mqniTfu0oCMwfl+qVvdxhhDKk0L/MdOTcZL9fTVW
         XmWgL9fnTasEMHqbICUkHX8/EQ7IwPXw8Vp5MgTjNHIJckJYU5J+kfbgu4XaYqkfsx
         t9wD1p6giz+RGVROCS7LvB/u9/gjUoOkYvBOV3/doGYH0IZDulZ7QCYs5c/qlijZm4
         RIJigtZ3Hd4dN2T+IQyzJ6pq3EJD32RmECVCwQfbwqp9Q7ODKD/2So50ZLEudViONK
         morV0UKE5VFuDycfeekN12rO4KNe+JRuzm3gadngNPcUf6yXdvJImjfaDP0EAmexSh
         Sx2auzAuy4TTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 04/80] media: i2c: imx334: fix the pm runtime get logic
Date:   Sun,  4 Jul 2021 19:05:00 -0400
Message-Id: <20210704230616.1489200-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 62c90446868b439929cb04395f04a709a64ae04b ]

The PM runtime get logic is currently broken, as it checks if
ret is zero instead of checking if it is an error code,
as reported by Dan Carpenter.

While here, use the pm_runtime_resume_and_get() as added by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
added pm_runtime_resume_and_get() in order to automatically handle
dev->power.usage_count decrement on errors. As a bonus, such function
always return zero on success.

It should also be noticed that a fail of pm_runtime_get_sync() would
potentially result in a spurious runtime_suspend(), instead of
using pm_runtime_put_noidle().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx334.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/imx334.c b/drivers/media/i2c/imx334.c
index ad530f0d338a..02d22907c75c 100644
--- a/drivers/media/i2c/imx334.c
+++ b/drivers/media/i2c/imx334.c
@@ -717,9 +717,9 @@ static int imx334_set_stream(struct v4l2_subdev *sd, int enable)
 	}
 
 	if (enable) {
-		ret = pm_runtime_get_sync(imx334->dev);
-		if (ret)
-			goto error_power_off;
+		ret = pm_runtime_resume_and_get(imx334->dev);
+		if (ret < 0)
+			goto error_unlock;
 
 		ret = imx334_start_streaming(imx334);
 		if (ret)
@@ -737,6 +737,7 @@ static int imx334_set_stream(struct v4l2_subdev *sd, int enable)
 
 error_power_off:
 	pm_runtime_put(imx334->dev);
+error_unlock:
 	mutex_unlock(&imx334->mutex);
 
 	return ret;
-- 
2.30.2

