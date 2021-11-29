Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC262461EA9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379477AbhK2Siz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:38:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53792 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379760AbhK2Sgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:36:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5702CE13D4;
        Mon, 29 Nov 2021 18:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A637C53FC7;
        Mon, 29 Nov 2021 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210813;
        bh=rxvCsD+HyTXFzTikIvOXgnOyLXrUg4eMwcGFFCSQldQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG5WIj/OGBFca1OZIBN8ShtGtvaqv8ONtfcd5JZA1yA4e5xHV/60V/NGBp1X01RkK
         7AXP6VunO2VfB+LfQyxu4Nzz+PoNlmVTCuvUwI1fluO3GqxJfGscL/WjQ0Hop9d0c4
         ZP6v2Slh8tIFbGrXlSoy52hBndFx0Hn6KQuSYcZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Roy <arjunroy@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/121] tcp: correctly handle increased zerocopy args struct size
Date:   Mon, 29 Nov 2021 19:18:52 +0100
Message-Id: <20211129181715.064523309@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

[ Upstream commit e0fecb289ad3fd2245cdc50bf450b97fcca39884 ]

A prior patch increased the size of struct tcp_zerocopy_receive
but did not update do_tcp_getsockopt() handling to properly account
for this.

This patch simply reintroduces content erroneously cut from the
referenced prior patch that handles the new struct size.

Fixes: 18fb76ed5386 ("net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bb16c88f58a3c..63c81af41b43e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3931,7 +3931,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	}
 #ifdef CONFIG_MMU
 	case TCP_ZEROCOPY_RECEIVE: {
-		struct tcp_zerocopy_receive zc;
+		struct tcp_zerocopy_receive zc = {};
 		int err;
 
 		if (get_user(len, optlen))
@@ -3949,7 +3949,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc);
 		release_sock(sk);
-		if (len == sizeof(zc))
+		if (len >= offsetofend(struct tcp_zerocopy_receive, err))
 			goto zerocopy_rcv_sk_err;
 		switch (len) {
 		case offsetofend(struct tcp_zerocopy_receive, err):
-- 
2.33.0



