Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EC276DCD
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389057AbfGZPaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389052AbfGZPaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:30:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BFAC22BF5;
        Fri, 26 Jul 2019 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155017;
        bh=TjuGjxvbtzlQABlyUt/YBGJ1P0JFtaLDYZ4vtzSJu2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHHla0nruag58rd8zviaKU0KKYwFYY7aqkBH3NU3HXBpOLrz/rMiIDhf1Mkutr7v1
         BBeh9+kw/PDVaudUAbXYV5Jq+Js06CR7DsdBK+9uve9CCroGyED6hKq5ciSeCkfEGV
         llw4nfO0RRMufiuouFxmJzOHFn5g1VpXXatw+/Pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Beckett <david.beckett@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 37/62] net/tls: fix poll ignoring partially copied records
Date:   Fri, 26 Jul 2019 17:24:49 +0200
Message-Id: <20190726152305.857789553@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 13aecb17acabc2a92187d08f7ca93bb8aad62c6f ]

David reports that RPC applications which use epoll() occasionally
get stuck, and that TLS ULP causes the kernel to not wake applications,
even though read() will return data.

This is indeed true. The ctx->rx_list which holds partially copied
records is not consulted when deciding whether socket is readable.

Note that SO_RCVLOWAT with epoll() is and has always been broken for
kernel TLS. We'd need to parse all records from the TCP layer, instead
of just the first one.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Reported-by: David Beckett <david.beckett@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1931,7 +1931,8 @@ bool tls_sw_stream_read(const struct soc
 		ingress_empty = list_empty(&psock->ingress_msg);
 	rcu_read_unlock();
 
-	return !ingress_empty || ctx->recv_pkt;
+	return !ingress_empty || ctx->recv_pkt ||
+		!skb_queue_empty(&ctx->rx_list);
 }
 
 static int tls_read_size(struct strparser *strp, struct sk_buff *skb)


