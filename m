Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C42D4EC2BF
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344590AbiC3MBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344597AbiC3L4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:56:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5102E686;
        Wed, 30 Mar 2022 04:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10894B81C25;
        Wed, 30 Mar 2022 11:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B2CC3410F;
        Wed, 30 Mar 2022 11:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641251;
        bh=KCdXw1ny4TNy0K+BLzYJ0gRmwDx43DnoQ1MrFXnm9PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7lwm0hSr64ZLUN9BaV3lnJz+63uF9At19Hm5YKKFCCQz3dFWxUq0qvtRxj+glV76
         1aoLAZWIlLVv/qFVlp6aiu+Jf3dAMInbAfrKxCxBpNs2n2by7uszHruNngCIJeaPSZ
         3uBE1xvuTlrmut59dIJBnQIkdAw2PP1R5Lw4yE8s98Rl3mIEh5EOQdPWY4Tg3xKeF4
         pK64OuZBG5p1eq4ooeyQ+WL+jqjVeyXAcolu0gmmpk780x2baDNpjiuzbIFzfV+o5U
         nKknHS5Ibo8qRS9undD/NPc+a0xctxHPJt549MaB7lGIJkJHCJZwZ//leEPefRqhWl
         PCrHxtTF4IjlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/17] video: fbdev: w100fb: Reset global state
Date:   Wed, 30 Mar 2022 07:53:51 -0400
Message-Id: <20220330115407.1673214-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115407.1673214-1-sashal@kernel.org>
References: <20220330115407.1673214-1-sashal@kernel.org>
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
index 7bd4c27cfb14..b3b17b6adb7e 100644
--- a/drivers/video/fbdev/w100fb.c
+++ b/drivers/video/fbdev/w100fb.c
@@ -772,12 +772,18 @@ int w100fb_probe(struct platform_device *pdev)
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
@@ -802,8 +808,11 @@ static int w100fb_remove(struct platform_device *pdev)
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

