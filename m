Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F108766CD07
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbjAPRcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbjAPRcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:32:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1135D128
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A97B061055
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED91C433D2;
        Mon, 16 Jan 2023 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888917;
        bh=MpYlnlvwfUKN3dT5u/JDR3k62p8CeHkdfZ7yiTlcc4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5R1bm3+KAgfYoKFFtX70HJ+aBOjiFmPd99OPpCZB/r/t/VNt6eGp//1eO3IzN0jb
         l4cdGcIwE0CcIhxu7kaJdTKN7b8316O+EH+0Tm3V4jyC2M3bWa6bHfXdZx7VnP9dNi
         +4txkp4vW7FSnOn5AvoIwt58yp3Hw94fZfy4h5Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 189/338] HSI: omap_ssi_core: Fix error handling in ssi_init()
Date:   Mon, 16 Jan 2023 16:51:02 +0100
Message-Id: <20230116154829.181876662@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit 3ffa9f713c39a213a08d9ff13ab983a8aa5d8b5d ]

The ssi_init() returns the platform_driver_register() directly without
checking its return value, if platform_driver_register() failed, the
ssi_pdriver is not unregistered.
Fix by unregister ssi_pdriver when the last platform_driver_register()
failed.

Fixes: 0fae198988b8 ("HSI: omap_ssi: built omap_ssi and omap_ssi_port into one module")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index fa3835ec5104..09653b064d93 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -667,7 +667,13 @@ static int __init ssi_init(void) {
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&ssi_port_pdriver);
+	ret = platform_driver_register(&ssi_port_pdriver);
+	if (ret) {
+		platform_driver_unregister(&ssi_pdriver);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(ssi_init);
 
-- 
2.35.1



