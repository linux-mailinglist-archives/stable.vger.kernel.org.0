Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04213BAFD1
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhGDXHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhGDXHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AAF8613E9;
        Sun,  4 Jul 2021 23:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439867;
        bh=+kWkDaGTsPPxJT4uqZ2LrjFWemhGoRnIa21NCqiEzNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo1QkYSjzAht6OdgmIjhAoAmB5z2oHJ/is5UWsmVLdMu3m8NnPGrDu46mjXFFzvXK
         4X2zZmRZ/h29WpnuSMpOy/4IUMUGaecamaYiWRedfnIeflhQJvc9UG7mNWA2tMKNxo
         r/DmpzyxNRUKUZf70r+pVm8D3VzPhvITGlNERfvHEMjTlGv5kj2aiVQqSN3gkIKHEd
         YN22W1MPUZZ9c8uDUtTLtzodmJqpKZ4fPHFEToCNKTKXn/WO4H9wFyp6uziuV7ctTA
         W37u3P3DLTD/QgiIqGbwIt3pKgavUVgrTs1eQUhyte2/V+PDUZMim85d4jCSho/1ul
         Hmcd1deQN95Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 04/85] media: i2c: imx334: fix the pm runtime get logic
Date:   Sun,  4 Jul 2021 19:02:59 -0400
Message-Id: <20210704230420.1488358-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index 047aa7658d21..23f28606e570 100644
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

