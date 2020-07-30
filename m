Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858A3232E6E
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgG3IHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:07:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgG3IHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:07:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE95206C0;
        Thu, 30 Jul 2020 08:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096451;
        bh=Q1kEsNcIpPtKeGTJYNNx/pkXlTyPb2hsO2eQo91rRRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trZXrsy8XTnNF37YFPYleXOPfzdUUmGdL09SCvmpJ+WpAINbhJt3U2YzMizk9wMPb
         fjTVCG0rA+TcAW4omm9BWu4S/JIakZxsrBq/2Ltia6MCF+88IoESBhdcozkN5qV5Sy
         +ujU2PYae4jgrPT3PnyzzOkOINlfdAbDPqhWhpY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 14/17] udp: Copy has_conns in reuseport_grow().
Date:   Thu, 30 Jul 2020 10:04:40 +0200
Message-Id: <20200730074421.161531583@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.449233408@linuxfoundation.org>
References: <20200730074420.449233408@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit f2b2c55e512879a05456eaf5de4d1ed2f7757509 ]

If an unconnected socket in a UDP reuseport group connect()s, has_conns is
set to 1. Then, when a packet is received, udp[46]_lib_lookup2() scans all
sockets in udp_hslot looking for the connected socket with the highest
score.

However, when the number of sockets bound to the port exceeds max_socks,
reuseport_grow() resets has_conns to 0. It can cause udp[46]_lib_lookup2()
to return without scanning all sockets, resulting in that packets sent to
connected sockets may be distributed to unconnected sockets.

Therefore, reuseport_grow() should copy has_conns.

Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
CC: Willem de Bruijn <willemb@google.com>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_reuseport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -112,6 +112,7 @@ static struct sock_reuseport *reuseport_
 	more_reuse->prog = reuse->prog;
 	more_reuse->reuseport_id = reuse->reuseport_id;
 	more_reuse->bind_inany = reuse->bind_inany;
+	more_reuse->has_conns = reuse->has_conns;
 
 	memcpy(more_reuse->socks, reuse->socks,
 	       reuse->num_socks * sizeof(struct sock *));


