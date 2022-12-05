Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB36C6432FB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiLETdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiLETc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:32:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8D52CDD7
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00364CE13AB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFB8C433D6;
        Mon,  5 Dec 2022 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268478;
        bh=pFQZTQp8IPievGOgbdheo1gVh0JnyrCO3FHOlMye/sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAPk2uHuFf0Vh0E3pq5QetHt5FCcu8I9PqZnnAFiZvVeiip419l/beLS4/h/Pf2me
         Bs2ABCZmkE1NN/obZGUtooEZTk8YU4kDVnq1aVLPTLFY820hdDfzOnLCMCmuYEWpOY
         QWjIvvSJHK82orx+UNG165S2vWNCxp0wbEhLJptE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Tali Perry <tali.perry@nuvoton.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 116/124] i2c: npcm7xx: Fix error handling in npcm_i2c_init()
Date:   Mon,  5 Dec 2022 20:10:22 +0100
Message-Id: <20221205190811.741049900@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 145900cf91c4b32ac05dbc8675a0c7f4a278749d ]

A problem about i2c-npcm7xx create debugfs failed is triggered with the
following log given:

 [  173.827310] debugfs: Directory 'npcm_i2c' with parent '/' already present!

The reason is that npcm_i2c_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of npcm_i2c can never be created later.

 npcm_i2c_init()
   debugfs_create_dir() # create debugfs directory
   platform_driver_register()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when platform_driver_register() returns error.

Fixes: 56a1485b102e ("i2c: npcm7xx: Add Nuvoton NPCM I2C controller driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Tali Perry <tali.perry@nuvoton.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 0c365b57d957..83457359ec45 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2393,8 +2393,17 @@ static struct platform_driver npcm_i2c_bus_driver = {
 
 static int __init npcm_i2c_init(void)
 {
+	int ret;
+
 	npcm_i2c_debugfs_dir = debugfs_create_dir("npcm_i2c", NULL);
-	return platform_driver_register(&npcm_i2c_bus_driver);
+
+	ret = platform_driver_register(&npcm_i2c_bus_driver);
+	if (ret) {
+		debugfs_remove_recursive(npcm_i2c_debugfs_dir);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(npcm_i2c_init);
 
-- 
2.35.1



