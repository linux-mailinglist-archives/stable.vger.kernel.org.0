Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465614123F8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378096AbhITS3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378882AbhITS0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B61DD632D9;
        Mon, 20 Sep 2021 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158756;
        bh=KgqqFPEDo4wF7is/0aM+fQH4uN8YsFXo/LPDc+m1Sb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hw9kHuf1hAMI/ZKpIPLWRVasWJRe6xWuYEzglUDGuwWY752v+HqDg8anLVd5If3og
         KpT7o9a7vioB2ZS2LPEHxU7pbvYuJH/4vf98NUsAAkeeuwG4AoT1zOp2P8PrRpCBIx
         tJLDMW0MNIxCZCfxANtVnK5Rqw9+1sQ5MF6d+uxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhenggy <zhenggy@chinatelecom.cn>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 042/122] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
Date:   Mon, 20 Sep 2021 18:43:34 +0200
Message-Id: <20210920163917.166697668@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhenggy <zhenggy@chinatelecom.cn>

commit 4f884f3962767877d7aabbc1ec124d2c307a4257 upstream.

Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
time") may directly retrans a multiple segments TSO/GSO packet without
split, Since this commit, we can no longer assume that a retransmitted
packet is a single segment.

This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
that use the actual segments(pcount) of the retransmitted packet.

Before that commit (10d3be569243), the assumption underlying the
tp->undo_retrans-- seems correct.

Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1314,7 +1314,7 @@ static u8 tcp_sacktag_one(struct sock *s
 	if (dup_sack && (sacked & TCPCB_RETRANS)) {
 		if (tp->undo_marker && tp->undo_retrans > 0 &&
 		    after(end_seq, tp->undo_marker))
-			tp->undo_retrans--;
+			tp->undo_retrans = max_t(int, 0, tp->undo_retrans - pcount);
 		if ((sacked & TCPCB_SACKED_ACKED) &&
 		    before(start_seq, state->reord))
 				state->reord = start_seq;


