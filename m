Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1355A66CA4B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbjAPRBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjAPRBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797E25A36B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:43:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCC8F61086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E8CC433D2;
        Mon, 16 Jan 2023 16:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887410;
        bh=8ZrSRk56F7HqdoQq6h2Jqu1RxxCRzBzRcEMeSBifkIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dViFbmXhlTJig6x0m0K052txfFmgYngKnpHskJvJZmZeOEbuBP60O0nnGVUqgCHkJ
         Ig45bWkO1CLrhZ6NBFR10143dxObdY1LWacqWV1e4yiPsw8c/vUjQSpkn3jVLWp+P+
         kS7DkzepBUHaKAOG14x9uHSfqXvPuU0A4tx1jwx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/521] media: platform: exynos4-is: Fix error handling in fimc_md_init()
Date:   Mon, 16 Jan 2023 16:46:11 +0100
Message-Id: <20230116154852.132777041@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit b434422c45282a0573d8123239abc41fa72665d4 ]

A problem about modprobe s5p_fimc failed is triggered with the
following log given:

 [  272.075275] Error: Driver 'exynos4-fimc' is already registered, aborting...
 modprobe: ERROR: could not insert 's5p_fimc': Device or resource busy

The reason is that fimc_md_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without unregister fimc_driver, resulting the
s5p_fimc can never be installed later.
A simple call graph is shown as below:

 fimc_md_init()
   fimc_register_driver() # register fimc_driver
   platform_driver_register()
     platform_driver_register()
       driver_register()
         bus_add_driver()
           dev = kzalloc(...) # OOM happened
   # return without unregister fimc_driver

Fix by unregister fimc_driver when platform_driver_register() returns
error.

Fixes: d3953223b090 ("[media] s5p-fimc: Add the media device driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/fimc-core.c | 2 +-
 drivers/media/platform/exynos4-is/media-dev.c | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index d8d8c9902b19..cc8bc41b7db7 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -1255,7 +1255,7 @@ int __init fimc_register_driver(void)
 	return platform_driver_register(&fimc_driver);
 }
 
-void __exit fimc_unregister_driver(void)
+void fimc_unregister_driver(void)
 {
 	platform_driver_unregister(&fimc_driver);
 }
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 3261dc72cc61..03171f2cf296 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1566,7 +1566,11 @@ static int __init fimc_md_init(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&fimc_md_driver);
+	ret = platform_driver_register(&fimc_md_driver);
+	if (ret)
+		fimc_unregister_driver();
+
+	return ret;
 }
 
 static void __exit fimc_md_exit(void)
-- 
2.35.1



