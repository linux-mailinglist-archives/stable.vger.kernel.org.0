Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070206579A7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbiL1PDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiL1PDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94790E7D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3177261540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D3CC433D2;
        Wed, 28 Dec 2022 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239801;
        bh=HYvGODctq/5rLDUBG29sPClg+MD7Rh8TIZ7V34lHyK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfO+U0811wlZKBiHORPpWv0Sd0vTR6h3sLoQ+bITq96xAsrLCeqmqNSz21oAcWkCp
         bPcXCRtS0hD4dqiCbxjHypQubqnIi/wb3kkzujJXufW/DcmlQdzIUktpjw/YjkQx1U
         kyU6/wZ+vtu2YyKZlZLgO5ZEYKMgw8OZOAwO+UMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Sven Peter <sven@svenpeter.dev>,
        Hector Martin <marcan@marcan.st>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0080/1073] soc: apple: sart: Stop casting function pointer signatures
Date:   Wed, 28 Dec 2022 15:27:48 +0100
Message-Id: <20221228144330.240339289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 422d0b860dc223b5dfc6d083697cae258bb5a4a1 ]

Fixes: b170143ae111 ("soc: apple: Add SART driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/apple/sart.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/apple/sart.c b/drivers/soc/apple/sart.c
index 83804b16ad03..afa111736899 100644
--- a/drivers/soc/apple/sart.c
+++ b/drivers/soc/apple/sart.c
@@ -164,6 +164,11 @@ static int apple_sart_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static void apple_sart_put_device(void *dev)
+{
+	put_device(dev);
+}
+
 struct apple_sart *devm_apple_sart_get(struct device *dev)
 {
 	struct device_node *sart_node;
@@ -187,7 +192,7 @@ struct apple_sart *devm_apple_sart_get(struct device *dev)
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	ret = devm_add_action_or_reset(dev, (void (*)(void *))put_device,
+	ret = devm_add_action_or_reset(dev, apple_sart_put_device,
 				       &sart_pdev->dev);
 	if (ret)
 		return ERR_PTR(ret);
-- 
2.35.1



