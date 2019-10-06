Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83014CD52D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbfJFRd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729747AbfJFRd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:33:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DDB92080F;
        Sun,  6 Oct 2019 17:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383205;
        bh=/MaTq+pll+q1PEJdVMBNeWdM6vcaLTRr/4d4y9623qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKhBr1Rw+iHpXK8/MhN+B2NlDuk+A41+K8FY9rERr/EL6fCc9ktNdsg5i6U8MJAr6
         zEHoEbkpaNpsdyOP6CEojrpIfuOtJB7CYkFPI+Rc9SCsJZfbz71Jx49GXfY+LbOWO8
         za9eAF7CzOu0jWL8xQIiEZAKfl8N2oqzL+rVrk2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Marek Majkowski <marek@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 019/137] tcp: adjust rto_base in retransmits_timed_out()
Date:   Sun,  6 Oct 2019 19:20:03 +0200
Message-Id: <20191006171210.959241083@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3256a2d6ab1f71f9a1bd2d7f6f18eb8108c48d17 ]

The cited commit exposed an old retransmits_timed_out() bug
which assumed it could call tcp_model_timeout() with
TCP_RTO_MIN as rto_base for all states.

But flows in SYN_SENT or SYN_RECV state uses a different
RTO base (1 sec instead of 200 ms, unless BPF choses
another value)

This caused a reduction of SYN retransmits from 6 to 4 with
the default /proc/sys/net/ipv4/tcp_syn_retries value.

Fixes: a41e8a88b06e ("tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -198,8 +198,13 @@ static bool retransmits_timed_out(struct
 		return false;
 
 	start_ts = tcp_sk(sk)->retrans_stamp;
-	if (likely(timeout == 0))
-		timeout = tcp_model_timeout(sk, boundary, TCP_RTO_MIN);
+	if (likely(timeout == 0)) {
+		unsigned int rto_base = TCP_RTO_MIN;
+
+		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
+			rto_base = tcp_timeout_init(sk);
+		timeout = tcp_model_timeout(sk, boundary, rto_base);
+	}
 
 	return (s32)(tcp_time_stamp(tcp_sk(sk)) - start_ts - timeout) >= 0;
 }


