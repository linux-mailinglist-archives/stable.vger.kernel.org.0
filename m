Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604604F369B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiDELGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348089AbiDEJq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544C5E2F70;
        Tue,  5 Apr 2022 02:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C13AC616AE;
        Tue,  5 Apr 2022 09:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB226C385A2;
        Tue,  5 Apr 2022 09:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151196;
        bh=SiWQfNK6upuvyL25sOXXFwldcQxeRu/FiH4eEINwg/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rChFkmpUQ4NCt8WvS+xnJiDEoRnwz5/3po2/YAFiSgGhejeFrD1plIsUXN7baXg9G
         vtlpE/AUGnanE/V1zdsXd9e8tRgOSJFVmSwgyFANLzl4tDk0tUO1g6QudYfaB9MS9J
         0eJbIH71JwJvxn3hxZhfunB3CPkduO6FzawuNml8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 291/913] video: fbdev: atmel_lcdfb: fix an error code in atmel_lcdfb_probe()
Date:   Tue,  5 Apr 2022 09:22:33 +0200
Message-Id: <20220405070348.579876453@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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



