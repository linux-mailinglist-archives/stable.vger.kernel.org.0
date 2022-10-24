Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A9D60B240
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiJXQnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiJXQmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:42:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D609FCC5;
        Mon, 24 Oct 2022 08:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C80AB815AE;
        Mon, 24 Oct 2022 12:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD7DC433D6;
        Mon, 24 Oct 2022 12:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613448;
        bh=/HiONoJLixYYJMotsCLlT211vd+a59UGQzRL4UvcskU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcDpDQm7ZbIOHf2wFreeRMy72rqlo90yuY2P+op1fhYiKUw2MvAhCNUJIcqiNlrxL
         dkh5rB8EC5YZVwn5bZs7vezwVxNnOT6lUFkXcHuUpe2GSILE9nObmsjE//6c5faUqf
         GzXzAAvtjntZPM87+rj6meEEqyH4GpdprYow5B/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/255] RDMA/siw: Always consume all skbuf data in sk_data_ready() upcall.
Date:   Mon, 24 Oct 2022 13:30:50 +0200
Message-Id: <20221024113007.238775802@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5f94c716301f..e8a1aa07f058 100644
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



