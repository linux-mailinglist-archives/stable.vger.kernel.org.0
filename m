Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB913F66FD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbhHXRaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241417AbhHXR2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:28:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B431B61B52;
        Tue, 24 Aug 2021 17:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824713;
        bh=vd/glk0D41c9nkW+K+kuUADgIAO1/HVSDZRGcrMVt2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DD/TxnAM6J0SmkghJN+5gY6Ji35aHRntMhSKhjt3z97UqokvV39eRiqtShPlullGF
         IT93bgsed+/ImyAUlaEirvMFtnyI+jslAB8sG/noCIFyw6V1FMR/wD5agbbQTJflDY
         t3HEkxdmgntDvMPTVHNcw2R9i7W0dkGBzm8R6h81KQ4kMEWxth8y59RrrLIGBinLUT
         yW/96qoMviX1vtdF243EkSLTEc/DIvRQFb8Z+OO8B86HQrycZSnqdD3lzcZ+Lc6T4U
         dTvKhqM3EOTVOKXmE//cs5FGS9QK1SLDVyoTyPGXlT7MMTv5z7MD+03yAM8oxTX9zT
         s3reJqF0UgNIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/64] tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets
Date:   Tue, 24 Aug 2021 13:04:08 -0400
Message-Id: <20210824170457.710623-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index bda10f7aea32..76a9652d90f2 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -840,7 +840,7 @@ static void bbr_init(struct sock *sk)
 	bbr->prior_cwnd = 0;
 	bbr->tso_segs_goal = 0;	 /* default segs per skb until first ACK */
 	bbr->rtt_cnt = 0;
-	bbr->next_rtt_delivered = 0;
+	bbr->next_rtt_delivered = tp->delivered;
 	bbr->prev_ca_state = TCP_CA_Open;
 	bbr->packet_conservation = 0;
 
-- 
2.30.2

