Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D076F291B4E
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732132AbgJRT1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731969AbgJRT1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:27:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FF1822275;
        Sun, 18 Oct 2020 19:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049254;
        bh=3wRloLxl00DkOgVuf+aqG/0+844B7vNr3Wvf4jjiOBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYPr3LMMQcXcI7ia7Fl0n9GTLPCRtJENWxIroOnAM4S/A6ZXf4ps1lnokLZ/bVG8L
         UbgK45WWYfvP8yJRuwwg3cti3lVQ6oyA5lN7xW2qKOl+w6gPD9yx03dIH9yiCW4B8T
         isgE5XD3lf9xmsl2sHeEQeWonNT8OHDEEA7mM7To=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/33] media: exynos4-is: Fix a reference count leak due to pm_runtime_get_sync
Date:   Sun, 18 Oct 2020 15:26:59 -0400
Message-Id: <20201018192728.4056577-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192728.4056577-1-sashal@kernel.org>
References: <20201018192728.4056577-1-sashal@kernel.org>
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
index 31cc7d94064e3..809a415ed10f2 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -413,8 +413,10 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
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

