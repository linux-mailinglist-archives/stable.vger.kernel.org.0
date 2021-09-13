Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3F9408CC1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbhIMNVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240351AbhIMNU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B14F60698;
        Mon, 13 Sep 2021 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539114;
        bh=CS8+VcMOYQjXehMLMNKCWfwJBXllx38Yv8JbyfhpRwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEC6haAMfWqZWl3GoePUDkqTVxT6hERg6d3u3lVpKnvsOayaDbCvQD0tG0XTRVPFD
         DG0eMg6KIXduKXjhdnbCEEbHyDYF1ry6kfreRUHAbYNzRmVSgm6WWlDuAaGEmet/3M
         qt6gnIgjDsv1ycF669SVAkDV2BomYrvB+e0+UMl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/144] drm/panfrost: Fix missing clk_disable_unprepare() on error in panfrost_clk_init()
Date:   Mon, 13 Sep 2021 15:13:47 +0200
Message-Id: <20210913131049.484390574@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f42498705965bd4b026953c1892c686d8b1138e4 ]

Fix the missing clk_disable_unprepare() before return
from panfrost_clk_init() in the error handling case.

Fixes: b681af0bc1cc ("drm: panfrost: add optional bus_clock")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210608143856.4154766-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index 238fb6d54df4..413bf314a2bc 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -59,7 +59,8 @@ static int panfrost_clk_init(struct panfrost_device *pfdev)
 	if (IS_ERR(pfdev->bus_clock)) {
 		dev_err(pfdev->dev, "get bus_clock failed %ld\n",
 			PTR_ERR(pfdev->bus_clock));
-		return PTR_ERR(pfdev->bus_clock);
+		err = PTR_ERR(pfdev->bus_clock);
+		goto disable_clock;
 	}
 
 	if (pfdev->bus_clock) {
-- 
2.30.2



