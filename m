Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F556D49B7
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjDCOkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjDCOkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:40:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D42517ACA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C90CB81CF0
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888A4C433EF;
        Mon,  3 Apr 2023 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532836;
        bh=IahG4m8i86kl93Y3bcEPdaiJX2do9PJPNclyemobDz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJIgRgSvKExvjJOvByyfmLwS+xCuB5J1dkVdrsunXzDPGaJDpBqXLALjpIY5VS+bz
         oOSLyAXFPor1J3ap4qAlr3iFh2EqNIHuidTpo9Z88XnCZb00gsWDk8YJ4qBSkk1MSi
         MEyO9up/cNfHFFtDlXHCz1mbRjZjibBkdq9Q13Ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simon Horman <simon.horman@corigine.com>,
        Felix Fietkau <nbd@nbd.name>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/181] net: ethernet: mtk_eth_soc: fix flow block refcounting logic
Date:   Mon,  3 Apr 2023 16:09:13 +0200
Message-Id: <20230403140418.920518270@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 28bbd1df3e305..6a72687d5b83f 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -570,6 +570,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
+		flow_block_cb_incref(block_cb);
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &block_cb_list);
 		return 0;
@@ -578,7 +579,7 @@ mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
 		if (!block_cb)
 			return -ENOENT;
 
-		if (flow_block_cb_decref(block_cb)) {
+		if (!flow_block_cb_decref(block_cb)) {
 			flow_block_cb_remove(block_cb, f);
 			list_del(&block_cb->driver_list);
 		}
-- 
2.39.2



