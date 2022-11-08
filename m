Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833006214F7
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiKHOHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbiKHOHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:07:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AA0686B8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:07:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA334615AF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0332C433D6;
        Tue,  8 Nov 2022 14:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916422;
        bh=lZNGElepxxP2RGczUi6cc5QjO7PuSs5B/SdPKZpE9zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwRPqUZMGGk+qcJu2ycvM0QF0yKP3ZIBNG7CojHipzHUSe8qzid1SLinazmch1pJC
         Or5ci2TGg7g4K8aLDPs4gCEGgxbHgxtVijhwimjCkmHiEw2LmEZ1fnuJ0OlEfQxztx
         3mbhAf8uQH1OzKMJAutpOdBdkdcRhZi27m9mqIrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 016/197] net: dsa: Fix possible memory leaks in dsa_loop_init()
Date:   Tue,  8 Nov 2022 14:37:34 +0100
Message-Id: <20221108133355.505333892@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 633efc8b3dc96f56f5a57f2a49764853a2fa3f50 ]

kmemleak reported memory leaks in dsa_loop_init():

kmemleak: 12 new suspected memory leaks

unreferenced object 0xffff8880138ce000 (size 2048):
  comm "modprobe", pid 390, jiffies 4295040478 (age 238.976s)
  backtrace:
    [<000000006a94f1d5>] kmalloc_trace+0x26/0x60
    [<00000000a9c44622>] phy_device_create+0x5d/0x970
    [<00000000d0ee2afc>] get_phy_device+0xf3/0x2b0
    [<00000000dca0c71f>] __fixed_phy_register.part.0+0x92/0x4e0
    [<000000008a834798>] fixed_phy_register+0x84/0xb0
    [<0000000055223fcb>] dsa_loop_init+0xa9/0x116 [dsa_loop]
    ...

There are two reasons for memleak in dsa_loop_init().

First, fixed_phy_register() create and register phy_device:

fixed_phy_register()
  get_phy_device()
    phy_device_create() # freed by phy_device_free()
  phy_device_register() # freed by phy_device_remove()

But fixed_phy_unregister() only calls phy_device_remove().
So the memory allocated in phy_device_create() is leaked.

Second, when mdio_driver_register() fail in dsa_loop_init(),
it just returns and there is no cleanup for phydevs.

Fix the problems by catching the error of mdio_driver_register()
in dsa_loop_init(), then calling both fixed_phy_unregister() and
phy_device_free() to release phydevs.
Also add a function for phydevs cleanup to avoid duplacate.

Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/dsa_loop.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 263e41191c29..0d20ebafbd03 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -378,6 +378,17 @@ static struct mdio_driver dsa_loop_drv = {
 
 #define NUM_FIXED_PHYS	(DSA_LOOP_NUM_PORTS - 2)
 
+static void dsa_loop_phydevs_unregister(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < NUM_FIXED_PHYS; i++)
+		if (!IS_ERR(phydevs[i])) {
+			fixed_phy_unregister(phydevs[i]);
+			phy_device_free(phydevs[i]);
+		}
+}
+
 static int __init dsa_loop_init(void)
 {
 	struct fixed_phy_status status = {
@@ -385,23 +396,23 @@ static int __init dsa_loop_init(void)
 		.speed = SPEED_100,
 		.duplex = DUPLEX_FULL,
 	};
-	unsigned int i;
+	unsigned int i, ret;
 
 	for (i = 0; i < NUM_FIXED_PHYS; i++)
 		phydevs[i] = fixed_phy_register(PHY_POLL, &status, NULL);
 
-	return mdio_driver_register(&dsa_loop_drv);
+	ret = mdio_driver_register(&dsa_loop_drv);
+	if (ret)
+		dsa_loop_phydevs_unregister();
+
+	return ret;
 }
 module_init(dsa_loop_init);
 
 static void __exit dsa_loop_exit(void)
 {
-	unsigned int i;
-
 	mdio_driver_unregister(&dsa_loop_drv);
-	for (i = 0; i < NUM_FIXED_PHYS; i++)
-		if (!IS_ERR(phydevs[i]))
-			fixed_phy_unregister(phydevs[i]);
+	dsa_loop_phydevs_unregister();
 }
 module_exit(dsa_loop_exit);
 
-- 
2.35.1



