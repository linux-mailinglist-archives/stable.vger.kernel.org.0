Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1623066C805
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbjAPQgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbjAPQfq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2FE2A9B6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:23:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89E30B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D51C433EF;
        Mon, 16 Jan 2023 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886222;
        bh=6Cne0Sf0RPZkqfar30BzvE96gZBNOxHiDPmYjm1mVT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kp9iRFOEBgviCLJjK4FT1H811RPYLYYVbO6soBgiNJtDDWdqMeNbQBAk68ZaEfPb4
         9G5EX5+ayXP01y2kW2KtxbOKvq/rr5EGmDBnsMsD1ZNWc3o7ogCWfJ7vv0ACAc34US
         S/4EmhSp47wkxUP35vxgo6DKFeKviV7rZvNbIcQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 318/658] fbdev: via: Fix error in via_core_init()
Date:   Mon, 16 Jan 2023 16:46:46 +0100
Message-Id: <20230116154924.117719084@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 5886b130de953cfb8826f7771ec8640a79934a7f ]

via_core_init() won't exit the driver when pci_register_driver() failed.
Exit the viafb-i2c and the viafb-gpio in failed path to prevent error.

VIA Graphics Integration Chipset framebuffer 2.4 initializing
Error: Driver 'viafb-i2c' is already registered, aborting...
Error: Driver 'viafb-gpio' is already registered, aborting...

Fixes: 7582eb9be85f ("viafb: Turn GPIO and i2c into proper platform devices")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/via/via-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/via/via-core.c b/drivers/video/fbdev/via/via-core.c
index ffa2ca2d3f5e..ce366b80bda4 100644
--- a/drivers/video/fbdev/via/via-core.c
+++ b/drivers/video/fbdev/via/via-core.c
@@ -732,7 +732,14 @@ static int __init via_core_init(void)
 		return ret;
 	viafb_i2c_init();
 	viafb_gpio_init();
-	return pci_register_driver(&via_driver);
+	ret = pci_register_driver(&via_driver);
+	if (ret) {
+		viafb_gpio_exit();
+		viafb_i2c_exit();
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit via_core_exit(void)
-- 
2.35.1



