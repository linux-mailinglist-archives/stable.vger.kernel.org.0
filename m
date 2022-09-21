Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A4F5C029F
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiIUPy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiIUPxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:53:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129798307C;
        Wed, 21 Sep 2022 08:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A641C6312C;
        Wed, 21 Sep 2022 15:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BA9C433C1;
        Wed, 21 Sep 2022 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775401;
        bh=rOos/ArnyqrU9+/UDMZ/R2BUkprdvSdRzCRG/yD/lQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Cnc/yDAV6x9I/TNKo99NviCDlOKCk8jkOgIX++rvztLl1j9UKPup+W3PFP0whtgD
         7GQ46Xc2SmaruDiPCmvWXhKZwHdYAQk5HPgY4dJvZsOGa5gl/WIeBCMZc9VX5ChYup
         SEA2cXD5n5K/BJNYsX4RdNIsjDYty9Bau3vhjxYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/45] video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write
Date:   Wed, 21 Sep 2022 17:46:31 +0200
Message-Id: <20220921153648.362280422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit a09d2d00af53b43c6f11e6ab3cb58443c2cac8a7 ]

In pxa3xx_gcu_write, a count parameter of type size_t is passed to words of
type int.  Then, copy_from_user() may cause a heap overflow because it is used
as the third argument of copy_from_user().

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pxa3xx-gcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 9421d14d0eb0..9e9888e40c57 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -381,7 +381,7 @@ pxa3xx_gcu_write(struct file *file, const char *buff,
 	struct pxa3xx_gcu_batch	*buffer;
 	struct pxa3xx_gcu_priv *priv = to_pxa3xx_gcu_priv(file);
 
-	int words = count / 4;
+	size_t words = count / 4;
 
 	/* Does not need to be atomic. There's a lock in user space,
 	 * but anyhow, this is just for statistics. */
-- 
2.35.1



