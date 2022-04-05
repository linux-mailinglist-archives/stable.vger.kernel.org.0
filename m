Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D84B4F3E3E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240827AbiDEMMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358402AbiDEK2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B08BA0BCC;
        Tue,  5 Apr 2022 03:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C39CFB81C98;
        Tue,  5 Apr 2022 10:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0C4C385A0;
        Tue,  5 Apr 2022 10:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153877;
        bh=m2IoJP+1rZGsRK63zzk0z+bTCLuNZ8qbNXqYGWwlq2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nd29em+4M015ixqTQBqzgAS4MRqnIO77aWX6eYfDL40G2d10TTJruuHVMNSXwxuJS
         wUvl24wPFbL0ugVWi2OF9H03s/q7WzhXLvNbLarwT4ky/83rxnew+XUoIoRrpcAZt/
         q5DcDy/xPCFrOMGUGBrAdVPMIlfESBmelY5SavY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/599] fsi: aspeed: convert to devm_platform_ioremap_resource
Date:   Tue,  5 Apr 2022 09:31:14 +0200
Message-Id: <20220405070310.139207610@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit a3469912f4caeea32ecbe0bf472b14634fecb38e ]

Use devm_platform_ioremap_resource() to simplify code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20191228190631.26777-1-tiny.windzz@gmail.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-master-aspeed.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/fsi/fsi-master-aspeed.c b/drivers/fsi/fsi-master-aspeed.c
index dbad73162c83..5d2469d44607 100644
--- a/drivers/fsi/fsi-master-aspeed.c
+++ b/drivers/fsi/fsi-master-aspeed.c
@@ -525,7 +525,6 @@ static int tacoma_cabled_fsi_fixup(struct device *dev)
 static int fsi_master_aspeed_probe(struct platform_device *pdev)
 {
 	struct fsi_master_aspeed *aspeed;
-	struct resource *res;
 	int rc, links, reg;
 	__be32 raw;
 
@@ -541,8 +540,7 @@ static int fsi_master_aspeed_probe(struct platform_device *pdev)
 
 	aspeed->dev = &pdev->dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	aspeed->base = devm_ioremap_resource(&pdev->dev, res);
+	aspeed->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(aspeed->base))
 		return PTR_ERR(aspeed->base);
 
-- 
2.34.1



