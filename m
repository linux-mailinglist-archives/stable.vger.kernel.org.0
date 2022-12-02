Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85F463FF90
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 05:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiLBEtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 23:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiLBEtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 23:49:23 -0500
X-Greylist: delayed 358 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Dec 2022 20:49:21 PST
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E53C86A1
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 20:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669956191;
    s=strato-dkim-0002; d=fpond.eu;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=IdGuSGV/YIZ3BjoERql7QLPxNj+KYlJHQQXVEdWLRyM=;
    b=ZJpw9zo78+TAFC0Az3kAqfiZXsnrLnWKtUcXFgmcfydTxtC66fqIpQ/H7MflqGfVIy
    SDR0XsKFVH1A+CZwtMQ7KwmRnOt51Ss4nDh3V4drIfG9/pepSoEDsTnr4jv8zesH7nZW
    2PcCXqJUjfNHX4Vskz7AMARQ4aUuInuzc3yE/GKx9j11qEWi/lF+teHsdvdvbbLCwwmI
    ZYC7RG2uYfimRUm20vrBdvc59HSOz7BpR72/f8OJGos7mSyT0LUnCfma9VCouzP3BkKK
    i1FiwZyxbmuHaHZcXHoOTY7cISOglsAOXR7AJ1LRXpjx6bGoUhiJfoaL9UdKxdBBZ1xf
    HTSg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvJ6ahE0tJ2eGbzyHbp+Js="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
    by smtp.strato.de (RZmta 48.2.1 SBL|AUTH)
    with ESMTPSA id y28384yB24h8tkL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 2 Dec 2022 05:43:08 +0100 (CET)
From:   Ulrich Hecht <uli+cip@fpond.eu>
To:     stable@vger.kernel.org
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        Ulrich Hecht <uli+cip@fpond.eu>
Subject: [PATCH 4.9] Revert "fbdev: fb_pm2fb: Avoid potential divide by zero error"
Date:   Fri,  2 Dec 2022 05:42:53 +0100
Message-Id: <20221202044253.516827-1-uli+cip@fpond.eu>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6577e903a9e193ad70f2db92eba57c4f335afd1a. It's a
duplicate of a commit that is already in this tree
(0f1174f4972ea9fad6becf8881d71adca8e9ca91).

Signed-off-by: Ulrich Hecht <uli+cip@fpond.eu>
---
 drivers/video/fbdev/pm2fb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index 50b569d047b10..9b32b9fc44a5c 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -619,11 +619,6 @@ static int pm2fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		return -EINVAL;
 	}
 
-	if (!var->pixclock) {
-		DPRINTK("pixclock is zero\n");
-		return -EINVAL;
-	}
-
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));
-- 
2.30.2

