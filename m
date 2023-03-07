Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6386AF45A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCGTQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbjCGTP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B833ECD675
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:59:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7108EB819DB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1C5C433EF;
        Tue,  7 Mar 2023 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215564;
        bh=0S5KOoV/ncGrp8GHU8QvzaVGsx4NlOYxUlI/cKNwpFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZT6A6dJzehomx1PBJsGDfP1yUoOVgA1QX5Hod1HZQsDN0UlYieZM+PzVPi2GJAeC5
         2dPHooQakDaXL3YdjED7mXUDgiLzacQl2YggMMXkpDoNs2kAUdiQiBGCdh5tTajkyD
         CNWcivX6ov0nUCYu3+Lb7+THqfQVMivT/AbOEYmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/567] eeprom: idt_89hpesx: Fix error handling in idt_init()
Date:   Tue,  7 Mar 2023 18:00:39 +0100
Message-Id: <20230307165918.991645116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit d717a3ab282f51ec45142f911f7ef8a55c057de5 ]

A problem about idt_89hpesx create debugfs failed is triggered with the
following log given:

 [ 4973.269647] debugfs: Directory 'idt_csr' with parent '/' already present!

The reason is that idt_init() returns i2c_add_driver() directly without
checking its return value, if i2c_add_driver() failed, it returns without
destroy the newly created debugfs, resulting the debugfs of idt_csr can
never be created later.

 idt_init()
   debugfs_create_dir() # create debugfs directory
   i2c_add_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when i2c_add_driver() returns error.

Fixes: cfad6425382e ("eeprom: Add IDT 89HPESx EEPROM/CSR driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20221110020030.47711-1-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/idt_89hpesx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index 7f430742ce2b8..5298be4cc14c1 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -1568,12 +1568,20 @@ static struct i2c_driver idt_driver = {
  */
 static int __init idt_init(void)
 {
+	int ret;
+
 	/* Create Debugfs directory first */
 	if (debugfs_initialized())
 		csr_dbgdir = debugfs_create_dir("idt_csr", NULL);
 
 	/* Add new i2c-device driver */
-	return i2c_add_driver(&idt_driver);
+	ret = i2c_add_driver(&idt_driver);
+	if (ret) {
+		debugfs_remove_recursive(csr_dbgdir);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(idt_init);
 
-- 
2.39.2



