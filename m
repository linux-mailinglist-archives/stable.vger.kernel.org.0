Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B794F2793
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiDEIHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiDEH6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412EBABF47;
        Tue,  5 Apr 2022 00:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF572B81B9C;
        Tue,  5 Apr 2022 07:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1B7C340EE;
        Tue,  5 Apr 2022 07:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145198;
        bh=SiWQfNK6upuvyL25sOXXFwldcQxeRu/FiH4eEINwg/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOEO2g2adwBEk1w55NJyndios5RY+hAOFVDFPAZU6af20KlBWgQuzHedgmJSnmjVZ
         03pS4imooj82+lq57iF1SYG1LIDmqpM63tCykQGzA49wwjMR+3s4g3wVPdQnpxbcOp
         iTsQpW+kxOdttr5vp7iJa1RWhUt+YNJnW7k0K73U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0320/1126] video: fbdev: atmel_lcdfb: fix an error code in atmel_lcdfb_probe()
Date:   Tue,  5 Apr 2022 09:17:47 +0200
Message-Id: <20220405070417.008847582@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



