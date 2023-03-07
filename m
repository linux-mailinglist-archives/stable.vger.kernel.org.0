Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57FC86AF36F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbjCGTEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbjCGTEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:04:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3100222EC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B61C16150E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBA2C433EF;
        Tue,  7 Mar 2023 18:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214981;
        bh=Mns4EhXzwHvXoY95zYczFHQHxSym1AFhnjhKWAl9AV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRX+CUAOFrvONNjHOsu8/hty/SgPrp3brIHBopKRLba7m3KoLs5kFBN/jB1/fWsoD
         E4wy+7jLTLOPdiqwhCcv2y9qSOKrTDQXyGldr+hznU1npRlwXQlwZ0wdDt3h6AKJWh
         SA+1HzziaDD6RTl2ZPO71YjF53GXT2e7mDIXd2Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/567] powercap: fix possible name leak in powercap_register_zone()
Date:   Tue,  7 Mar 2023 17:57:28 +0100
Message-Id: <20230307165910.776346332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1b6599f741a4525ca761ecde46e5885ff1e6ba58 ]

In the error path after calling dev_set_name(), the device
name is leaked. To fix this, calling dev_set_name() before
device_register(), and call put_device() if it returns error.

All the resources is released in powercap_release(), so it
can return from powercap_register_zone() directly.

Fixes: 75d2364ea0ca ("PowerCap: Add class driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/powercap_sys.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index f0654a932b372..ff736b006198f 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -529,9 +529,6 @@ struct powercap_zone *powercap_register_zone(
 	power_zone->name = kstrdup(name, GFP_KERNEL);
 	if (!power_zone->name)
 		goto err_name_alloc;
-	dev_set_name(&power_zone->dev, "%s:%x",
-					dev_name(power_zone->dev.parent),
-					power_zone->id);
 	power_zone->constraints = kcalloc(nr_constraints,
 					  sizeof(*power_zone->constraints),
 					  GFP_KERNEL);
@@ -554,9 +551,16 @@ struct powercap_zone *powercap_register_zone(
 	power_zone->dev_attr_groups[0] = &power_zone->dev_zone_attr_group;
 	power_zone->dev_attr_groups[1] = NULL;
 	power_zone->dev.groups = power_zone->dev_attr_groups;
+	dev_set_name(&power_zone->dev, "%s:%x",
+					dev_name(power_zone->dev.parent),
+					power_zone->id);
 	result = device_register(&power_zone->dev);
-	if (result)
-		goto err_dev_ret;
+	if (result) {
+		put_device(&power_zone->dev);
+		mutex_unlock(&control_type->lock);
+
+		return ERR_PTR(result);
+	}
 
 	control_type->nr_zones++;
 	mutex_unlock(&control_type->lock);
-- 
2.39.2



