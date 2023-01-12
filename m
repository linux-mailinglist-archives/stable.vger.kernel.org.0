Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954D4667605
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbjALO2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbjALO1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:27:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD169574C3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:18:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6881161F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542F5C433EF;
        Thu, 12 Jan 2023 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533104;
        bh=i6h7Wt1GX3DzFJCWu0+yStN6rbn9/Zfa2ZE+2XMByMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/7t3TFxs9Cd73VCOj/a8obzRJC6yKpywprUvJN6g6EY/DP44QP7dRCNP9t8U91FP
         sU9ZZzmWFn5B7akvcYfBZROZdAQ8t/lPnJvp6LL4/FCniEJffd49ZfX1u5H8roc4FR
         ctgx5alaWQaumUw2rdGvW/aFDyR0pab6PKrQag4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/783] drivers: dio: fix possible memory leak in dio_init()
Date:   Thu, 12 Jan 2023 14:50:57 +0100
Message-Id: <20230112135540.127711996@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit e63e99397b2613d50a5f4f02ed07307e67a190f1 ]

If device_register() returns error, the 'dev' and name needs be
freed. Add a release function, and then call put_device() in the
error path, so the name is freed in kobject_cleanup() and to the
'dev' is freed in release function.

Fixes: 2e4c77bea3d8 ("m68k: dio - Kill warn_unused_result warnings")
Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221109064036.1835346-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dio/dio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 193b40e7aec0..1414a1c81834 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -110,6 +110,12 @@ static char dio_no_name[] = { 0 };
 
 #endif /* CONFIG_DIO_CONSTANTS */
 
+static void dio_dev_release(struct device *dev)
+{
+	struct dio_dev *ddev = container_of(dev, typeof(struct dio_dev), dev);
+	kfree(ddev);
+}
+
 int __init dio_find(int deviceid)
 {
 	/* Called to find a DIO device before the full bus scan has run.
@@ -224,6 +230,7 @@ static int __init dio_init(void)
 		dev->bus = &dio_bus;
 		dev->dev.parent = &dio_bus.dev;
 		dev->dev.bus = &dio_bus_type;
+		dev->dev.release = dio_dev_release;
 		dev->scode = scode;
 		dev->resource.start = pa;
 		dev->resource.end = pa + DIO_SIZE(scode, va);
@@ -251,6 +258,7 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			put_device(&dev->dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
-- 
2.35.1



