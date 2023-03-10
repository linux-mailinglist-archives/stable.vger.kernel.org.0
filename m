Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFB36B4557
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjCJOdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbjCJOcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7841122CCD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8477B61948
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F754C4339E;
        Fri, 10 Mar 2023 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458728;
        bh=s8yHcZVaOQAgNvPpDAMqPZSYcjHwohxvjb96+RbeQL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGslZ2nR0GyGHpBHE8/d9NfwDpmiLF2ecSnwnmw3UdbSqvTutpWsrPaq5N+kZB8Bo
         6t2Z2bdKLcHSNIw4n9d5833lmVMRxKVwANp0GTg8EHaWF12MfqIs4dMrAxWSIiNBis
         LxoizxikfagTRsT2mya/i6dLtoXt5gCTcXYZmcXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miles Chen <miles.chen@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/357] drm/mediatek: Use NULL instead of 0 for NULL pointer
Date:   Fri, 10 Mar 2023 14:36:46 +0100
Message-Id: <20230310133739.837032905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

[ Upstream commit 4744cde06f57dd6fbaac468663b1fe2f653eaa16 ]

Use NULL for NULL pointer to fix the following sparse warning:
drivers/gpu/drm/mediatek/mtk_drm_gem.c:265:27: sparse: warning: Using plain integer as NULL pointer

Fixes: 3df64d7b0a4f ("drm/mediatek: Implement gem prime vmap/vunmap function")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20230111024443.24559-1-miles.chen@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index b04a3c2b111e0..7ff6de44a9fa8 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -284,6 +284,6 @@ void mtk_drm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr)
 		return;
 
 	vunmap(vaddr);
-	mtk_gem->kvaddr = 0;
+	mtk_gem->kvaddr = NULL;
 	kfree(mtk_gem->pages);
 }
-- 
2.39.2



