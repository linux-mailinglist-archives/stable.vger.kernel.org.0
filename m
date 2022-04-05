Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14CE4F2AFC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbiDEJPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244925AbiDEIws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347B424968;
        Tue,  5 Apr 2022 01:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6126CE1BF9;
        Tue,  5 Apr 2022 08:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA04CC385A0;
        Tue,  5 Apr 2022 08:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148397;
        bh=SiWQfNK6upuvyL25sOXXFwldcQxeRu/FiH4eEINwg/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLxrzvU+ReIGd0lQr7k6weWMlk2vfbZ9OS4tW5ZZeuo3LkA3fWSgV3DLBYSK2W77M
         YXun2CPEgB479f33fMa+2ctuo/p/4Hy1SfYB/1ZId3j5iTdq2Z9xWGxOseERpx2XZ0
         bcm70/FDBFeOku0M8qF+YRLxHZlQmocMxkg9mY90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0305/1017] video: fbdev: atmel_lcdfb: fix an error code in atmel_lcdfb_probe()
Date:   Tue,  5 Apr 2022 09:20:18 +0200
Message-Id: <20220405070403.329591789@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit fee5c1e4b789e41719af9fee0e2dd397cd31988f ]

If "sinfo->config" is not found, then return -ENODEV.  Don't
return success.

Fixes: b985172b328a ("video: atmel_lcdfb: add device tree suport")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/atmel_lcdfb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
index 355b6120dc4f..1fc8de4ecbeb 100644
--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -1062,15 +1062,16 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&info->modelist);
 
-	if (pdev->dev.of_node) {
-		ret = atmel_lcdfb_of_init(sinfo);
-		if (ret)
-			goto free_info;
-	} else {
+	if (!pdev->dev.of_node) {
 		dev_err(dev, "cannot get default configuration\n");
 		goto free_info;
 	}
 
+	ret = atmel_lcdfb_of_init(sinfo);
+	if (ret)
+		goto free_info;
+
+	ret = -ENODEV;
 	if (!sinfo->config)
 		goto free_info;
 
-- 
2.34.1



