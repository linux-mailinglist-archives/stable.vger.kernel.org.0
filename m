Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1640B5411BF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354449AbiFGTmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357585AbiFGTmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9711B5862;
        Tue,  7 Jun 2022 11:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16FED6006F;
        Tue,  7 Jun 2022 18:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EF3C385A2;
        Tue,  7 Jun 2022 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625725;
        bh=ZN6hC2vdwKmBY0Swi3pq5qptEuPjZ0EGRv0BuujKnUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vZB3Z7XGcd8sJvqh3hlbaNzRL2fUcU4rGVEiQeOZ4vU8XN1jQSDMxOrjtJY33Kto
         xJINfQjK6UHmp7UnfrA8nfKSx71FpiV7HQYWLW4GVWSDlzkRTil/0crjP3OsyptwEV
         Xgr2g37ngRqb41QkO9pUXk47JiSMctp7R39sUgCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 119/772] drm/tegra: gem: Do not try to dereference ERR_PTR()
Date:   Tue,  7 Jun 2022 18:55:11 +0200
Message-Id: <20220607164952.554943998@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit cb7e1abc2c73633e1eefa168ab2dad6e838899c9 ]

When mapping the DMA-BUF attachment fails, map->sgt will be an ERR_PTR-
encoded error code and the cleanup code would try to free that memory,
which obviously would fail.

Zero out that pointer after extracting the error code when this happens
so that kfree() can do the right thing.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index fce0e52973c2..9810b3bdd342 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -88,6 +88,7 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 		if (IS_ERR(map->sgt)) {
 			dma_buf_detach(buf, map->attach);
 			err = PTR_ERR(map->sgt);
+			map->sgt = NULL;
 			goto free;
 		}
 
-- 
2.35.1



