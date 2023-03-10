Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEAE6B457B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjCJOeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjCJOds (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADCB6B332
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:33:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF2556187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8C7C433D2;
        Fri, 10 Mar 2023 14:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458823;
        bh=U9dM13pzKEj8cPzhiKYKQQnq8KL5yE6Jay0p5x4edxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7DVsYRp86L91pCBNGzOoIVcRjQFt5siOk2UMUSAjGBhOSq9II9Sm2ZamkodCLoZC
         RQ0QmDuAAogiBjOZUVQoTyuN5G3sTVMY6kzVVQbCMX6W8+mnj6VBJ32Vy4F6OVT1H+
         Ybtxn2ScfM6JzTuPCr3e4Mx+Waz9Pcrg8OtmEPw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wambui Karuga <wambui.karugax@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/357] drm/mediatek: remove cast to pointers passed to kfree
Date:   Fri, 10 Mar 2023 14:36:45 +0100
Message-Id: <20230310133739.785643986@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wambui Karuga <wambui.karugax@gmail.com>

[ Upstream commit 2ec35bd21d3290c8f76020dc60503deacd18e24b ]

Remove unnecessary casts to pointer types passed to kfree.
Issue detected by coccinelle:
@@
type t1;
expression *e;
@@

-kfree((t1 *)e);
+kfree(e);

Signed-off-by: Wambui Karuga <wambui.karugax@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20191023111107.9972-1-wambui.karugax@gmail.com
Stable-dep-of: 4744cde06f57 ("drm/mediatek: Use NULL instead of 0 for NULL pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index ca672f1d140de..b04a3c2b111e0 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -271,7 +271,7 @@ void *mtk_drm_gem_prime_vmap(struct drm_gem_object *obj)
 			       pgprot_writecombine(PAGE_KERNEL));
 
 out:
-	kfree((void *)sgt);
+	kfree(sgt);
 
 	return mtk_gem->kvaddr;
 }
@@ -285,5 +285,5 @@ void mtk_drm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr)
 
 	vunmap(vaddr);
 	mtk_gem->kvaddr = 0;
-	kfree((void *)mtk_gem->pages);
+	kfree(mtk_gem->pages);
 }
-- 
2.39.2



