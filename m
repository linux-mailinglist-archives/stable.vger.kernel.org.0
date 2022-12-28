Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802C4658091
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiL1QSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiL1QRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0E512AEA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67E6FB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCE7C433F0;
        Wed, 28 Dec 2022 16:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244184;
        bh=FT4N1aMzM8pZb8mQNTjaDfiFq8UWFOlBIazXhZGXa3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEjZaMttM3U1VX7SW+7f9zjnwzBYZXTk8uP9rNMoV1tOIhJ4K9cMDnBL3Jxnp4wZc
         5iGV4fn63fZhiqC+hNErWXAq8tlWTyPc7TJYJWgNI63P4wX2SzuOvM53TPnG6M+fJ+
         ppkA359WHCGe2QhAcwntezgbjkBTFwXYGMw30mjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0665/1073] serial: 8250_bcm7271: Fix error handling in brcmuart_init()
Date:   Wed, 28 Dec 2022 15:37:33 +0100
Message-Id: <20221228144346.106341931@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 6a3ff858915fa8ca36c7eb02c87c9181ae2fc333 ]

A problem about 8250_bcm7271 create debugfs failed is triggered with the
following log given:

 [  324.516635] debugfs: Directory 'bcm7271-uart' with parent '/' already present!

The reason is that brcmuart_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of 8250_bcm7271 can never be created later.

 brcmuart_init()
   debugfs_create_dir() # create debugfs directory
   platform_driver_register()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when platform_driver_register() returns error.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221109072110.117291-2-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_bcm7271.c b/drivers/tty/serial/8250/8250_bcm7271.c
index 8efdc271eb75..5e0ffd6c4789 100644
--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1212,9 +1212,17 @@ static struct platform_driver brcmuart_platform_driver = {
 
 static int __init brcmuart_init(void)
 {
+	int ret;
+
 	brcmuart_debugfs_root = debugfs_create_dir(
 		brcmuart_platform_driver.driver.name, NULL);
-	return platform_driver_register(&brcmuart_platform_driver);
+	ret = platform_driver_register(&brcmuart_platform_driver);
+	if (ret) {
+		debugfs_remove_recursive(brcmuart_debugfs_root);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(brcmuart_init);
 
-- 
2.35.1



