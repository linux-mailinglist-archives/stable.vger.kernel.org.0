Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617566581AB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbiL1Qa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbiL1QaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:30:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A6F1BE81
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:26:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8B44B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302C0C433D2;
        Wed, 28 Dec 2022 16:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244793;
        bh=8zCJVnbkmkAnQE7pr6b8EkU6OWgNcZvsbNpngBmFC5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uD3wfZQ7yrAvIDVPKvgiwhizkojXzo1+a1m2rYD1oqtauaLX7/uxIwprY54RIPZ5R
         Kg9o1a7zNUY/tIBWxQR34Pajxd+PLXggkh+orWJqnB0OhbKRf10wxir0yCuRl1o93k
         NNnZSTMD7U8v7F3yP/WtxgaKLjSIS8B4CiFibOrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0715/1146] misc: ocxl: fix possible name leak in ocxl_file_register_afu()
Date:   Wed, 28 Dec 2022 15:37:34 +0100
Message-Id: <20221228144349.564740837@linuxfoundation.org>
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

[ Upstream commit a4cb1004aeed2ab893a058fad00a5b41a12c4691 ]

If device_register() returns error in ocxl_file_register_afu(),
the name allocated by dev_set_name() need be freed. As comment
of device_register() says, it should use put_device() to give
up the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanup(),
and info is freed in info_release().

Fixes: 75ca758adbaf ("ocxl: Create a clear delineation between ocxl backend & frontend")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111145929.2429271-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/file.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ocxl/file.c b/drivers/misc/ocxl/file.c
index d46dba2df5a1..452d5777a0e4 100644
--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -541,8 +541,11 @@ int ocxl_file_register_afu(struct ocxl_afu *afu)
 		goto err_put;
 
 	rc = device_register(&info->dev);
-	if (rc)
-		goto err_put;
+	if (rc) {
+		free_minor(info);
+		put_device(&info->dev);
+		return rc;
+	}
 
 	rc = ocxl_sysfs_register_afu(info);
 	if (rc)
-- 
2.35.1



