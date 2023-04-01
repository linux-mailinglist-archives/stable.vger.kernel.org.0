Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325546D2CC4
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbjDABnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbjDABnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:43:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C0322E86;
        Fri, 31 Mar 2023 18:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91F73B832F8;
        Sat,  1 Apr 2023 01:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D364C433D2;
        Sat,  1 Apr 2023 01:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313313;
        bh=S8EdIpybQ3dbjkW3l22hV52frnPpXw+QCFHLqqD7EJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CptMEnHmEu3/sbPBa4b6STfRbzHSrJfD6gXugFb0gscPjde9edZNsBeQsMzucD3je
         n9YAhZWushBnkoTP6Kl9h6Ke3tTPG162u9eA0ALlzvFdb7H7KWsCUxdlKahXtcByDp
         W+oNKGxu7jPQX9oRyZ4Q0wTZn6sf5n7IGakXxm0VU0/+ry58eDqbPa3yPexUfNSOC/
         jqLCLaEr4b6ZpQj70P/uBY1BPcbb3TChN6aVm/4EJIcUk8sfVhqDaEsxM0DzWON/Xj
         yzdMPUbd/JASypexk/OaoQC0rF5U2IL8HB6k61rGXF4fekldkLPtxH2lcLaBFU/VnL
         2cV3krBV9fGLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianyi Jing <jingfelix@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 16/25] hwmon: (xgene) Fix ioremap and memremap leak
Date:   Fri, 31 Mar 2023 21:41:14 -0400
Message-Id: <20230401014126.3356410-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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

