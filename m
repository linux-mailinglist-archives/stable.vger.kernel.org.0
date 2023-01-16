Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9666C7A3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbjAPQdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjAPQcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:32:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DDB298D0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFCB7B81065
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D44CC433F0;
        Mon, 16 Jan 2023 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886027;
        bh=hQKqA9oTzRMuxSq4PWJqskWfO50MjQgKGC+PLGhzzfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouZ/svnzlD4A/p3UW4cRwmUc02mX8GCMB/SNB/mV2l6y6XIobmypaDiI1/iwAZU8G
         76SehBO0uDdrpgK2Gtydzuy8mWxe/O85vc56PYduiCIjz1PM6FZTaUREDhNjoFvpCI
         mfj07abKlBU2qWdzXja6IY5lurEQKWqpdIZkJjoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 274/658] drivers: dio: fix possible memory leak in dio_init()
Date:   Mon, 16 Jan 2023 16:46:02 +0100
Message-Id: <20230116154922.116068265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index c9aa15fb86a9..d07bceb3e34b 100644
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
@@ -222,6 +228,7 @@ static int __init dio_init(void)
 		dev->bus = &dio_bus;
 		dev->dev.parent = &dio_bus.dev;
 		dev->dev.bus = &dio_bus_type;
+		dev->dev.release = dio_dev_release;
 		dev->scode = scode;
 		dev->resource.start = pa;
 		dev->resource.end = pa + DIO_SIZE(scode, va);
@@ -249,6 +256,7 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			put_device(&dev->dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
-- 
2.35.1



