Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346C44CC4B4
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 19:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiCCSK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 13:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiCCSK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 13:10:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A0A15FCBE;
        Thu,  3 Mar 2022 10:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 755A4B81E67;
        Thu,  3 Mar 2022 18:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079AAC004E1;
        Thu,  3 Mar 2022 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646330981;
        bh=PmxWgWYYEa9JLK8qebEjp4pPoTL5mDmqZB4piqpOtvM=;
        h=From:To:Cc:Subject:Date:From;
        b=AnmT/FxGaPyzVmDOxrDUnKWgM8sCsnyTdw6HY8X3RrDUHBqeFixlj+U5VsoU00dWF
         p4O5/qlCZeOvBxzdnb4f7kPKkBACygIc6F4bJt9R2WfQWkUeYLfYBTt1yrbSRJY4Q6
         SjaQa2PPzP6h4vU3mTx2p5IlZhAn8P86d/YAn08MduJejbhLVdEtVwTUmXWn9w8iiZ
         f6NPXmvW/CUTdYIbAjY4FIuRC5oIKhd7MR9os9dHq8jMbM9NHYvcsoZZiYl4uvrBrw
         y3WSkm/at/tNvgcJLTAMG1S1D6eyXdlsOxSHWyiYVHSQI6ZeEUb072haepmXQZXFTW
         OsAoGxWvdEokQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nPptT-0000t3-Q6; Thu, 03 Mar 2022 19:09:39 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ARM: mmp: fix platform-device leak on registration errors
Date:   Thu,  3 Mar 2022 19:09:00 +0100
Message-Id: <20220303180900.3371-1-johan@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to free the platform device also in the event that
registration fails.

Fixes: 49cbe78637eb ("[ARM] pxa: add base support for Marvell's PXA168 processor line")
Cc: stable@vger.kernel.org      # 2.6.30
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 arch/arm/mach-mmp/devices.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-mmp/devices.c b/arch/arm/mach-mmp/devices.c
index 18bee66a671f..0b99aa1d5350 100644
--- a/arch/arm/mach-mmp/devices.c
+++ b/arch/arm/mach-mmp/devices.c
@@ -53,20 +53,25 @@ int __init pxa_register_device(struct pxa_device_desc *desc,
 	}
 
 	ret = platform_device_add_resources(pdev, res, nres);
-	if (ret) {
-		platform_device_put(pdev);
-		return ret;
-	}
+	if (ret)
+		goto err_put_device;
 
 	if (data && size) {
 		ret = platform_device_add_data(pdev, data, size);
-		if (ret) {
-			platform_device_put(pdev);
-			return ret;
-		}
+		if (ret)
+			goto err_put_device;
 	}
 
-	return platform_device_add(pdev);
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto err_put_device;
+
+	return 0;
+
+err_put_device:
+	platform_device_put(pdev);
+
+	return ret;
 }
 
 #if IS_ENABLED(CONFIG_USB) || IS_ENABLED(CONFIG_USB_GADGET)
-- 
2.34.1

