Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A105D3A0294
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbhFHTG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235291AbhFHTDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D60A7613C1;
        Tue,  8 Jun 2021 18:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177956;
        bh=Km3k4y4r7QTpjJ911KmV5kWAD7VlX7z81i/NQACShCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5RmuYF06mdo+s4OdUkASIgnhd21xOGKDdm+KCKG3WpkdHTyTh4OZGM3D5qTywSj3
         BJnXKMUOjBqLlnWjUfkFojKCzPl5ZuA0BEW9bfdKqyDoapRMs3dWJ2RmMAhplrvg9Q
         LSZs0Ac/W5N14116Aj0/0RetZ9TXtTvzsiluqkyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 024/161] mptcp: fix sk_forward_memory corruption on retransmission
Date:   Tue,  8 Jun 2021 20:25:54 +0200
Message-Id: <20210608175946.266983139@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit b5941f066b4ca331db225a976dae1d6ca8cf0ae3 ]

MPTCP sk_forward_memory handling is a bit special, as such field
is protected by the msk socket spin_lock, instead of the plain
socket lock.

Currently we have a code path updating such field without handling
the relevant lock:

__mptcp_retrans() -> __mptcp_clean_una_wakeup()

Several helpers in __mptcp_clean_una_wakeup() will update
sk_forward_alloc, possibly causing such field corruption, as reported
by Matthieu.

Address the issue providing and using a new variant of blamed function
which explicitly acquires the msk spin lock.

Fixes: 64b9cea7a0af ("mptcp: fix spurious retransmissions")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/172
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 228dd40828c4..225b98821517 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -937,6 +937,10 @@ static void __mptcp_update_wmem(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(!lockdep_is_held(&sk->sk_lock.slock));
+#endif
+
 	if (!msk->wmem_reserved)
 		return;
 
@@ -1075,10 +1079,20 @@ out:
 
 static void __mptcp_clean_una_wakeup(struct sock *sk)
 {
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(!lockdep_is_held(&sk->sk_lock.slock));
+#endif
 	__mptcp_clean_una(sk);
 	mptcp_write_space(sk);
 }
 
+static void mptcp_clean_una_wakeup(struct sock *sk)
+{
+	mptcp_data_lock(sk);
+	__mptcp_clean_una_wakeup(sk);
+	mptcp_data_unlock(sk);
+}
+
 static void mptcp_enter_memory_pressure(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -2288,7 +2302,7 @@ static void __mptcp_retrans(struct sock *sk)
 	struct sock *ssk;
 	int ret;
 
-	__mptcp_clean_una_wakeup(sk);
+	mptcp_clean_una_wakeup(sk);
 	dfrag = mptcp_rtx_head(sk);
 	if (!dfrag) {
 		if (mptcp_data_fin_enabled(msk)) {
-- 
2.30.2



