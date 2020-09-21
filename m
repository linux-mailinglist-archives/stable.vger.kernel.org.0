Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BFF272DE1
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgIUQni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729617AbgIUQnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C4B23A1E;
        Mon, 21 Sep 2020 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706612;
        bh=DopP0TXFS0MBEU+sZLrZgDrgeACAe7ZZZdRuOn1hAGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW0tqI9R91nI2swdLdep9V1p8LhEhhQjr5c1cuBXuGQ5X5a1k+iZGHemqdofJ7aO3
         BVNeAHwfeXqZzYCuJ/byxBOsM1TkPlg7RyR8hys/+CazXx0Jl/JSYjtnQQ9YnByjLr
         yFosKdhObpZFArb3ROo0ySiXjEALr5QqUzrquv+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 003/118] mptcp: sendmsg: reset iter on error
Date:   Mon, 21 Sep 2020 18:26:55 +0200
Message-Id: <20200921162036.501567458@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 35759383133f64d90eba120a0d3efe8f71241650 upstream.

Once we've copied data from the iterator we need to revert in case we
end up not sending any data.

This bug doesn't trigger with normal 'poll' based tests, because
we only feed a small chunk of data to kernel after poll indicated
POLLOUT.  With blocking IO and large writes this triggers. Receiver
ends up with less data than it should get.

Fixes: 72511aab95c94d ("mptcp: avoid blocking in tcp_sendpages")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mptcp/protocol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -605,8 +605,10 @@ static int mptcp_sendmsg_frag(struct soc
 		if (!psize)
 			return -EINVAL;
 
-		if (!sk_wmem_schedule(sk, psize + dfrag->overhead))
+		if (!sk_wmem_schedule(sk, psize + dfrag->overhead)) {
+			iov_iter_revert(&msg->msg_iter, psize);
 			return -ENOMEM;
+		}
 	} else {
 		offset = dfrag->offset;
 		psize = min_t(size_t, dfrag->data_len, avail_size);
@@ -617,8 +619,10 @@ static int mptcp_sendmsg_frag(struct soc
 	 */
 	ret = do_tcp_sendpages(ssk, page, offset, psize,
 			       msg->msg_flags | MSG_SENDPAGE_NOTLAST | MSG_DONTWAIT);
-	if (ret <= 0)
+	if (ret <= 0) {
+		iov_iter_revert(&msg->msg_iter, psize);
 		return ret;
+	}
 
 	frag_truesize += ret;
 	if (!retransmission) {


