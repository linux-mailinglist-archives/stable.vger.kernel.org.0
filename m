Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A911D4F27A3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiDEIHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbiDEH7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6245E775;
        Tue,  5 Apr 2022 00:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6977615CD;
        Tue,  5 Apr 2022 07:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D161EC340EE;
        Tue,  5 Apr 2022 07:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145276;
        bh=HWxjACHl9Ir8KVcVfW8mCP3H8HhaV08T+cFUkUDcZTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdlQDIRSdwqWOOS1PLODbnQcX2d8UanFWZuVvcHYbzhYjCSgkJ13p15o17s3GriB0
         vAAPN/0a2KJQ21K6l9yIAADrPzDhmKfAKCCUvf5eoz2tdAUuVnJSxSTiTEurcjHM54
         M9teIK2JN42Xk8cnfjgBS+mW6uL0kD1kyWvxN9Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Nishanth Menon <nm@ti.com>, Dave Gerlach <d-gerlach@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0341/1126] soc: ti: wkup_m3_ipc: Fix IRQ check in wkup_m3_ipc_probe
Date:   Tue,  5 Apr 2022 09:18:08 +0200
Message-Id: <20220405070417.625297451@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c3d66a164c726cc3b072232d3b6d87575d194084 ]

platform_get_irq() returns negative error number instead 0 on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: cdd5de500b2c ("soc: ti: Add wkup_m3_ipc driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Dave Gerlach <d-gerlach@ti.com>
Link: https://lore.kernel.org/r/20220114062840.16620-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/wkup_m3_ipc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/wkup_m3_ipc.c b/drivers/soc/ti/wkup_m3_ipc.c
index 72386bd393fe..2f03ced0f411 100644
--- a/drivers/soc/ti/wkup_m3_ipc.c
+++ b/drivers/soc/ti/wkup_m3_ipc.c
@@ -450,9 +450,9 @@ static int wkup_m3_ipc_probe(struct platform_device *pdev)
 		return PTR_ERR(m3_ipc->ipc_mem_base);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no irq resource\n");
-		return -ENXIO;
+		return irq;
 	}
 
 	ret = devm_request_irq(dev, irq, wkup_m3_txev_handler,
-- 
2.34.1



