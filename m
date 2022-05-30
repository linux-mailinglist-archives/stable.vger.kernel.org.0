Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB39537F6B
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbiE3NwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238903AbiE3Nu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:50:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7188EB0D00;
        Mon, 30 May 2022 06:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF85660E9B;
        Mon, 30 May 2022 13:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5301C341C8;
        Mon, 30 May 2022 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917710;
        bh=ZN6hC2vdwKmBY0Swi3pq5qptEuPjZ0EGRv0BuujKnUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9aVZQB4dvAOxcJ2JcWxyk4nVcvQaMaKBRxGHRK01R39X50dV3MkdBjwfcgFviqgu
         VHY9Tn5HJivF8DOnuMQMikSRzMjEXP1h7TG5vQyNUPyXiQ0NeMfV9CpwKgPmHuRihL
         JYXnDhgt5IJ2CDwA57RNeWmjr18w69ArO08O2kT6rIws1ON3j+QVa5gjJo+tnd/W7H
         0GfzTOogpc8PR8V4r58O0tfVPcvAB5ML5y83qX2e1E4Ab8xicnotfoVwpZiCel62qr
         /7yeCYpPhI0XZ3RafRDK48xhZzVJYLIdrHepqGeZ6wYW5rsDtGtiR7ptpw1VQRSnMh
         sX/HxxJBXypJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, jonathanh@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 072/135] drm/tegra: gem: Do not try to dereference ERR_PTR()
Date:   Mon, 30 May 2022 09:30:30 -0400
Message-Id: <20220530133133.1931716-72-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

