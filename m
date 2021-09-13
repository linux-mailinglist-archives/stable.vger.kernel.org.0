Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF970409432
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345009AbhIMO2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345785AbhIMO04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B531F6136A;
        Mon, 13 Sep 2021 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540968;
        bh=rKTS/nWBZfsxfFC4uj6EZpuILt3KjEXzscEaEa/h3dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WLPF3KzB4u+jCl6xvGiuSc2gRsA3lD6jncRvLGjCbxwAu+FstfG5aDHTohOEnrWjz
         n//fYNcHyqrV0qBzxQBQaJk3rpUxwOHSEKilvSHpNVDf+BDGaq18iKl4NolEqqNu1M
         B3Hv0y1c0oeUoJr0DumU3KWFFyX4Z2aKDRAIz8ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 109/334] driver core: Fix error return code in really_probe()
Date:   Mon, 13 Sep 2021 15:12:43 +0200
Message-Id: <20210913131117.060419491@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit f04948dea236b000da09c466a7ec931ecd8d7867 ]

In the case of error handling, the error code returned by the subfunction
should be propagated instead of 0.

Fixes: 1901fb2604fb ("Driver core: fix "driver" symlink timing")
Fixes: 23b6904442d0 ("driver core: add dev_groups to all drivers")
Fixes: 8fd456ec0cf0 ("driver core: Add state_synced sysfs file for devices that support it")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210707074301.2722-1-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 437cd61343b2..68ea1f949daa 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -580,7 +580,8 @@ re_probe:
 			goto probe_failed;
 	}
 
-	if (driver_sysfs_add(dev)) {
+	ret = driver_sysfs_add(dev);
+	if (ret) {
 		pr_err("%s: driver_sysfs_add(%s) failed\n",
 		       __func__, dev_name(dev));
 		goto probe_failed;
@@ -602,15 +603,18 @@ re_probe:
 		goto probe_failed;
 	}
 
-	if (device_add_groups(dev, drv->dev_groups)) {
+	ret = device_add_groups(dev, drv->dev_groups);
+	if (ret) {
 		dev_err(dev, "device_add_groups() failed\n");
 		goto dev_groups_failed;
 	}
 
-	if (dev_has_sync_state(dev) &&
-	    device_create_file(dev, &dev_attr_state_synced)) {
-		dev_err(dev, "state_synced sysfs add failed\n");
-		goto dev_sysfs_state_synced_failed;
+	if (dev_has_sync_state(dev)) {
+		ret = device_create_file(dev, &dev_attr_state_synced);
+		if (ret) {
+			dev_err(dev, "state_synced sysfs add failed\n");
+			goto dev_sysfs_state_synced_failed;
+		}
 	}
 
 	if (test_remove) {
-- 
2.30.2



