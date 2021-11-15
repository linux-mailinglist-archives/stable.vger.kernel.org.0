Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B990C450BA6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbhKOR0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237864AbhKORYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5FEA63257;
        Mon, 15 Nov 2021 17:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996579;
        bh=I9lB8262yqKEO2xuMPi3uefqONHQAHIQDJBf+fl7bEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dO9StBRCrCJEVBSuSsUx/PIF7X6czSLBLVJSlJFp6x2s8nanD7r5EVG+R4tDGUYDa
         a0GTmH16gBWgP/i1lwyFuHyYwVP3FKOzsBjkK12e0+y4m4IRsh8u+mDMswLkpTDsyB
         cWDLpYR6lm3+wm0r3FiSdKhgjXedtb9nat11MCM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/355] rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()
Date:   Mon, 15 Nov 2021 18:01:55 +0100
Message-Id: <20211115165319.945636119@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit acde891c243c1ed85b19d4d5042bdf00914f5739 ]

Directly using _usecs_to_jiffies() might be unsafe, so it's
better to use usecs_to_jiffies() instead.
Because we can see that the result of _usecs_to_jiffies()
could be larger than MAX_JIFFY_OFFSET values without the
check of the input.

Fixes: c410bf01933e ("Fix the excessive initial retransmission timeout")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rtt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rtt.c b/net/rxrpc/rtt.c
index 928d8b34a3eee..f3f87c9f0209d 100644
--- a/net/rxrpc/rtt.c
+++ b/net/rxrpc/rtt.c
@@ -23,7 +23,7 @@ static u32 rxrpc_rto_min_us(struct rxrpc_peer *peer)
 
 static u32 __rxrpc_set_rto(const struct rxrpc_peer *peer)
 {
-	return _usecs_to_jiffies((peer->srtt_us >> 3) + peer->rttvar_us);
+	return usecs_to_jiffies((peer->srtt_us >> 3) + peer->rttvar_us);
 }
 
 static u32 rxrpc_bound_rto(u32 rto)
-- 
2.33.0



