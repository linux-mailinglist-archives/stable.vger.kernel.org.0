Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A354705EB
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 17:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243769AbhLJQmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 11:42:20 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53204 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243751AbhLJQmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 11:42:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DAE83CE2BCA
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85379C341C6;
        Fri, 10 Dec 2021 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639154322;
        bh=NNg3GP2Z6K5fLD+Fju7rEESPiYSGsOqHX3u4Ko6aMdk=;
        h=Subject:To:Cc:From:Date:From;
        b=dJeYX3SNlJHT9woRrcvu87eWxGe1IjOQuhKqidRm1y6BBhd4THEmtkRDGI0gQNFTb
         PlC5H+oNyI5N0B0rYxZ+8o0Yful4fhHpV4MZo0WntpAavjQBccIFlb/91HScri94Za
         J4I0NeYACQ0ncJMGAmvEKZekOtzx4G9s5Ox4g5Xk=
Subject: FAILED: patch "[PATCH] netfilter: nft_exthdr: break evaluation if setting TCP option" failed to apply to 4.19-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 17:38:31 +0100
Message-ID: <16391543111456@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 962e5a40358787105f126ab1dc01604da3d169e9 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 30 Nov 2021 11:34:04 +0100
Subject: [PATCH] netfilter: nft_exthdr: break evaluation if setting TCP option
 fails

Break rule evaluation on malformed TCP options.

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index af4ee874a067..dbe1f2e7dd9e 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -236,7 +236,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
-		return;
+		goto err;
 
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
@@ -251,16 +251,16 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			continue;
 
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
-			return;
+			goto err;
 
 		if (skb_ensure_writable(pkt->skb,
 					nft_thoff(pkt) + i + priv->len))
-			return;
+			goto err;
 
 		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
 					      &tcphdr_len);
 		if (!tcph)
-			return;
+			goto err;
 
 		offset = i + priv->offset;
 
@@ -303,6 +303,9 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 
 		return;
 	}
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static void nft_exthdr_sctp_eval(const struct nft_expr *expr,

