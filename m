Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D0A542607
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379826AbiFHBOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1838769AbiFHACJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:02:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F61E2BB28;
        Tue,  7 Jun 2022 12:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E210561931;
        Tue,  7 Jun 2022 19:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAB1C385A2;
        Tue,  7 Jun 2022 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629480;
        bh=aGyWqYvWyjA/1VAtWXlscfe1t8nAwgekUlQyFJv6zs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmGiBPpsUUksReR9sJ5CeNBmhOtZHY0Yaf0NoYTgbL7BvNQFZl/eyA48TbBWo5nuC
         gSQxf1tsM/4o/pd7HRfRlvHrDAaTyR5IuitAAsbledtOjCDO42PMAn2TD3F7ETdeSA
         ejUn6eHPCHk+NtDXl76iKWEOZVLYqTXC16ZAyRN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Ernster <dri-devel@hardfalcon.net>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 705/879] video: fbdev: vesafb: Fix a use-after-free due early fb_info cleanup
Date:   Tue,  7 Jun 2022 19:03:43 +0200
Message-Id: <20220607165023.310688894@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit acde4003efc16480375543638484d8f13f2e99a3 ]

Commit b3c9a924aab6 ("fbdev: vesafb: Cleanup fb_info in .fb_destroy rather
than .remove") fixed a use-after-free error due the vesafb driver freeing
the fb_info in the .remove handler instead of doing it in .fb_destroy.

This can happen if the .fb_destroy callback is executed after the .remove
callback, since the former tries to access a pointer freed by the latter.

But that change didn't take into account that another possible scenario is
that .fb_destroy is called before the .remove callback. For example, if no
process has the fbdev chardev opened by the time the driver is removed.

If that's the case, fb_info will be freed when unregister_framebuffer() is
called, making the fb_info pointer accessed in vesafb_remove() after that
to no longer be valid.

To prevent that, move the expression containing the info->par to happen
before the unregister_framebuffer() function call.

Fixes: b3c9a924aab6 ("fbdev: vesafb: Cleanup fb_info in .fb_destroy rather than .remove")
Reported-by: Pascal Ernster <dri-devel@hardfalcon.net>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Pascal Ernster <dri-devel@hardfalcon.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vesafb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/vesafb.c b/drivers/video/fbdev/vesafb.c
index e25e8de5ff67..929d4775cb4b 100644
--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -490,11 +490,12 @@ static int vesafb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 
-	/* vesafb_destroy takes care of info cleanup */
-	unregister_framebuffer(info);
 	if (((struct vesafb_par *)(info->par))->region)
 		release_region(0x3c0, 32);
 
+	/* vesafb_destroy takes care of info cleanup */
+	unregister_framebuffer(info);
+
 	return 0;
 }
 
-- 
2.35.1



