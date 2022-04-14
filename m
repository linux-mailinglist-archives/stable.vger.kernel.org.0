Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B8C500F2F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbiDNNZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244282AbiDNNYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:24:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ABA9BB8E;
        Thu, 14 Apr 2022 06:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2170A610A6;
        Thu, 14 Apr 2022 13:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5DCC385A5;
        Thu, 14 Apr 2022 13:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942347;
        bh=c4Vr/hwzGYqpo6BmuyxPjlXTZoR9qkoY3XzDf8x2oL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlAdWWSVvXXyvpVSgIIRwM+AblN0MPCo7VqkFz9F4cuwzNRNxXztd7MNk2ZaMpnYK
         IpFwrcfNrRaBoQwjmnW/TvSfz86cFlaTWpgab6HbevIXe2QlqEIneo0jZ3jTs5/e3i
         JA9Yc4HBsI3oDkQYWZdmTzg4TiJIS5sI8i5IaTzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/338] memory: emif: Add check for setup_interrupts
Date:   Thu, 14 Apr 2022 15:10:05 +0200
Message-Id: <20220414110841.805835810@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit fd7bd80b46373887b390852f490f21b07e209498 ]

As the potential failure of the devm_request_threaded_irq(),
it should be better to check the return value of the
setup_interrupts() and return error if fails.

Fixes: 68b4aee35d1f ("memory: emif: add interrupt and temperature handling")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220224025444.3256530-1-jiasheng@iscas.ac.cn
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 1c6b2cc6269a..8fd97b1b1efb 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1517,7 +1517,7 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 {
 	struct emif_data	*emif;
 	struct resource		*res;
-	int			irq;
+	int			irq, ret;
 
 	if (pdev->dev.of_node)
 		emif = of_get_memory_device_details(pdev->dev.of_node, &pdev->dev);
@@ -1551,7 +1551,9 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	emif_onetime_settings(emif);
 	emif_debugfs_init(emif);
 	disable_and_clear_all_interrupts(emif);
-	setup_interrupts(emif, irq);
+	ret = setup_interrupts(emif, irq);
+	if (ret)
+		goto error;
 
 	/* One-time actions taken on probing the first device */
 	if (!emif1) {
-- 
2.34.1



