Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16554CC49C
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiCCSGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 13:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbiCCSGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 13:06:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6C91A361D;
        Thu,  3 Mar 2022 10:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EAE04CE2831;
        Thu,  3 Mar 2022 18:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084EDC004E1;
        Thu,  3 Mar 2022 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646330758;
        bh=F9iwprtNaRJjBnUEjFdmW6ta4K/2GnymPy2rVBQRnus=;
        h=From:To:Cc:Subject:Date:From;
        b=rxglb5n9L5ar78FZqpSuQHzrodJqPiY9ewfpeAr8xuHubq7EIeXsdg+0Rp3+aSsdw
         5ydA0g6soKieQra0goN1kvE7TowKPy813ncxQUWPhI8PFUdwgoOoGXhSLknpVcHlus
         5kB/Svua4rPEJDY2ENgvHeKB+k70Zk0rWvWxokh+Eeu4i1hLrYDjeJ4Tu+5cYN7ScH
         76jat2/M5Ao3jW8CnQOgDISrT6B+J87beDNyAJaiOl1cblQz3fO9h6/5tcRUAW3eb+
         yedMIFPci+QJm9yZGXBUEL1rLm63VxLtpqKKu0+ks/X0qHnFSv9S218D+2jDUZkGAP
         OvXtfGZZQYDlA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nPpps-0000on-Mk; Thu, 03 Mar 2022 19:05:56 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH] firmware: sysfb: fix platform-device leak in error path
Date:   Thu,  3 Mar 2022 19:05:19 +0100
Message-Id: <20220303180519.3117-1-johan@kernel.org>
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

Make sure to free the platform device also in the unlikely event that
registration fails.

Fixes: 0589e8889dce ("drivers/firmware: Add missing platform_device_put() in sysfb_create_simplefb")
Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Cc: stable@vger.kernel.org      # 5.14
Cc: Miaoqian Lin <linmq006@gmail.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/firmware/sysfb_simplefb.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/sysfb_simplefb.c b/drivers/firmware/sysfb_simplefb.c
index 303a491e520d..757cc8b9f3de 100644
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -113,16 +113,21 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	sysfb_apply_efi_quirks(pd);
 
 	ret = platform_device_add_resources(pd, &res, 1);
-	if (ret) {
-		platform_device_put(pd);
-		return ret;
-	}
+	if (ret)
+		goto err_put_device;
 
 	ret = platform_device_add_data(pd, mode, sizeof(*mode));
-	if (ret) {
-		platform_device_put(pd);
-		return ret;
-	}
+	if (ret)
+		goto err_put_device;
+
+	ret = platform_device_add(pd);
+	if (ret)
+		goto err_put_device;
+
+	return 0;
+
+err_put_device:
+	platform_device_put(pd);
 
-	return platform_device_add(pd);
+	return ret;
 }
-- 
2.34.1

