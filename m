Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1775E69CC33
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjBTNiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjBTNiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:38:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13783C15
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:38:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B76CB80D43
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9971C433D2;
        Mon, 20 Feb 2023 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900283;
        bh=W48JW8SGQpmmpjj3KFiSG+ufrG0SIWY/T3msLhP+P3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbrnfyqd6AntfeRSDqdlUN6yqCy4Gg/AAMcbEpmGKrrkqJOU84n+GPWhaqkJUXKGe
         Bq4CKCkmJ3w9nypZ8XgThD27sGBCWtM6bsyhQTAmdFPdJ/DeIPO4B+V0Oof/0lmW1o
         0zrHiQ9dt+ZMOCA6GB+kf9qPW81Bi3Rk/Gm/Kj9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/53] bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()
Date:   Mon, 20 Feb 2023 14:35:28 +0100
Message-Id: <20230220133548.258767532@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
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
index d3fb350dc9ee..bf4db708f0bd 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -783,7 +783,13 @@ static int __init sunxi_rsb_init(void)
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



