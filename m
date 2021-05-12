Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B95C37C4A3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhELPcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhELP21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C8D561C21;
        Wed, 12 May 2021 15:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832422;
        bh=FCyMtEtepY+BScjx75cdRn2xsF4wszsybo1Y6hvIoyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PITcFGSuLo6RjDensbOXwz9HGpiQcBhYTi2neMW6REeXnUVWw/NuFFTw5Sy6REjYf
         QKvaB04GXbKmX07czczS/yxonRrjY1Bp/rnxCkJS/eRqJy9o+S5CRk+mVHdxHWiA6t
         6Lk2R9AOdDm6dB/dFlJg+jeCHwFETT57r+a/Ksrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/530] memory: renesas-rpc-if: fix possible NULL pointer dereference of resource
Date:   Wed, 12 May 2021 16:46:06 +0200
Message-Id: <20210512144828.248550075@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 59e27d7c94aa02da039b000d33c304c179395801 ]

The platform_get_resource_byname() can return NULL which would be
immediately dereferenced by resource_size().  Instead dereference it
after validating the resource.

Addresses-Coverity: Dereference null return value
Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210407154357.70200-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index da0fdb4c7595..1fe6c35b7503 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -193,10 +193,10 @@ int rpcif_sw_init(struct rpcif *rpc, struct device *dev)
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
-	rpc->size = resource_size(res);
 	rpc->dirmap = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(rpc->dirmap))
 		rpc->dirmap = NULL;
+	rpc->size = resource_size(res);
 
 	rpc->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 
-- 
2.30.2



