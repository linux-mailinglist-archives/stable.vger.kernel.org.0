Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15F65786D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiL1Oub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiL1OuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1026E11C1A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98A9FB8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97B1C433F0;
        Wed, 28 Dec 2022 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239019;
        bh=eiTWlq2arxovgy0ikInutqzted+mKoa9/WJaOrpmpT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYqfz6/QL36rpg2MCLHOnoE2VM30yf33Gw2n1yaA+UCLwOeR/em7NzLH2YpzFF5f/
         IUP5ejFU1f589hCDshI/a4E3Kfvn0h3pULI6KB3V/ElMyMUuX0T79g3NcwMIB/yEPB
         ST0gegvVsSl9EUfliVC/OJjuvGnLvBm3+BnbNckc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/731] thermal: core: fix some possible name leaks in error paths
Date:   Wed, 28 Dec 2022 15:33:25 +0100
Message-Id: <20221228144259.390790216@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 867c8aa92b3a..38082fdc4fde 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -905,10 +905,6 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->id = ret;
 	id = ret;
 
-	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
-	if (ret)
-		goto out_ida_remove;
-
 	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
 	if (!cdev->type) {
 		ret = -ENOMEM;
@@ -923,6 +919,11 @@ __thermal_cooling_device_register(struct device_node *np,
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
@@ -1235,10 +1236,6 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	tz->id = id;
 	strlcpy(tz->type, type, sizeof(tz->type));
 
-	result = dev_set_name(&tz->device, "thermal_zone%d", tz->id);
-	if (result)
-		goto remove_id;
-
 	if (!ops->critical)
 		ops->critical = thermal_zone_device_critical;
 
@@ -1260,6 +1257,11 @@ thermal_zone_device_register(const char *type, int trips, int mask,
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



