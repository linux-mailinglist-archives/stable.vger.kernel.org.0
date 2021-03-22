Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4B2344270
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhCVMlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhCVMjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF984601FF;
        Mon, 22 Mar 2021 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416724;
        bh=yXPTR5WMDksXketSchyHhW54ToXi5YoCJmRLrI4BHhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvB62yZLaZO7Grkn1cG2i1NFfUek4wkfSKuwPTAW8abRCvYw3FJ6hqzaw6MbxY7fV
         nM36Pu/bYCBpDHo/Xqxfoe1Gj2qM6/MHEFgnXc3TFC/jqjdIwU+hZuKkBR1BZ/VXoa
         Kf7A2YvWeZVWgyObqqNk7gXFSWeDb1OxLosTDEhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/157] mptcp: split mptcp_clean_una function
Date:   Mon, 22 Mar 2021 13:27:33 +0100
Message-Id: <20210322121936.823362992@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 95ed690ebc72ad6c89068f08197b51fe4d3c3b48 ]

mptcp_clean_una() will wake writers in case memory could be reclaimed.
When called from mptcp_sendmsg the wakeup code isn't needed.

Move the wakeup to a new helper and then use that from the mptcp worker.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f56b2e331bb6..0504a5f13c2a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -833,19 +833,25 @@ static void mptcp_clean_una(struct sock *sk)
 	}
 
 out:
-	if (cleaned) {
+	if (cleaned)
 		sk_mem_reclaim_partial(sk);
+}
 
-		/* Only wake up writers if a subflow is ready */
-		if (mptcp_is_writeable(msk)) {
-			set_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags);
-			smp_mb__after_atomic();
+static void mptcp_clean_una_wakeup(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
-			/* set SEND_SPACE before sk_stream_write_space clears
-			 * NOSPACE
-			 */
-			sk_stream_write_space(sk);
-		}
+	mptcp_clean_una(sk);
+
+	/* Only wake up writers if a subflow is ready */
+	if (mptcp_is_writeable(msk)) {
+		set_bit(MPTCP_SEND_SPACE, &msk->flags);
+		smp_mb__after_atomic();
+
+		/* set SEND_SPACE before sk_stream_write_space clears
+		 * NOSPACE
+		 */
+		sk_stream_write_space(sk);
 	}
 }
 
@@ -1751,7 +1757,7 @@ static void mptcp_worker(struct work_struct *work)
 	long timeo = 0;
 
 	lock_sock(sk);
-	mptcp_clean_una(sk);
+	mptcp_clean_una_wakeup(sk);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
 	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
-- 
2.30.1



