Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFBE472921
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbhLMKST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241338AbhLMKOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:14:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A91C0D9414;
        Mon, 13 Dec 2021 01:54:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60060B80E69;
        Mon, 13 Dec 2021 09:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C2BC34600;
        Mon, 13 Dec 2021 09:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389284;
        bh=4GupRVAzgbAEKLandKpxkH+Lqfmq5qct3emqOV2/MfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxmXFlktxhSumiLlFZqpEvaK1TULpJgl43DRdqPYH2AuUHVL8frwoUgeiqV4oLv7x
         mcxP+SQRCoiroZ7wAS8qiPmdQRPA8enfDFbPaKvwZuQ0FSQHvNU1ld8OwgLSQTJ+D8
         xdTGiGnwGBVTAM0hhx58uihN7Tl1Wf4veTBdTp6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 046/171] netfilter: nft_exthdr: break evaluation if setting TCP option fails
Date:   Mon, 13 Dec 2021 10:29:21 +0100
Message-Id: <20211213092946.633247427@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 962e5a40358787105f126ab1dc01604da3d169e9 upstream.

Break rule evaluation on malformed TCP options.

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_exthdr.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -236,7 +236,7 @@ static void nft_exthdr_tcp_set_eval(cons
 
 	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
 	if (!tcph)
-		return;
+		goto err;
 
 	opt = (u8 *)tcph;
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
@@ -251,16 +251,16 @@ static void nft_exthdr_tcp_set_eval(cons
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
 
@@ -303,6 +303,9 @@ static void nft_exthdr_tcp_set_eval(cons
 
 		return;
 	}
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static void nft_exthdr_sctp_eval(const struct nft_expr *expr,


