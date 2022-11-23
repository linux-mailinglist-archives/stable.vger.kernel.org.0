Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811826354E7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiKWJMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237219AbiKWJMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:12:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344155587
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D142EB81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE26C433C1;
        Wed, 23 Nov 2022 09:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194739;
        bh=GeC7NvKqm718jF98ewFwJhQZ2YZOROyEMwggYRyroFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjeMuD4/8slHta4xmZn/8XsMF3Pwii+z7txaz4TMrwETdNV5r8U5rfEgflfTcdNt1
         HrYeuN5D3G5XJMGHxd2x8wEISaMNLbqB9j0Au5W+Bd6GWzT7/xHeiABuKpKBenUNEI
         osqteviOxLfBEyfkSB5lLHKisA64903I0YHta5b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/156] net: cpsw: disable napi in cpsw_ndo_open()
Date:   Wed, 23 Nov 2022 09:49:47 +0100
Message-Id: <20221123084559.050258138@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 6d47b53fb3f363a74538a1dbd09954af3d8d4131 ]

When failed to create xdp rxqs or fill rx channels in cpsw_ndo_open() for
opening device, napi isn't disabled. When open cpsw device next time, it
will report a invalid opcode issue. Compiled tested only.

Fixes: d354eb85d618 ("drivers: net: cpsw: dual_emac: simplify napi usage")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109011537.96975-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 33eca554424a..774a72db7c96 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1753,6 +1753,8 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 err_cleanup:
 	if (!cpsw->usage_count) {
+		napi_disable(&cpsw->napi_rx);
+		napi_disable(&cpsw->napi_tx);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_destroy_xdp_rxqs(cpsw);
 	}
-- 
2.35.1



