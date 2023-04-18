Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9166C6E64B6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjDRMvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbjDRMvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9150F16FAB
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23DE763441
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3094BC433D2;
        Tue, 18 Apr 2023 12:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822280;
        bh=S8EdIpybQ3dbjkW3l22hV52frnPpXw+QCFHLqqD7EJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBn39K5GVFUd1RQAogIqznJ70brx6vNM+kafNtEeWsGHrj0TmV56DsI3G7+Zs41zN
         UrRi5clDaqudeYv1ycXsMe2IUVYDfuqsvliV81VpblwV9FYQTwpwhCO17I1pNvsXqw
         vaUtg51ZKQh286BabU781jpx2N8XGIcL3ieto52E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tianyi Jing <jingfelix@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 090/139] hwmon: (xgene) Fix ioremap and memremap leak
Date:   Tue, 18 Apr 2023 14:22:35 +0200
Message-Id: <20230418120317.174777132@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyi Jing <jingfelix@hust.edu.cn>

[ Upstream commit 813cc94c7847ae4a17e9f744fb4dbdf7df6bd732 ]

Smatch reports:

drivers/hwmon/xgene-hwmon.c:757 xgene_hwmon_probe() warn:
'ctx->pcc_comm_addr' from ioremap() not released on line: 757.

This is because in drivers/hwmon/xgene-hwmon.c:701 xgene_hwmon_probe(),
ioremap and memremap is not released, which may cause a leak.

To fix this, ioremap and memremap is modified to devm_ioremap and
devm_memremap.

Signed-off-by: Tianyi Jing <jingfelix@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230318143851.2191625-1-jingfelix@hust.edu.cn
[groeck: Fixed formatting and subject]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index d1abea49f01be..78d9f52e2a719 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -698,14 +698,14 @@ static int xgene_hwmon_probe(struct platform_device *pdev)
 		ctx->comm_base_addr = pcc_chan->shmem_base_addr;
 		if (ctx->comm_base_addr) {
 			if (version == XGENE_HWMON_V2)
-				ctx->pcc_comm_addr = (void __force *)ioremap(
-							ctx->comm_base_addr,
-							pcc_chan->shmem_size);
+				ctx->pcc_comm_addr = (void __force *)devm_ioremap(&pdev->dev,
+								  ctx->comm_base_addr,
+								  pcc_chan->shmem_size);
 			else
-				ctx->pcc_comm_addr = memremap(
-							ctx->comm_base_addr,
-							pcc_chan->shmem_size,
-							MEMREMAP_WB);
+				ctx->pcc_comm_addr = devm_memremap(&pdev->dev,
+								   ctx->comm_base_addr,
+								   pcc_chan->shmem_size,
+								   MEMREMAP_WB);
 		} else {
 			dev_err(&pdev->dev, "Failed to get PCC comm region\n");
 			rc = -ENODEV;
-- 
2.39.2



