Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C4B111E09
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbfLCW7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730463AbfLCW7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:59:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D765D20803;
        Tue,  3 Dec 2019 22:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413953;
        bh=XJkddDQE9s/f7qQY0cKrwqiTwysFXGZyfUzENxoinlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1g/dXJt1wGYip2tvh9p80+Q22wyvprrbmRPrMNqHSNIXu/So9ZFpLPGVO73vLW0Zy
         VFJQ4mN2x7D/giFFDX1/DeHFuN8myOg3A/TIE8PfOwzGqE1qZXGFQ+Q5LuCjl8Fj1m
         1OHDv7rGxMB/l7VyQiKHpt9WhWbJ1OGWIXm9R9gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 303/321] tcp: exit if nothing to retransmit on RTO timeout
Date:   Tue,  3 Dec 2019 23:36:09 +0100
Message-Id: <20191203223442.911850160@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

commit 88f8598d0a302a08380eadefd09b9f5cb1c4c428 upstream.

Previously TCP only warns if its RTO timer fires and the
retransmission queue is empty, but it'll cause null pointer
reference later on. It's better to avoid such catastrophic failure
and simply exit with a warning.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/tcp_timer.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -443,10 +443,8 @@ void tcp_retransmit_timer(struct sock *s
 		 */
 		return;
 	}
-	if (!tp->packets_out)
-		goto out;
-
-	WARN_ON(tcp_rtx_queue_empty(sk));
+	if (!tp->packets_out || WARN_ON_ONCE(tcp_rtx_queue_empty(sk)))
+		return;
 
 	tp->tlp_high_seq = 0;
 


