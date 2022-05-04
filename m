Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CFC51A738
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354471AbiEDRDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355404AbiEDRAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409684B402;
        Wed,  4 May 2022 09:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE9861811;
        Wed,  4 May 2022 16:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38215C385A5;
        Wed,  4 May 2022 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683090;
        bh=MAiGjYL2OG/xAAB6sKyAI75CanTT2wYUIKRLSJy6lhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj8xPB5ZrEkSVgZLnOg/6TEtLxVzb1Z78fLh8xJI0oH0NKbYsTYByeLruEOCOIfy6
         oELZCLjaFoEf5/BCzn89lA9orjLlxJslkBtrQvEqHgwFBok1lrY94vSlgNfkF9OKMg
         PwFKPpCeX1ad7qz0EXoCjjpaWIecGKPpaIco46hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/129] net: fec: add missing of_node_put() in fec_enet_init_stop_mode()
Date:   Wed,  4 May 2022 18:44:46 +0200
Message-Id: <20220504153028.392897634@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d2b52ec056d5bddb055c8f21d7489a23548d0838 ]

Put device node in error path in fec_enet_init_stop_mode().

Fixes: 8a448bf832af ("net: ethernet: fec: move GPR register offset and bit into DT")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220426125231.375688-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 166bc3f3b34c..d8bdaf2e5365 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3529,7 +3529,7 @@ static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
 					 ARRAY_SIZE(out_val));
 	if (ret) {
 		dev_dbg(&fep->pdev->dev, "no stop mode property\n");
-		return ret;
+		goto out;
 	}
 
 	fep->stop_gpr.gpr = syscon_node_to_regmap(gpr_np);
-- 
2.35.1



