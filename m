Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83723469B40
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350769AbhLFPOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:14:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43014 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347315AbhLFPLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:11:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3767B8111E;
        Mon,  6 Dec 2021 15:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB749C341C1;
        Mon,  6 Dec 2021 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803289;
        bh=AxtXMlghJxHFn1DT/OyqsjE+XfAX5Rdq7Ug0XRPiTwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pew1+P15fzByeuli2ccSDWkPSdmg0h5ttDq5lROD1hlgppqdgC9cI1DR4qlBLib5H
         YE8RDOeK0q3PoRziQpTMXnrrQ7z/TwxzX/VtwI2qTz9dGh6TIy+fdmulZTrkfxs6d8
         gVW/GUZv8Q03iYh8BxBWKtS+8ev42Bj9bGSH0Lus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        William Kucharski <william.kucharski@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 095/106] net/rds: correct socket tunable error in rds_tcp_tune()
Date:   Mon,  6 Dec 2021 15:56:43 +0100
Message-Id: <20211206145558.829802371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Kucharski <william.kucharski@oracle.com>

commit 19f36edf14bcdb783aef3af8217df96f76a8ce34 upstream.

Correct an error where setting /proc/sys/net/rds/tcp/rds_tcp_rcvbuf would
instead modify the socket's sk_sndbuf and would leave sk_rcvbuf untouched.

Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on rds-tcp socket")
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -392,7 +392,7 @@ void rds_tcp_tune(struct socket *sock)
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 	}
 	if (rtn->rcvbuf_size > 0) {
-		sk->sk_sndbuf = rtn->rcvbuf_size;
+		sk->sk_rcvbuf = rtn->rcvbuf_size;
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
 	release_sock(sk);


