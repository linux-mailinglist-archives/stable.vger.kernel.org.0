Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05549680F72
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbjA3Nxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbjA3Nxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:53:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9417F25E38
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 459C3B81145
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB8EC433D2;
        Mon, 30 Jan 2023 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086826;
        bh=FxERe+RFUM5rPkiZbMMrkk1q7F2XS/VoDUBqXu9nvOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBNwWTM8LJSJbOpOFPiApgRvgGqCpxO+k7HNyBJeAVmtOBvtxIEJYxvcIOUZUM8V1
         MsvUu3HZxO1wlx/I11WCJDnX8EQxstJMkW/H4XzcWjv5wmBKNR1cF7J96lmx/gxJuS
         z3VsJlk6TcaDXviUAxkdgeawpi4j/SgPWPicyZCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/313] memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
Date:   Mon, 30 Jan 2023 14:47:18 +0100
Message-Id: <20230130134336.705563096@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit cb8fd6f75775165390ededea8799b60d93d9fe3e ]

The clk_disable_unprepare() should be called in the error handling
of devbus_get_timing_params() and of_platform_populate(), fix it by
replacing devm_clk_get and clk_prepare_enable by devm_clk_get_enabled.

Fixes: e81b6abebc87 ("memory: add a driver for atmel ram controllers")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221126044911.7226-1-cuigaosheng1@huawei.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mvebu-devbus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/memory/mvebu-devbus.c b/drivers/memory/mvebu-devbus.c
index 8450638e8670..efc6c08db2b7 100644
--- a/drivers/memory/mvebu-devbus.c
+++ b/drivers/memory/mvebu-devbus.c
@@ -280,10 +280,9 @@ static int mvebu_devbus_probe(struct platform_device *pdev)
 	if (IS_ERR(devbus->base))
 		return PTR_ERR(devbus->base);
 
-	clk = devm_clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
-	clk_prepare_enable(clk);
 
 	/*
 	 * Obtain clock period in picoseconds,
-- 
2.39.0



