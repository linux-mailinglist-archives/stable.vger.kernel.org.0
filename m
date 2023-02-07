Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395FC68D75A
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjBGM7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjBGM7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:59:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B92B7DB1
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14488613DC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14897C433D2;
        Tue,  7 Feb 2023 12:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774738;
        bh=9VaiK9SBPSI6Yx4SwO9EFQtvHkLkGbBjC2w1snU0gTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCIXEy3VWBtnF+RYWYp9V2xU/TmwREgeFr9LoXDh9vTACSOeWv4ihw5c5puF7P1W1
         hnmxjcncmSgQLieQEFREPkAizpg/qSBI9xt4yd4PZmPP6R5wWcfQEGOcIqbbPBAGib
         b9Lii51eKj5uvXTAJe/sDyuTb7ToMyFUREh0djDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/208] bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()
Date:   Tue,  7 Feb 2023 13:54:16 +0100
Message-Id: <20230207125634.428770362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit f71eaf2708be7831428eacae7db25d8ec6b8b4c5 ]

The sunxi_rsb_init() returns the platform_driver_register() directly
without checking its return value, if platform_driver_register() failed,
the sunxi_rsb_bus is not unregistered.
Fix by unregister sunxi_rsb_bus when platform_driver_register() failed.

Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced Serial Bus")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221123094200.12036-1-yuancan@huawei.com
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 3aa91aed3bf7..226e87b85116 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -857,7 +857,13 @@ static int __init sunxi_rsb_init(void)
 		return ret;
 	}
 
-	return platform_driver_register(&sunxi_rsb_driver);
+	ret = platform_driver_register(&sunxi_rsb_driver);
+	if (ret) {
+		bus_unregister(&sunxi_rsb_bus);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(sunxi_rsb_init);
 
-- 
2.39.0



