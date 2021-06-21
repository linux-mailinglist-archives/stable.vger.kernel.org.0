Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4003AEF53
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhFUQhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233294AbhFUQfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B57613BD;
        Mon, 21 Jun 2021 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292885;
        bh=ujPLZFC//0VPbPPGUBhUtMCiMXAskehCPx+qlF145z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4Lyto6Z0txy0hMn6mFKRAwELmPI9kbD3eMPklqfU8KLSi2xNgkowA+pYFg+SMzPR
         EsntTWqm62e8/UDmhOtIq5mcSGKdTE1xZoyO0jY/bS6zYy8WGIYzNA0OltDvtveCPx
         FNLSFejlO9nwIS9Pr6xK/HiWQNgeJBzCLHTiE1RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 003/178] dmaengine: fsl-dpaa2-qdma: Fix error return code in two functions
Date:   Mon, 21 Jun 2021 18:13:37 +0200
Message-Id: <20210621154921.430584504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 17866bc6b2ae1c3075c9fe7bcbeb8ea50eb4c3fc ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in the function where it is.

Fixes: 7fdf9b05c73b ("dmaengine: fsl-dpaa2-qdma: Add NXP dpaa2 qDMA controller driver for Layerscape SoCs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210508030056.2027-1-thunder.leizhen@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
index 4ec909e0b810..4ae057922ef1 100644
--- a/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
+++ b/drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c
@@ -332,6 +332,7 @@ static int __cold dpaa2_qdma_setup(struct fsl_mc_device *ls_dev)
 	}
 
 	if (priv->dpdmai_attr.version.major > DPDMAI_VER_MAJOR) {
+		err = -EINVAL;
 		dev_err(dev, "DPDMAI major version mismatch\n"
 			     "Found %u.%u, supported version is %u.%u\n",
 				priv->dpdmai_attr.version.major,
@@ -341,6 +342,7 @@ static int __cold dpaa2_qdma_setup(struct fsl_mc_device *ls_dev)
 	}
 
 	if (priv->dpdmai_attr.version.minor > DPDMAI_VER_MINOR) {
+		err = -EINVAL;
 		dev_err(dev, "DPDMAI minor version mismatch\n"
 			     "Found %u.%u, supported version is %u.%u\n",
 				priv->dpdmai_attr.version.major,
@@ -475,6 +477,7 @@ static int __cold dpaa2_qdma_dpio_setup(struct dpaa2_qdma_priv *priv)
 		ppriv->store =
 			dpaa2_io_store_create(DPAA2_QDMA_STORE_SIZE, dev);
 		if (!ppriv->store) {
+			err = -ENOMEM;
 			dev_err(dev, "dpaa2_io_store_create() failed\n");
 			goto err_store;
 		}
-- 
2.30.2



