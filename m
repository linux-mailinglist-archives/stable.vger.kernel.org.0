Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC056D48F2
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjDCOdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbjDCOdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD60A17640
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D997B81C6C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93982C433EF;
        Mon,  3 Apr 2023 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532382;
        bh=U0Lvgd9jdtUD7FHxAcKp+Ug2og//UYTe0EmF84LG+Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asAAimoUm7FEFk1xFx8iMimyl10c2pZ6yunf+x9lKHhK4kNBgXbc9E2X3gVZao5eq
         Ga72dSpn8ry1aUI07kIq6A2tVn05n8z7f4wF8REHHDmFjgl8hGymDbFgme+XjkzErB
         mzha8IqDb0osXdWoBlT9i8PuIRzmkd2cF2ZxcEHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simon Horman <simon.horman@corigine.com>,
        Felix Fietkau <nbd@nbd.name>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 62/99] net: ethernet: mtk_eth_soc: fix flow block refcounting logic
Date:   Mon,  3 Apr 2023 16:09:25 +0200
Message-Id: <20230403140405.763621366@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8c1cb87c2a5c29da416848451a687473f379611c ]

Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we also need to
call flow_block_cb_incref for a newly allocated cb.
Also fix the accidentally inverted refcount check on unbind.

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230330120840.52079-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 7bb1f20002b58..7c5403c010715 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -462,6 +462,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
+		flow_block_cb_incref(block_cb);
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &block_cb_list);
 		return 0;
@@ -470,7 +471,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (!block_cb)
 			return -ENOENT;
 
-		if (flow_block_cb_decref(block_cb)) {
+		if (!flow_block_cb_decref(block_cb)) {
 			flow_block_cb_remove(block_cb, f);
 			list_del(&block_cb->driver_list);
 		}
-- 
2.39.2



