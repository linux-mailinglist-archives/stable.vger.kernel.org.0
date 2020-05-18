Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22811D8581
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgERRzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbgERRyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:54:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A29C520674;
        Mon, 18 May 2020 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824495;
        bh=L2vt++2XNaiL1NOmu2IrQ0YPBbh4f5fc+Ee4v2MLRmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKhOsbSH3VVrxQVdAEFbvuMpRAGCaxyG6VhGe3h9iiEjrQRm/PdkMH7O8Uym01QZL
         2fClS3+tdxALW3b+ksDe7XpmfoWGM3umsK6fD3jn6Gem9mBdxtD/126eFTepBhPxHE
         +/iIG5N7R7Z7lrfDhIy340kId53SX0/kBcAsrTJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iris Liu <iris@onechronos.com>,
        Kelly Littlepage <kelly@onechronos.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 033/147] net: tcp: fix rx timestamp behavior for tcp_recvmsg
Date:   Mon, 18 May 2020 19:35:56 +0200
Message-Id: <20200518173518.300002297@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kelly Littlepage <kelly@onechronos.com>

[ Upstream commit cc4de047b33be247f9c8150d3e496743a49642b8 ]

The stated intent of the original commit is to is to "return the timestamp
corresponding to the highest sequence number data returned." The current
implementation returns the timestamp for the last byte of the last fully
read skb, which is not necessarily the last byte in the recv buffer. This
patch converts behavior to the original definition, and to the behavior of
the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
behavior.

Fixes: 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
Co-developed-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Iris Liu <iris@onechronos.com>
Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2158,13 +2158,15 @@ skip_copy:
 			tp->urg_data = 0;
 			tcp_fast_path_check(sk);
 		}
-		if (used + offset < skb->len)
-			continue;
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, &tss);
 			cmsg_flags |= 2;
 		}
+
+		if (used + offset < skb->len)
+			continue;
+
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			goto found_fin_ok;
 		if (!(flags & MSG_PEEK))


