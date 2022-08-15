Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4B759424F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349606AbiHOVsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350120AbiHOVrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:47:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AC75F12E;
        Mon, 15 Aug 2022 12:31:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21371B8107A;
        Mon, 15 Aug 2022 19:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C21C433D6;
        Mon, 15 Aug 2022 19:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591858;
        bh=7Lvbr3yWglt5qIfD10p3dizhg1TsWM9D8DoP5cAkLTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d773Nw+REw55AD6h01+PJzjIqop8COkygmOGdmPAdRqZ4VD+5GHNFNtl9IdZFAuCq
         77mKePj4Y+7aHergu2r2NmAV+LafBPEO2GutlrtovWqUYgy2iOoTIyLJhm5DZ2e5qP
         1R4OPD0cRHn2casgBNR5Uk0ialDgfk7jFJ95eJZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0691/1095] mtd: hyperbus: rpc-if: Fix RPM imbalance in probe error path
Date:   Mon, 15 Aug 2022 20:01:30 +0200
Message-Id: <20220815180457.960816982@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit c223a38d62e57aa60a890ea7247e3c58a54478e6 ]

If rpcif_hw_init() fails, Runtime PM is left enabled.

Fixes: b04cc0d912eb80d3 ("memory: renesas-rpc-if: Add support for RZ/G2L")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/f3070e1af480cb252ae183d479a593dbbf947685.1655457790.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/rpc-if.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/hyperbus/rpc-if.c b/drivers/mtd/hyperbus/rpc-if.c
index 6e08ec1d4f09..b70d259e48a7 100644
--- a/drivers/mtd/hyperbus/rpc-if.c
+++ b/drivers/mtd/hyperbus/rpc-if.c
@@ -134,7 +134,7 @@ static int rpcif_hb_probe(struct platform_device *pdev)
 
 	error = rpcif_hw_init(&hyperbus->rpc, true);
 	if (error)
-		return error;
+		goto out_disable_rpm;
 
 	hyperbus->hbdev.map.size = hyperbus->rpc.size;
 	hyperbus->hbdev.map.virt = hyperbus->rpc.dirmap;
@@ -145,8 +145,12 @@ static int rpcif_hb_probe(struct platform_device *pdev)
 	hyperbus->hbdev.np = of_get_next_child(pdev->dev.parent->of_node, NULL);
 	error = hyperbus_register_device(&hyperbus->hbdev);
 	if (error)
-		rpcif_disable_rpm(&hyperbus->rpc);
+		goto out_disable_rpm;
+
+	return 0;
 
+out_disable_rpm:
+	rpcif_disable_rpm(&hyperbus->rpc);
 	return error;
 }
 
-- 
2.35.1



