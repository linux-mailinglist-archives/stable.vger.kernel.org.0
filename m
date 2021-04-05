Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78F7353F9C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhDEJNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239375AbhDEJNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D9760FE4;
        Mon,  5 Apr 2021 09:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613992;
        bh=r3I5WQMZlWTKxoKByZxDKviWFewVW04oiDP9IKaoL0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HfhDhZgD45ZuGXkIKiMdUFWbf3hueHtEX/Avlx0n6DtjBZThOuUbMoxKl8k/1Aa8
         sIlUWqm01QGKHWl6v+F+8Hx6JFO9B/ExD2m2DRDt3LnAa6dKHUQlEL9HkX2kLmBkGc
         DKXW2iUbu9U2L7N5sC14gA04jvjS1ha9roMnlNbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 044/152] mptcp: add a missing retransmission timer scheduling
Date:   Mon,  5 Apr 2021 10:53:13 +0200
Message-Id: <20210405085035.708563743@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit d09d818ec2ed31bce94fdcfcc4700233e01f8498 ]

Currently we do not schedule the MPTCP retransmission
timer after pushing the data when such action happens
in the subflow context.

This may cause hang-up on active-backup scenarios, or
even when only single subflow msks are involved, if we lost
some peer's ack.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  | 3 +--
 net/mptcp/protocol.c | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 37ef0bf098f6..9e86c601093f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -885,8 +885,7 @@ static void ack_update_msk(struct mptcp_sock *msk,
 		msk->wnd_end = new_wnd_end;
 
 	/* this assumes mptcp_incoming_options() is invoked after tcp_ack() */
-	if (after64(msk->wnd_end, READ_ONCE(msk->snd_nxt)) &&
-	    sk_stream_memory_free(ssk))
+	if (after64(msk->wnd_end, READ_ONCE(msk->snd_nxt)))
 		__mptcp_check_push(sk, ssk);
 
 	if (after64(new_snd_una, old_snd_una)) {
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 44b8868f0607..67483e561b37 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1568,6 +1568,9 @@ out:
 		mptcp_set_timeout(sk, ssk);
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
+		if (!mptcp_timer_pending(sk))
+			mptcp_reset_timer(sk);
+
 		if (msk->snd_data_fin_enable &&
 		    msk->snd_nxt + 1 == msk->write_seq)
 			mptcp_schedule_work(sk);
-- 
2.30.1



