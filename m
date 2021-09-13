Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9565E409172
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343944AbhIMOBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245730AbhIMN71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C73610FE;
        Mon, 13 Sep 2021 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540225;
        bh=IFq5a1R/bvoW7J5KJC/aQ63k1a7K0dBrSifk+UHnhCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1CoEEOKAKAv3oQW8DTJzKg9Fzi4yrOwMAgEkDqBwCud80FgdmNPBIC+sA6EcvHyP
         oLjGLbNgXsIdeb3TVE6MeueGbwYw3VQSF9KfZdBe36/LO5oa4JJjdv3K9o0Z1XAqzF
         F/aeAUrv/2Gkjw6KhENUHmfZnOCUodC6FHqm5K5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 105/300] driver core: Fix error return code in really_probe()
Date:   Mon, 13 Sep 2021 15:12:46 +0200
Message-Id: <20210913131112.920112329@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 592b3955abe2..a421da0c9c01 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -560,7 +560,8 @@ re_probe:
 			goto probe_failed;
 	}
 
-	if (driver_sysfs_add(dev)) {
+	ret = driver_sysfs_add(dev);
+	if (ret) {
 		pr_err("%s: driver_sysfs_add(%s) failed\n",
 		       __func__, dev_name(dev));
 		goto probe_failed;
@@ -582,15 +583,18 @@ re_probe:
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



