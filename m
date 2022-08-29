Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A355A4946
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiH2LWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiH2LV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0306F261;
        Mon, 29 Aug 2022 04:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E325B80DB5;
        Mon, 29 Aug 2022 11:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54473C433C1;
        Mon, 29 Aug 2022 11:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771619;
        bh=ilM81X9bYHzCIl7Y5JRsv5m6sk0E4ZL2agqH2ayJy2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZYW0uOADux0tGepdDgLqeEaa5Nxv+tZxIQBULK8eqMTaOI1f/iNihmL5vbU2GAfN
         +9AKkE7hOgtDzTbFfYlIvkbi1JIGZO50GztGPuNAJ1awYz27OeemLc3ToSF5jKtnlp
         coKM+1mgfEJx9soVbVISla1R94tOiPbhML12iSMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 051/158] bnxt_en: Use PAGE_SIZE to init buffer when multi buffer XDP is not in use
Date:   Mon, 29 Aug 2022 12:58:21 +0200
Message-Id: <20220829105810.878458809@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 7dd3de7cb1d657a918c6b2bc673c71e318aa0c05 ]

Using BNXT_PAGE_MODE_BUF_SIZE + offset as buffer length value is not
sufficient when running single buffer XDP programs doing redirect
operations. The stack will complain on missing skb tail room. Fix it
by using PAGE_SIZE when calling xdp_init_buff() for single buffer
programs.

Fixes: b231c3f3414c ("bnxt: refactor bnxt_rx_xdp to separate xdp_init_buff/xdp_prepare_buff")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 075c6206325ce..b1b17f9113006 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2130,6 +2130,7 @@ struct bnxt {
 #define BNXT_DUMP_CRASH		1
 
 	struct bpf_prog		*xdp_prog;
+	u8			xdp_has_frags;
 
 	struct bnxt_ptp_cfg	*ptp_cfg;
 	u8			ptp_all_rx_tstamp;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index f53387ed0167b..c3065ec0a4798 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -181,6 +181,7 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 			struct xdp_buff *xdp)
 {
 	struct bnxt_sw_rx_bd *rx_buf;
+	u32 buflen = PAGE_SIZE;
 	struct pci_dev *pdev;
 	dma_addr_t mapping;
 	u32 offset;
@@ -192,7 +193,10 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	mapping = rx_buf->mapping - bp->rx_dma_offset;
 	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
 
-	xdp_init_buff(xdp, BNXT_PAGE_MODE_BUF_SIZE + offset, &rxr->xdp_rxq);
+	if (bp->xdp_has_frags)
+		buflen = BNXT_PAGE_MODE_BUF_SIZE + offset;
+
+	xdp_init_buff(xdp, buflen, &rxr->xdp_rxq);
 	xdp_prepare_buff(xdp, *data_ptr - offset, offset, *len, false);
 }
 
@@ -397,8 +401,10 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		netdev_warn(dev, "ethtool rx/tx channels must be combined to support XDP.\n");
 		return -EOPNOTSUPP;
 	}
-	if (prog)
+	if (prog) {
 		tx_xdp = bp->rx_nr_rings;
+		bp->xdp_has_frags = prog->aux->xdp_has_frags;
+	}
 
 	tc = netdev_get_num_tc(dev);
 	if (!tc)
-- 
2.35.1



