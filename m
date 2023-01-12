Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447D86675FA
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbjALO16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236997AbjALO1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:27:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EB65373F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8451B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94CAC433D2;
        Thu, 12 Jan 2023 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533072;
        bh=R6yTPwpBsO8+EctjvMjDDr9lv8BYBR5gIDh0hZvoGPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROe7TTgaJcJuIRrEBblvLCKRKcDZdkoFdkYCuYXWrlchxCqLN7gCs8X5XS4AYURdz
         4Nk0BJr/rUU0oZeNKHTwQcUzHIEyysch9ZHj3Jfik6d5WwMctgZtjwTciVtNKn4pxw
         l/llk/xx7cvx7aDchvIBZbOtHi2ydeG2Gyfq6YXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/783] misc: ocxl: fix possible name leak in ocxl_file_register_afu()
Date:   Thu, 12 Jan 2023 14:51:16 +0100
Message-Id: <20230112135541.029164281@linuxfoundation.org>
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
index e094809b54ff..524ded87964d 100644
--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -543,8 +543,11 @@ int ocxl_file_register_afu(struct ocxl_afu *afu)
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



