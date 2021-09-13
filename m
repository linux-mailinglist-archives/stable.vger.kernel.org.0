Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D0C40949B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346341AbhIMOcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245315AbhIMOas (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93641603E8;
        Mon, 13 Sep 2021 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541095;
        bh=OB4VDq67udv8hZBEAvGdaG+p2Wxcu0NSp8WZsnB3S68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUpo/Ye+hCzKFyoUtCNh+L7PV5c4YpMGDXcQSWgtdKvQwqTsWvgQ1KFusKrX0HBvS
         0qRA1dfF803tQJvkMSYAj+CXlA4kcriuL8q3TaYOWr8QQfMQmcNo3CKT9l3b+TChOB
         YvoaOxBrJNQYz0bTXngGl2gtTTFjBSRsKUoW/Wl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 160/334] media: omap3isp: Fix missing unlock in isp_subdev_notifier_complete()
Date:   Mon, 13 Sep 2021 15:13:34 +0200
Message-Id: <20210913131118.762036477@linuxfoundation.org>
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

[ Upstream commit 0368e7d2cd84a90d0518753fac33795e13df553f ]

Add the missing unlock before return from function
isp_subdev_notifier_complete() in the init error
handling case.

Fixes: ba689d933361 ("media: omap3isp: Acquire graph mutex for graph traversal")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 53025c8c7531..20f59c59ff8a 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2037,8 +2037,10 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	mutex_lock(&isp->media_dev.graph_mutex);
 
 	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&isp->media_dev.graph_mutex);
 		return ret;
+	}
 
 	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
 		if (sd->notifier != &isp->notifier)
-- 
2.30.2



