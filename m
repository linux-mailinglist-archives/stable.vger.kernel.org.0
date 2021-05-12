Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3C037CE74
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbhELRFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237984AbhELQn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 650E361289;
        Wed, 12 May 2021 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836046;
        bh=R3riXgMsE6+ftRbH6MoPYQzr7DTg/+r00hwk2ICL9nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWRkvTmYYShwuqLvgxQrxs5yHHjqL4qFoJFkgw9hXXo3Bvd6Kvv0MloiayCZ9i0Mn
         7Xu+2TyRVFV8MBu5erfzu7w6nYrB7YU8nsZ1+6257RXJAQ3ep6GGDTvUAPRBzci3xr
         83uUE0tuwTXzLUbmYUcGjCS8zMrpYmGPecbxPCig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 588/677] mptcp: fix format specifiers for unsigned int
Date:   Wed, 12 May 2021 16:50:34 +0200
Message-Id: <20210512144856.923239842@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit e4b6135134a75f530bd634ea7c168efaf0f9dff3 ]

Some of the sequence numbers are printed as the negative ones in the debug
log:

[   46.250932] MPTCP: DSS
[   46.250940] MPTCP: data_fin=0 dsn64=0 use_map=0 ack64=1 use_ack=1
[   46.250948] MPTCP: data_ack=2344892449471675613
[   46.251012] MPTCP: msk=000000006e157e3f status=10
[   46.251023] MPTCP: msk=000000006e157e3f snd_data_fin_enable=0 pending=0 snd_nxt=2344892449471700189 write_seq=2344892449471700189
[   46.251343] MPTCP: msk=00000000ec44a129 ssk=00000000f7abd481 sending dfrag at seq=-1658937016627538668 len=100 already sent=0
[   46.251360] MPTCP: data_seq=16787807057082012948 subflow_seq=1 data_len=100 dsn64=1

This patch used the format specifier %u instead of %d for the unsigned int
values to fix it.

Fixes: d9ca1de8c0cd ("mptcp: move page frag allocation in mptcp_sendmsg()")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4bde960e19dc..5043c7cb0782 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1275,7 +1275,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	int avail_size;
 	size_t ret = 0;
 
-	pr_debug("msk=%p ssk=%p sending dfrag at seq=%lld len=%d already sent=%d",
+	pr_debug("msk=%p ssk=%p sending dfrag at seq=%llu len=%u already sent=%u",
 		 msk, ssk, dfrag->data_seq, dfrag->data_len, info->sent);
 
 	/* compute send limit */
@@ -1693,7 +1693,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			if (!msk->first_pending)
 				WRITE_ONCE(msk->first_pending, dfrag);
 		}
-		pr_debug("msk=%p dfrag at seq=%lld len=%d sent=%d new=%d", msk,
+		pr_debug("msk=%p dfrag at seq=%llu len=%u sent=%u new=%d", msk,
 			 dfrag->data_seq, dfrag->data_len, dfrag->already_sent,
 			 !dfrag_collapsed);
 
-- 
2.30.2



