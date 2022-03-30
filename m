Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9D54EC152
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344833AbiC3L4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345155AbiC3LyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5085D25FD42;
        Wed, 30 Mar 2022 04:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5B8FB81C28;
        Wed, 30 Mar 2022 11:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D69C340F2;
        Wed, 30 Mar 2022 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641028;
        bh=/hJvC2gf0i2zGMllIvwBp0yhdrPxL94SQLzsN5wb/G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDpyKx1GBB5F9mnll9S71hlqnHp7LCHxn/wM8+UMVnaYdAWbyKIhANhedLp1r1Gow
         ZiDUpmOv7Jgbr4oe0wI1920Q0KNPzeNhXKLnov+3EoRp4XMDGEhJCUCEHQBnU82pEL
         LpzgFkKkf/k6uQ/FtRJJKJlN95W9Gf/GymMjTTSksBHCtkouPK0Q0jl2nX5ffmqgKD
         S1alOWzgzVTmZRka+MWYFY1dUJsKQqNSOk3TPz7N9UEpQSNkcV3t2U33bIxc8sLIBq
         dngydnW9WYtiQowCNam/AeleIFLtw2BOhdolBaQHkRAgLjWFQSqvoxnxYGpvnnPqZw
         2KhLd/e0DHL6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/50] video: fbdev: w100fb: Reset global state
Date:   Wed, 30 Mar 2022 07:49:28 -0400
Message-Id: <20220330115005.1671090-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 8738ddcac644964ae128ccd3d80d48773c8d528e ]

w100fb_probe() did not reset the global state to its initial state. This
can result in invocation of iounmap() even when there was not the
appropriate successful call of ioremap(). For instance, this may be the
case if first probe fails after two successful ioremap() while second
probe fails when first ioremap() fails. The similar issue is with
w100fb_remove(). The patch fixes both bugs.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Co-developed-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Signed-off-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/w100fb.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/w100fb.c b/drivers/video/fbdev/w100fb.c
index d96ab28f8ce4..4e641a780726 100644
--- a/drivers/video/fbdev/w100fb.c
+++ b/drivers/video/fbdev/w100fb.c
@@ -770,12 +770,18 @@ static int w100fb_probe(struct platform_device *pdev)
 		fb_dealloc_cmap(&info->cmap);
 		kfree(info->pseudo_palette);
 	}
-	if (remapped_fbuf != NULL)
+	if (remapped_fbuf != NULL) {
 		iounmap(remapped_fbuf);
-	if (remapped_regs != NULL)
+		remapped_fbuf = NULL;
+	}
+	if (remapped_regs != NULL) {
 		iounmap(remapped_regs);
-	if (remapped_base != NULL)
+		remapped_regs = NULL;
+	}
+	if (remapped_base != NULL) {
 		iounmap(remapped_base);
+		remapped_base = NULL;
+	}
 	if (info)
 		framebuffer_release(info);
 	return err;
@@ -795,8 +801,11 @@ static int w100fb_remove(struct platform_device *pdev)
 	fb_dealloc_cmap(&info->cmap);
 
 	iounmap(remapped_base);
+	remapped_base = NULL;
 	iounmap(remapped_regs);
+	remapped_regs = NULL;
 	iounmap(remapped_fbuf);
+	remapped_fbuf = NULL;
 
 	framebuffer_release(info);
 
-- 
2.34.1

