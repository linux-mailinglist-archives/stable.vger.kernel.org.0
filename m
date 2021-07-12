Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B5E3C5192
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243485AbhGLHmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245047AbhGLHgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:36:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF1761920;
        Mon, 12 Jul 2021 07:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075172;
        bh=+kWkDaGTsPPxJT4uqZ2LrjFWemhGoRnIa21NCqiEzNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bulauw7eGZWwEGtMYf4s4W8QABshbp0Jen9Tjmba6mVrcCdYr4HDSfpN6GyVuNkwX
         P8aAZdbA88qnC0xDowOTCl94az+dq897lhbrPxCIFtHJB8EcPfmHJF9FLHlllo0OLw
         YqqqYvXYUqrylJ8owy5CtTLtfsm8ITN1BYClqxOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 130/800] media: i2c: imx334: fix the pm runtime get logic
Date:   Mon, 12 Jul 2021 08:02:33 +0200
Message-Id: <20210712060931.290952540@linuxfoundation.org>
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



