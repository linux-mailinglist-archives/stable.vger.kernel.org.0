Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A47382FBF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbhEQOUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235734AbhEQOSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBD656139A;
        Mon, 17 May 2021 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260616;
        bh=3IjUhckdqDInYS9wKOMOIf9azJ1uG6SRWO0KmbO6Dts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pg9I+AtJllNxgK78P8+RqEFDQf22yiBSg7DGZvsUfSahkBteNgHtVQ1XO7VFc11Xf
         4+QwwFQnWfQmmQBdSna5FlN1oy9TAzzcA1KbFWUe6s31ilfn3P+UfgjLIdFvCdrjlz
         RVNAiZaQUTSZCZ04Zdz8lb87CGjvIWCU1u3IxQnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Dion <Christopher.Dion@dell.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 162/363] SUNRPC: Handle major timeout in xprt_adjust_timeout()
Date:   Mon, 17 May 2021 16:00:28 +0200
Message-Id: <20210517140308.080471762@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Dion <Christopher.Dion@dell.com>

[ Upstream commit 09252177d5f924f404551b4b4eded5daa7f04a3a ]

Currently if a major timeout value is reached, but the minor value has
not been reached, an ETIMEOUT will not be sent back to the caller.
This can occur if the v4 server is not responding to requests and
retrans is configured larger than the default of two.

For example, A TCP mount with a configured timeout value of 50 and a
retransmission count of 3 to a v4 server which is not responding:

1. Initial value and increment set to 5s, maxval set to 20s, retries at 3
2. Major timeout is set to 20s, minor timeout set to 5s initially
3. xport_adjust_timeout() is called after 5s, retry with 10s timeout,
   minor timeout is bumped to 10s
4. And again after another 10s, 15s total time with minor timeout set
   to 15s
5. After 20s total time xport_adjust_timeout is called as major timeout is
   reached, but skipped because the minor timeout is not reached
       - After this time the cpu spins continually calling
       	 xport_adjust_timeout() and returning 0 for 10 seconds.
	 As seen on perf sched:
   	 39243.913182 [0005]  mount.nfs[3794] 4607.938      0.017   9746.863
6. This continues until the 15s minor timeout condition is reached (in
   this case for 10 seconds). After which the ETIMEOUT is processed
   back to the caller, the cpu spinning stops, and normal operations
   continue

Fixes: 7de62bc09fe6 ("SUNRPC dont update timeout value on connection reset")
Signed-off-by: Chris Dion <Christopher.Dion@dell.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 11ebe8a127b8..20fe31b1b776 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -698,9 +698,9 @@ int xprt_adjust_timeout(struct rpc_rqst *req)
 	const struct rpc_timeout *to = req->rq_task->tk_client->cl_timeout;
 	int status = 0;
 
-	if (time_before(jiffies, req->rq_minortimeo))
-		return status;
 	if (time_before(jiffies, req->rq_majortimeo)) {
+		if (time_before(jiffies, req->rq_minortimeo))
+			return status;
 		if (to->to_exponential)
 			req->rq_timeout <<= 1;
 		else
-- 
2.30.2



