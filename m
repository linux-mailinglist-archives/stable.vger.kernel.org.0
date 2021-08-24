Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003033F664D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhHXRWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241069AbhHXRTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B931B617E3;
        Tue, 24 Aug 2021 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824591;
        bh=LqwDb4k7nZfBJP/yc6dPB75xfe5kYjLggEri0yfggxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esbi3a3hsxiQ63Tw0s7V5nV1eRW8Zp1Q3kKj9JoqNuS4/vFimjWDTqrpFTDKkrI8f
         JBkjWdFEnvziw+i2fi0Ft0ohT6lhubqbzDm2iOKqzx2NzWBb2WQgY/rGoJ9o6lfZCr
         vslEuab0d03KQ1YFnLvAz8zX/Nx9SP+8fL4XsiG7R4GnwdcXdUeBmJZURKSCVw4Dd3
         lpOFV6waWmmhKAvlO0nKQcj1e2pw7mgQYE51VExACaavy1KfzWqsbGFq9e6EyfQI2J
         t20Y7eH0WaD3C+Cl5VyJEe0/B3nX9H2dJ1mSOwohReyCcDHIjLDTNQ6eCPlyRa3cp+
         yGONgKxYtytug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/84] tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets
Date:   Tue, 24 Aug 2021 13:01:46 -0400
Message-Id: <20210824170250.710392-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 6de035fec045f8ae5ee5f3a02373a18b939e91fb ]

Currently if BBR congestion control is initialized after more than 2B
packets have been delivered, depending on the phase of the
tp->delivered counter the tracking of BBR round trips can get stuck.

The bug arises because if tp->delivered is between 2^31 and 2^32 at
the time the BBR congestion control module is initialized, then the
initialization of bbr->next_rtt_delivered to 0 will cause the logic to
believe that the end of the round trip is still billions of packets in
the future. More specifically, the following check will fail
repeatedly:

  !before(rs->prior_delivered, bbr->next_rtt_delivered)

and thus the connection will take up to 2B packets delivered before
that check will pass and the connection will set:

  bbr->round_start = 1;

This could cause many mechanisms in BBR to fail to trigger, for
example bbr_check_full_bw_reached() would likely never exit STARTUP.

This bug is 5 years old and has not been observed, and as a practical
matter this would likely rarely trigger, since it would require
transferring at least 2B packets, or likely more than 3 terabytes of
data, before switching congestion control algorithms to BBR.

This patch is a stable candidate for kernels as far back as v4.9,
when tcp_bbr.c was added.

Fixes: 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Kevin Yang <yyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210811024056.235161-1-ncardwell@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index b70c9365e131..1740de053072 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -985,7 +985,7 @@ static void bbr_init(struct sock *sk)
 	bbr->prior_cwnd = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	bbr->rtt_cnt = 0;
-	bbr->next_rtt_delivered = 0;
+	bbr->next_rtt_delivered = tp->delivered;
 	bbr->prev_ca_state = TCP_CA_Open;
 	bbr->packet_conservation = 0;
 
-- 
2.30.2

