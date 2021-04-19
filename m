Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617AF364408
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbhDSNZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241363AbhDSNWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC41261285;
        Mon, 19 Apr 2021 13:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838286;
        bh=J9UUaUQJXpc+Wtidh7Auovyz9JrG1MkqCjWCk6hUegc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCWNxKSkGbcZqU2VBnTYzb0uLyS/Q/8NqSzA8/qYl+UFKQJm42ZXfGGN79g2UKxOz
         vDAWRLFg/qAAYZHQLbCf2S7YEgCqCal6RljNxO8XtP756YAIErvKFaBISXbSPGar/Z
         nEmyPdaX0li2Wrfszo9iHSkLWtYm5tsUpIBU4qFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 083/103] ch_ktls: tcb close causes tls connection failure
Date:   Mon, 19 Apr 2021 15:06:34 +0200
Message-Id: <20210419130530.651342324@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

commit 21d8c25e3f4b9052a471ced8f47b531956eb9963 upstream.

HW doesn't need marking TCB closed. This TCB state change
sometimes causes problem to the new connection which gets
the same tid.

Fixes: 34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |   19 ----------
 1 file changed, 19 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -355,18 +355,6 @@ static int chcr_set_tcb_field(struct chc
 }
 
 /*
- * chcr_ktls_mark_tcb_close: mark tcb state to CLOSE
- * @tx_info - driver specific tls info.
- * return: NET_TX_OK/NET_XMIT_DROP.
- */
-static int chcr_ktls_mark_tcb_close(struct chcr_ktls_info *tx_info)
-{
-	return chcr_set_tcb_field(tx_info, TCB_T_STATE_W,
-				  TCB_T_STATE_V(TCB_T_STATE_M),
-				  CHCR_TCB_STATE_CLOSED, 1);
-}
-
-/*
  * chcr_ktls_dev_del:  call back for tls_dev_del.
  * Remove the tid and l2t entry and close the connection.
  * it per connection basis.
@@ -400,8 +388,6 @@ static void chcr_ktls_dev_del(struct net
 
 	/* clear tid */
 	if (tx_info->tid != -1) {
-		/* clear tcb state and then release tid */
-		chcr_ktls_mark_tcb_close(tx_info);
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
 	}
@@ -579,7 +565,6 @@ static int chcr_ktls_dev_add(struct net_
 	return 0;
 
 free_tid:
-	chcr_ktls_mark_tcb_close(tx_info);
 #if IS_ENABLED(CONFIG_IPV6)
 	/* clear clip entry */
 	if (tx_info->ip_family == AF_INET6)
@@ -677,10 +662,6 @@ static int chcr_ktls_cpl_act_open_rpl(st
 	if (tx_info->pending_close) {
 		spin_unlock(&tx_info->lock);
 		if (!status) {
-			/* it's a late success, tcb status is establised,
-			 * mark it close.
-			 */
-			chcr_ktls_mark_tcb_close(tx_info);
 			cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 					 tid, tx_info->ip_family);
 		}


