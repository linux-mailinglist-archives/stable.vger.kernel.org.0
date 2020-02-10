Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74892157B08
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgBJN06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgBJMgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:40 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074DF20873;
        Mon, 10 Feb 2020 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338200;
        bh=N5y7pKX80UIjRezLrQE5/bhaJl9jZEsKZ2aCw4TLKh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+1NmE3m6lVwrSJJ3PcIj7LghaXJcFmdyOQxe7NAJ1mQZO1rHLoOH6CwGQAcD9Dij
         u4At9YdCKAgt3wmBddtLQP8EnVVqe/5A7V24CujrZDTUkxs5wnVFGPWoMMHeeHRtm0
         EoWqvHxNdeIS2QDkd/j3iBSHqe3bymBlH5U6uYPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 015/309] tcp: clear tp->delivered in tcp_disconnect()
Date:   Mon, 10 Feb 2020 04:29:31 -0800
Message-Id: <20200210122407.475689871@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2fbdd56251b5c62f96589f39eded277260de7267 ]

tp->delivered needs to be cleared in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: ddf1af6fa00e ("tcp: new delivery accounting")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2618,6 +2618,7 @@ int tcp_disconnect(struct sock *sk, int
 	tp->snd_cwnd = TCP_INIT_CWND;
 	tp->snd_cwnd_cnt = 0;
 	tp->window_clamp = 0;
+	tp->delivered = 0;
 	tp->delivered_ce = 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;


