Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF8A4F2C65
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbiDEI60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiDEIlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:41:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3846B1031;
        Tue,  5 Apr 2022 01:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD837B81B13;
        Tue,  5 Apr 2022 08:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D820C385A2;
        Tue,  5 Apr 2022 08:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147627;
        bh=lerBgQkdf9cnh0z/qLfVS+BV9J0u5dRvXHPnTlbTwuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AakYe7Ya+PquM95BUd17N6UFs0zkQblqm0HhpxxsRXxjX0HPKJaLrP/PnNaJscEAb
         q7F9g/KgC8y8TkjYXYyLqcNOXyD2mh9Q4TndHvqkoBq+xV1MgdGeh0Z2pma6CeIOle
         0J2kFyyUj+23boVtJxH9p8R2hG32ZPeeY0uRfV1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.16 0063/1017] firmware: sysfb: fix platform-device leak in error path
Date:   Tue,  5 Apr 2022 09:16:16 +0200
Message-Id: <20220405070356.056498410@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 202c08914ba50dd324e42d5ad99535a89f242560 upstream.

Make sure to free the platform device also in the unlikely event that
registration fails.

Fixes: 0589e8889dce ("drivers/firmware: Add missing platform_device_put() in sysfb_create_simplefb")
Fixes: 8633ef82f101 ("drivers/firmware: consolidate EFI framebuffer setup for all arches")
Cc: stable@vger.kernel.org      # 5.14
Cc: Miaoqian Lin <linmq006@gmail.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20220303180519.3117-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/sysfb_simplefb.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -113,16 +113,21 @@ __init int sysfb_create_simplefb(const s
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
 
-	return platform_device_add(pd);
+	ret = platform_device_add(pd);
+	if (ret)
+		goto err_put_device;
+
+	return 0;
+
+err_put_device:
+	platform_device_put(pd);
+
+	return ret;
 }


