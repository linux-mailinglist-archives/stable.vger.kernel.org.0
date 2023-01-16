Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8575066CB20
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjAPRK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbjAPRKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:10:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B787D31E19
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:50:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54A1B61050
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6641EC433EF;
        Mon, 16 Jan 2023 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887836;
        bh=tPzSE8FkuJ/C3ZSqnI8oDnyHherpgB4blqJuabmfgpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B+S6N39pZpPpLWExJ72aAyIfmyZBIsbKc5B4cuXvBzC4ZMnbROgajrvAJcwJyMlLY
         pPxpuP6oTltaXVu1UpioDCv6qtnpl0040jq49aunWoUYqddUMzba0EuU1+vU6SXuTn
         /pLpIKv9PcMe6iPY9OXHEoa7oq2uXWHeV96v7/uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 260/521] HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
Date:   Mon, 16 Jan 2023 16:48:42 +0100
Message-Id: <20230116154858.751919956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1aff514e1d2bd47854dbbdf867970b9d463d4c57 ]

If ssi_add_controller() returns error, it should call hsi_put_controller()
to give up the reference that was set in hsi_alloc_controller(), so that
it can call hsi_controller_release() to free controller and ports that
allocated in hsi_alloc_controller().

Fixes: b209e047bc74 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index b91a6b6c0d7a..2f1a576fa8b7 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -538,8 +538,10 @@ static int ssi_probe(struct platform_device *pd)
 	platform_set_drvdata(pd, ssi);
 
 	err = ssi_add_controller(ssi, pd);
-	if (err < 0)
+	if (err < 0) {
+		hsi_put_controller(ssi);
 		goto out1;
+	}
 
 	pm_runtime_enable(&pd->dev);
 
-- 
2.35.1



