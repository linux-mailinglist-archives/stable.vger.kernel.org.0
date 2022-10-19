Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A0C603F5C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiJSJbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbiJSJ3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2C1EB746;
        Wed, 19 Oct 2022 02:12:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7455617E1;
        Wed, 19 Oct 2022 09:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87D0C433D6;
        Wed, 19 Oct 2022 09:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170125;
        bh=obz5FPNMsHHx1sO6B0yQTmd5pxFcPPFY4b0ZdeXu71Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoXg+h68uwHN9yxcnKp+JRJIzYU8jFuOsZtce9+xdF2dm3ANJGLVLvX3kMw13DRAm
         9HIyhKmdH18pq5Wjtk3EeVlHq+ezUJJ+89B2JK9QNttFfgarkc6DM754LHcfgQfKeE
         1Gj/dDHfkIhl6Je/AlYEn2hi5hlxPhA19SSeU2z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 537/862] RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.
Date:   Wed, 19 Oct 2022 10:30:24 +0200
Message-Id: <20221019083313.678213207@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit 754209850df8367c954ac1de7671c7430b1f342c ]

For header and trailer/padding processing, siw did not consume new
skb data until minimum amount present to fill current header or trailer
structure, including potential payload padding. Not consuming any
data during upcall may cause a receive stall, since tcp_read_sock()
is not upcalling again if no new data arrive.
A NFSoRDMA client got stuck at RDMA Write reception of unaligned
payload, if the current skb did contain only the expected 3 padding
bytes, but not the 4 bytes CRC trailer. Expecting 4 more bytes already
arrived in another skb, and not consuming those 3 bytes in the current
upcall left the Write incomplete, waiting for the CRC forever.

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Reported-by: Olga Kornievskaia <kolga@netapp.com>
Tested-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Link: https://lore.kernel.org/r/20220920081202.223629-1-bmt@zurich.ibm.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 875ea6f1b04a..fd721cc19682 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -961,27 +961,28 @@ int siw_proc_terminate(struct siw_qp *qp)
 static int siw_get_trailer(struct siw_qp *qp, struct siw_rx_stream *srx)
 {
 	struct sk_buff *skb = srx->skb;
+	int avail = min(srx->skb_new, srx->fpdu_part_rem);
 	u8 *tbuf = (u8 *)&srx->trailer.crc - srx->pad;
 	__wsum crc_in, crc_own = 0;
 
 	siw_dbg_qp(qp, "expected %d, available %d, pad %u\n",
 		   srx->fpdu_part_rem, srx->skb_new, srx->pad);
 
-	if (srx->skb_new < srx->fpdu_part_rem)
-		return -EAGAIN;
-
-	skb_copy_bits(skb, srx->skb_offset, tbuf, srx->fpdu_part_rem);
+	skb_copy_bits(skb, srx->skb_offset, tbuf, avail);
 
-	if (srx->mpa_crc_hd && srx->pad)
-		crypto_shash_update(srx->mpa_crc_hd, tbuf, srx->pad);
+	srx->skb_new -= avail;
+	srx->skb_offset += avail;
+	srx->skb_copied += avail;
+	srx->fpdu_part_rem -= avail;
 
-	srx->skb_new -= srx->fpdu_part_rem;
-	srx->skb_offset += srx->fpdu_part_rem;
-	srx->skb_copied += srx->fpdu_part_rem;
+	if (srx->fpdu_part_rem)
+		return -EAGAIN;
 
 	if (!srx->mpa_crc_hd)
 		return 0;
 
+	if (srx->pad)
+		crypto_shash_update(srx->mpa_crc_hd, tbuf, srx->pad);
 	/*
 	 * CRC32 is computed, transmitted and received directly in NBO,
 	 * so there's never a reason to convert byte order.
@@ -1083,10 +1084,9 @@ static int siw_get_hdr(struct siw_rx_stream *srx)
 	 * completely received.
 	 */
 	if (iwarp_pktinfo[opcode].hdr_len > sizeof(struct iwarp_ctrl_tagged)) {
-		bytes = iwarp_pktinfo[opcode].hdr_len - MIN_DDP_HDR;
+		int hdrlen = iwarp_pktinfo[opcode].hdr_len;
 
-		if (srx->skb_new < bytes)
-			return -EAGAIN;
+		bytes = min_t(int, hdrlen - MIN_DDP_HDR, srx->skb_new);
 
 		skb_copy_bits(skb, srx->skb_offset,
 			      (char *)c_hdr + srx->fpdu_part_rcvd, bytes);
@@ -1096,6 +1096,9 @@ static int siw_get_hdr(struct siw_rx_stream *srx)
 		srx->skb_new -= bytes;
 		srx->skb_offset += bytes;
 		srx->skb_copied += bytes;
+
+		if (srx->fpdu_part_rcvd < hdrlen)
+			return -EAGAIN;
 	}
 
 	/*
-- 
2.35.1



