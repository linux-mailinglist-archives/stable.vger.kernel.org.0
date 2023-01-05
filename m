Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A18165EBDC
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjAENDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbjAENDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:03:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CCA5B17D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:03:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B44CB81A3E
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEED8C433EF;
        Thu,  5 Jan 2023 13:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923790;
        bh=dJWsbAVjVwzRa2W8nZ2508jk4BnxyulUQgFbPvT/dcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azPrf/PMmHQHBX8JgOwsHQJNCo0JXD1rFFJVXfKD8VGaYNzIfIIZkeeRwU/ZydXuJ
         APc+UZOgji1eh+0JCP1XfCWgmIXTI50TzgecE29/2f6TDmr5v5z5aen3GsJm/Myy7b
         v429ZJpPdRoBWk6XsUMSMJcX1R21Nlz3e818qYGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 126/251] drivers: dio: fix possible memory leak in dio_init()
Date:   Thu,  5 Jan 2023 13:54:23 +0100
Message-Id: <20230105125340.601962732@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index 55dd88d82d6d..e85895fc258d 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -109,6 +109,12 @@ static char dio_no_name[] = { 0 };
 
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
@@ -234,6 +240,7 @@ static int __init dio_init(void)
 		dev->bus = &dio_bus;
 		dev->dev.parent = &dio_bus.dev;
 		dev->dev.bus = &dio_bus_type;
+		dev->dev.release = dio_dev_release;
 		dev->scode = scode;
 		dev->resource.start = pa;
 		dev->resource.end = pa + DIO_SIZE(scode, va);
@@ -261,6 +268,7 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			put_device(&dev->dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
-- 
2.35.1



