Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36106B4548
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjCJOcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjCJOc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FDF15C82
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E280661745
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAEAC4339B;
        Fri, 10 Mar 2023 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458684;
        bh=ILhp9S1UVvgreZ8RR1lU25VNZdOmPTZWl8fs9Pw82ZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WyOfLbr01DDjAmA51YDvDZuaTEdd2nsGDXXgKU6hU/2J3r3lItA5RWkbbKuKtXKo9
         0yoH1Slk1n3FJpntEA2Mmv9l3Pfg+vEG2HNUa5iyCcFhhh5hcTzSC5kv39YBf6sGbi
         JgZO+fFC8r5Bh26ktDJQAclQo7kjylHkKcqUahNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/357] drm/exynos: Dont reset bridge->next
Date:   Fri, 10 Mar 2023 14:36:39 +0100
Message-Id: <20230310133739.506125222@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit bd19c4527056b3e42e8c286136660aa14d0b6c90 ]

bridge->next is only points to the new bridge if drm_bridge_attach()
succeeds. No need to reset it manually here.

Note that this change is part of the attempt to make the bridge chain
a double-linked list. In order to do that we must patch all drivers
manipulating the bridge->next field.

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191023154512.9762-3-boris.brezillon@collabora.com
Stable-dep-of: 13fcfcb2a9a4 ("drm/msm/mdp5: Add check for kzalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_dp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_dp.c b/drivers/gpu/drm/exynos/exynos_dp.c
index e0cfae744afc9..01c5fbf9083a0 100644
--- a/drivers/gpu/drm/exynos/exynos_dp.c
+++ b/drivers/gpu/drm/exynos/exynos_dp.c
@@ -109,7 +109,6 @@ static int exynos_dp_bridge_attach(struct analogix_dp_plat_data *plat_data,
 		if (ret) {
 			DRM_DEV_ERROR(dp->dev,
 				      "Failed to attach bridge to drm\n");
-			bridge->next = NULL;
 			return ret;
 		}
 	}
-- 
2.39.2



