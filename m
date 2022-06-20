Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB9D551F75
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiFTO4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241643AbiFTOzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:55:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17F959971;
        Mon, 20 Jun 2022 07:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606EA60EAB;
        Mon, 20 Jun 2022 14:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78F7C3411B;
        Mon, 20 Jun 2022 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655734473;
        bh=PPCdeS+2XDRfjEPcn2kexd2bRxaYKO9xJ1qMW6/4C/M=;
        h=From:To:Cc:Subject:Date:From;
        b=X5A1Bq8j+3aOZuH0OfuzedSC4UeZkxK3Mib52D8qIZ92kTE3wcKAC+aUZGQDab6Y9
         Xsl7fB0P4zlv02dWja5s7lbsT6cYFWwKjCguNk/Bjxnbwy0qHp7rcgKFE8sJX1LL0n
         AabCVtoPgqVPJnbCIQIqqk/D3o51qxDLcZZ4JYjZTWYVZaYEZhghKC0BFmc+O2GpUt
         RJ2v0cjIgxiZbRQXLhphcbrZmRUE+fAaPfBQ6LeyFPLpfM7M3GdCEnOY9shuv3xpB5
         ESUyhAWFP8623BvXLcntzhIjtykSSb56uOUL18yQhYjpCij2NLqTlLowTXLqZLwCEG
         nX8SS3/bFfJwA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1o3IAe-0002ds-Gw; Mon, 20 Jun 2022 16:14:29 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Lubomir Rintel <lkundrak@v3.sk>, Arnd Bergmann <arnd@arndb.de>
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH RESEND] ARM: mmp: fix platform-device leak on registration errors
Date:   Mon, 20 Jun 2022 16:14:06 +0200
Message-Id: <20220620141406.10122-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

It's been almost four months so resending.

Arnd, can you pick this one up if Lubomir isn't around anymore?

Johan


 arch/arm/mach-mmp/devices.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-mmp/devices.c b/arch/arm/mach-mmp/devices.c
index 79f4a2aa5475..dfb072d788ff 100644
--- a/arch/arm/mach-mmp/devices.c
+++ b/arch/arm/mach-mmp/devices.c
@@ -53,20 +53,25 @@ int __init mmp_register_device(struct mmp_device_desc *desc,
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
2.35.1

