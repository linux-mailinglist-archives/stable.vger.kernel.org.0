Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE48E65EBF3
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbjAENEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbjAENES (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:04:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A1A5A884
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:04:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DB67B81AC2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66B7C433D2;
        Thu,  5 Jan 2023 13:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923855;
        bh=w+kbopR9lEp1/FZPvOxTknkJByTEBYiAwaZASAxkz10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg+IUtRb6Gv0OUw1JCjVRYRbphuC+geoGJcMB++rdydCMjPTIUfJJEqHT5CoR91dI
         NAcuTBnXB8ivUdCmB1083DnectPxJZj6rLlcWwOV6n9MxK/kcBTeM45ORKs74gUeZU
         hgztjmBcGOZ4M1fJ6VGZSt1VKlvo4IunKMm9vQHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 154/251] HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
Date:   Thu,  5 Jan 2023 13:54:51 +0100
Message-Id: <20230105125341.872474132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index db9328c05492..9e82f9f8f0a3 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -540,8 +540,10 @@ static int ssi_probe(struct platform_device *pd)
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



