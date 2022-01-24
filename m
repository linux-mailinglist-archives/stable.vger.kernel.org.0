Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1CE499948
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453897AbiAXVbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450852AbiAXVVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D671C0604DA;
        Mon, 24 Jan 2022 12:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6029B8122A;
        Mon, 24 Jan 2022 20:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E035C340E5;
        Mon, 24 Jan 2022 20:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055356;
        bh=dLuDQRzMUeeFfFZdQZT99nYWumh4Iox5ujdhWHcDORI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhkKARdBa1b58ssH2vlrAALeWe34wiCsHbEHduvmOgqPW8BYrQ5u52UGNd+8dm/Gy
         q6NY9TPgyhq3DZspRwxiHNfSv089vxOLc7DjWP4TreuX+AYLUiKXihl0AK+Juk+a1c
         TX6uMbXEURHzleFhji6NBMend6IkecG74Zy+o2HE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/846] memory: renesas-rpc-if: Return error in case devm_ioremap_resource() fails
Date:   Mon, 24 Jan 2022 19:34:02 +0100
Message-Id: <20220124184105.287955195@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 818fdfa89baac77a8df5a2c30f4fb798cc937aa0 ]

Make sure we return error in case devm_ioremap_resource() fails for dirmap
resource.

Fixes: ca7d8b980b67 ("memory: add Renesas RPC-IF driver")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20211025205631.21151-6-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 77a011d5ff8c1..8618702233002 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -244,7 +244,7 @@ int rpcif_sw_init(struct rpcif *rpc, struct device *dev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
 	rpc->dirmap = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(rpc->dirmap))
-		rpc->dirmap = NULL;
+		return PTR_ERR(rpc->dirmap);
 	rpc->size = resource_size(res);
 
 	rpc->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-- 
2.34.1



