Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44718657AFC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiL1PRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbiL1PQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:16:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B5113F35
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE552B8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B76C433D2;
        Wed, 28 Dec 2022 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240609;
        bh=vQWqMgVrE+j7saFA+O991G1zL/NHB6C6bXUO1rT5PYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g45oLLT5c+1oHT1NcHvLU4IjMbrIzpP9UyTzqTcGIswXozIo+HCWzMP2IlQ5iKvJY
         kpNZ6409Mrk5yrDeMTrSZkrPkzJ3/uT44N+H3itVPB4O0n1Xe38texS6E658XAs68l
         e160qoUPBLaU4OCvxGEMfCxsTsrON1X3Ji7X/nUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0145/1146] thermal: core: fix some possible name leaks in error paths
Date:   Wed, 28 Dec 2022 15:28:04 +0100
Message-Id: <20221228144334.085809867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4748f9687caaeefab8578285b97b2f30789fc4b4 ]

In some error paths before device_register(), the names allocated
by dev_set_name() are not freed. Move dev_set_name() front to
device_register(), so the name can be freed while calling
put_device().

Fixes: 1dd7128b839f ("thermal/core: Fix null pointer dereference in thermal_release()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 117eeaf7dd24..615fdda3a5de 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -883,10 +883,6 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->id = ret;
 	id = ret;
 
-	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
-	if (ret)
-		goto out_ida_remove;
-
 	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
 	if (!cdev->type) {
 		ret = -ENOMEM;
@@ -901,6 +897,11 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
 	thermal_cooling_device_setup_sysfs(cdev);
+	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
+	if (ret) {
+		thermal_cooling_device_destroy_sysfs(cdev);
+		goto out_kfree_type;
+	}
 	ret = device_register(&cdev->device);
 	if (ret)
 		goto out_kfree_type;
@@ -1234,10 +1235,6 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	tz->id = id;
 	strscpy(tz->type, type, sizeof(tz->type));
 
-	result = dev_set_name(&tz->device, "thermal_zone%d", tz->id);
-	if (result)
-		goto remove_id;
-
 	if (!ops->critical)
 		ops->critical = thermal_zone_device_critical;
 
@@ -1260,6 +1257,11 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	/* A new thermal zone needs to be updated anyway. */
 	atomic_set(&tz->need_update, 1);
 
+	result = dev_set_name(&tz->device, "thermal_zone%d", tz->id);
+	if (result) {
+		thermal_zone_destroy_device_groups(tz);
+		goto remove_id;
+	}
 	result = device_register(&tz->device);
 	if (result)
 		goto release_device;
-- 
2.35.1



