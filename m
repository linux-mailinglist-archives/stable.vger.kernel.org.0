Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE8364319
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239954AbhDSNOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239869AbhDSNMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:12:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85A12613B8;
        Mon, 19 Apr 2021 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837917;
        bh=xyS2wI06VzGPR+Aw78dfF5hpx6vN0vfMR0ox2HqmImI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idIkpopwPTiHE8JSeaVzvOL70jSNYygrNyQoduwgcASJHAsDOBbGdvDIxdtn1wld8
         P7x6cDm+siCMR+tEPsOdxhfgKZn7F15yD4S8pcwJtZ6M0aebb7rEd9QYwpf+a7JFsR
         GvsBXIBtgTQVGLFhUsW0KG0i1IqNK+yIqM44UF68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 099/122] ch_ktls: fix device connection close
Date:   Mon, 19 Apr 2021 15:06:19 +0200
Message-Id: <20210419130533.524372424@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

commit bc16efd2430652f894ae34b1de5eccc3bf0d2810 upstream.

When sge queue is full and chcr_ktls_xmit_wr_complete()
returns failure, skb is not freed if it is not the last tls record in
this skb, causes refcount never gets freed and tls_dev_del()
never gets called on this connection.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1740,7 +1740,9 @@ static int chcr_end_part_handler(struct
 				 struct sge_eth_txq *q, u32 skb_offset,
 				 u32 tls_end_offset, bool last_wr)
 {
+	bool free_skb_if_tx_fails = false;
 	struct sk_buff *nskb = NULL;
+
 	/* check if it is a complete record */
 	if (tls_end_offset == record->len) {
 		nskb = skb;
@@ -1763,6 +1765,8 @@ static int chcr_end_part_handler(struct
 
 		if (last_wr)
 			dev_kfree_skb_any(skb);
+		else
+			free_skb_if_tx_fails = true;
 
 		last_wr = true;
 
@@ -1774,6 +1778,8 @@ static int chcr_end_part_handler(struct
 				       record->num_frags,
 				       (last_wr && tcp_push_no_fin),
 				       mss)) {
+		if (free_skb_if_tx_fails)
+			dev_kfree_skb_any(skb);
 		goto out;
 	}
 	tx_info->prev_seq = record->end_seq;


