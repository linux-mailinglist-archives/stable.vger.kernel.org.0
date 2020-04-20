Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFAA1B09DF
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgDTMmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgDTMmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:42:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5242320735;
        Mon, 20 Apr 2020 12:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386570;
        bh=plMxhHApsc4BN2fh/xPdBd++keSZJd9EE9BXwTtjyPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRoDWGfPEQeWxrz9fqEviac/5gzMSKfdrCEaFngf6a0rrpWFTL+nEkn8oXEvrHqRZ
         ogqRc+RBCHX64mTlHau86k4fEQE4E1AWF5g3xa77exjJdu3WWn80OwP+qiijz4xfm4
         XURWPMWNMpDQncV/zRFzBewhEQ6KbpDWch8TKNsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilberto Bertin <me@jibi.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 11/71] net: tun: record RX queue in skb before do_xdp_generic()
Date:   Mon, 20 Apr 2020 14:38:25 +0200
Message-Id: <20200420121510.699855599@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilberto Bertin <me@jibi.io>

[ Upstream commit 3fe260e00cd0bf0be853c48fcc1e19853df615bb ]

This allows netif_receive_generic_xdp() to correctly determine the RX
queue from which the skb is coming, so that the context passed to the
XDP program will contain the correct RX queue index.

Signed-off-by: Gilberto Bertin <me@jibi.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1925,6 +1925,7 @@ drop:
 
 	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb);
+	skb_record_rx_queue(skb, tfile->queue_index);
 
 	if (skb_xdp) {
 		struct bpf_prog *xdp_prog;
@@ -2498,6 +2499,7 @@ build:
 	skb->protocol = eth_type_trans(skb, tun->dev);
 	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb);
+	skb_record_rx_queue(skb, tfile->queue_index);
 
 	if (skb_xdp) {
 		err = do_xdp_generic(xdp_prog, skb);
@@ -2509,7 +2511,6 @@ build:
 	    !tfile->detached)
 		rxhash = __skb_get_hash_symmetric(skb);
 
-	skb_record_rx_queue(skb, tfile->queue_index);
 	netif_receive_skb(skb);
 
 	/* No need for get_cpu_ptr() here since this function is


