Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4111540DF4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347894AbiFGSvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354614AbiFGSra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A680240AE;
        Tue,  7 Jun 2022 11:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B993061804;
        Tue,  7 Jun 2022 18:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94DCC385A5;
        Tue,  7 Jun 2022 18:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624950;
        bh=aGyWqYvWyjA/1VAtWXlscfe1t8nAwgekUlQyFJv6zs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFcEPRvMcRolh+Zb3AelyWQA1ghXYBEmToKIl3rytPnrNjrbWHVVw1a554qR91Uet
         hrFL5BhrjEyqisDMDURg7niwGJTB+Bxd1SXKFFCWUweg+HpOF9j91uq2pRbqqfYgXk
         bMLgxZ+aL4bQ2Vf7H4KPIgaZLU19nX+v5qGyPPaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Ernster <dri-devel@hardfalcon.net>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/667] video: fbdev: vesafb: Fix a use-after-free due early fb_info cleanup
Date:   Tue,  7 Jun 2022 19:02:56 +0200
Message-Id: <20220607164950.028305979@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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



