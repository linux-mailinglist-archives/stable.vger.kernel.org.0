Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C84541A74
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379831AbiFGVdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381074AbiFGVbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E00322CBDA;
        Tue,  7 Jun 2022 12:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20E3FB822C0;
        Tue,  7 Jun 2022 19:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78455C385A2;
        Tue,  7 Jun 2022 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628639;
        bh=6X4d72LwQTIc+6PTx5vEOmfhb6pBrV/KYQO5s5tQhc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcOLTucFpB7oKXo8+0/TBNh/1OdWv1v2dnf9PXnFiGWcJnK2/467dmbjs6QTNFIu9
         c21TanQf/b2w7BjGlA/XEs3AcWfS8mTQ/eQnMrXhOosk/VFVlRtL1gu3AP3BfPp9xG
         XqYlOdInJYdKwbOr4pb7bCvbmf4/fODKH477R18Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 401/879] drm/msm: return an error pointer in msm_gem_prime_get_sg_table()
Date:   Tue,  7 Jun 2022 18:58:39 +0200
Message-Id: <20220607165014.502970283@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit cf575e31611eb6dccf08fad02e57e35b2187704d ]

The msm_gem_prime_get_sg_table() needs to return error pointers on
error.  This is called from drm_gem_map_dma_buf() and returning a
NULL will lead to a crash in that function.

Fixes: ac45146733b0 ("drm/msm: fix msm_gem_prime_get_sg_table()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/485023/
Link: https://lore.kernel.org/r/YnOmtS5tfENywR9m@kili
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_prime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index e8f1b7a2ca9c..94ab705e9b8a 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -17,7 +17,7 @@ struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj)
 	int npages = obj->size >> PAGE_SHIFT;
 
 	if (WARN_ON(!msm_obj->pages))  /* should have already pinned! */
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	return drm_prime_pages_to_sg(obj->dev, msm_obj->pages, npages);
 }
-- 
2.35.1



