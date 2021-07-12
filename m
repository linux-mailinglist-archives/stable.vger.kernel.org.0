Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CB23C5443
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348245AbhGLH5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350478AbhGLHxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65730611C0;
        Mon, 12 Jul 2021 07:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076260;
        bh=NDTeF9jRQYGMld5yoLb/TP/JVupuudUSpdaR4NNp2iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWLEgTgdwvIK8wV2aZKrVEUowMTspOiPSVsU82huJCuj1xkCVuzYHMwSPIWYY1ygW
         eb8JQCyFIHxDxZQLJVTdWRtQ/ysg1Io77aGJ8Fs91BJk+mGDGv8A1UH0Qo8yi1+3l8
         Xa/5hAko6+mATImWO7XZac+580FtqHgRrzebkUF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 524/800] mptcp: fix bad handling of 32 bit ack wrap-around
Date:   Mon, 12 Jul 2021 08:09:07 +0200
Message-Id: <20210712061022.991335799@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 1502328f17ab0684ca5ed6764433aa0a83bdaf95 ]

When receiving 32 bits DSS ack from the peer, the MPTCP need
to expand them to 64 bits value. The current code is buggy
WRT detecting 32 bits ack wrap-around: when the wrap-around
happens the current unsigned 32 bit ack value is lower than
the previous one.

Additionally check for possible reverse wrap and make the helper
visible, so that we could re-use it for the next patch.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/204
Fixes: cc9d25669866 ("mptcp: update per unacked sequence on pkt reception")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  | 29 +++++++++++++++--------------
 net/mptcp/protocol.h |  8 ++++++++
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9b263f27ce9b..b87e46f515fb 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -896,19 +896,20 @@ reset:
 	return false;
 }
 
-static u64 expand_ack(u64 old_ack, u64 cur_ack, bool use_64bit)
+u64 __mptcp_expand_seq(u64 old_seq, u64 cur_seq)
 {
-	u32 old_ack32, cur_ack32;
-
-	if (use_64bit)
-		return cur_ack;
-
-	old_ack32 = (u32)old_ack;
-	cur_ack32 = (u32)cur_ack;
-	cur_ack = (old_ack & GENMASK_ULL(63, 32)) + cur_ack32;
-	if (unlikely(before(cur_ack32, old_ack32)))
-		return cur_ack + (1LL << 32);
-	return cur_ack;
+	u32 old_seq32, cur_seq32;
+
+	old_seq32 = (u32)old_seq;
+	cur_seq32 = (u32)cur_seq;
+	cur_seq = (old_seq & GENMASK_ULL(63, 32)) + cur_seq32;
+	if (unlikely(cur_seq32 < old_seq32 && before(old_seq32, cur_seq32)))
+		return cur_seq + (1LL << 32);
+
+	/* reverse wrap could happen, too */
+	if (unlikely(cur_seq32 > old_seq32 && after(old_seq32, cur_seq32)))
+		return cur_seq - (1LL << 32);
+	return cur_seq;
 }
 
 static void ack_update_msk(struct mptcp_sock *msk,
@@ -926,7 +927,7 @@ static void ack_update_msk(struct mptcp_sock *msk,
 	 * more dangerous than missing an ack
 	 */
 	old_snd_una = msk->snd_una;
-	new_snd_una = expand_ack(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
+	new_snd_una = mptcp_expand_seq(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
 	/* ACK for data not even sent yet? Ignore. */
 	if (after64(new_snd_una, snd_nxt))
@@ -963,7 +964,7 @@ bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool us
 		return false;
 
 	WRITE_ONCE(msk->rcv_data_fin_seq,
-		   expand_ack(READ_ONCE(msk->ack_seq), data_fin_seq, use_64bit));
+		   mptcp_expand_seq(READ_ONCE(msk->ack_seq), data_fin_seq, use_64bit));
 	WRITE_ONCE(msk->rcv_data_fin, 1);
 
 	return true;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 385796f0ef19..5d7c44028e47 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -593,6 +593,14 @@ int mptcp_setsockopt(struct sock *sk, int level, int optname,
 int mptcp_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *option);
 
+u64 __mptcp_expand_seq(u64 old_seq, u64 cur_seq);
+static inline u64 mptcp_expand_seq(u64 old_seq, u64 cur_seq, bool use_64bit)
+{
+	if (use_64bit)
+		return cur_seq;
+
+	return __mptcp_expand_seq(old_seq, cur_seq);
+}
 void __mptcp_check_push(struct sock *sk, struct sock *ssk);
 void __mptcp_data_acked(struct sock *sk);
 void __mptcp_error_report(struct sock *sk);
-- 
2.30.2



