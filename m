Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB2E537D52
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbiE3NhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237421AbiE3Nep (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:34:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539CB92D23;
        Mon, 30 May 2022 06:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C9D460EEE;
        Mon, 30 May 2022 13:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3657C36AEA;
        Mon, 30 May 2022 13:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917295;
        bh=2aro4hsaizbmehGAHGgs444aSUzly18lMFz3EQEQqnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJvbwf6ZhSFVpeipBBkBmFGdl1oDAdYJ3nJCKnXPNb1g0jDMTde7+m/aE8QURIKBg
         bg0UN2IFgttjZS3bTMHHi9QE7R8WSy3xcRz8Pn79EQjUVV5wkB3IVz3+lnnazN9AqN
         ezshLbGdKnYnVZkH7MkQ2V1kusvW8fgeFteepK3Qr8nzMkuzbSfysSe5tBo+qwmtzS
         c0K4arulhA+KCWrGpqxCMidF4pV6gUeaLe2huzXLS5clADuIseWZBu6njDeEYbN/p8
         6W7F/BZ1mwVmt3fTP2KxqeKu+YYdqy76aY6YZB+RGJB3ttnME6X380zL2SpdxV5Tza
         zd/sROxlr4apw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, jonathanh@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 087/159] drm/tegra: gem: Do not try to dereference ERR_PTR()
Date:   Mon, 30 May 2022 09:23:12 -0400
Message-Id: <20220530132425.1929512-87-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index 0063403ab5e1..7c7dd84e6db8 100644
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

