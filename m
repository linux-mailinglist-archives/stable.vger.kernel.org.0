Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65C353FAE
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239546AbhDEJNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239541AbhDEJNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B17BF61394;
        Mon,  5 Apr 2021 09:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614015;
        bh=yITPNZzBjplsd1eXeTpzp3N3uXgPE05ROAcjZ6lMKW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxGoeD8gACRLFBKKJfaQNRJQsuMIKOCm/1+sMwYiUpKoIuFZnsTiNHTf/bpSIV9/p
         lfNNLSCjugJ+4q9htZttnvEjOYTjuLK/8rX+f2+2/u8Gr1krFUXd1dDjVd3mt852/N
         RvRXGC2x2FvpQHdTN4LXBYsKJqJckg0DvUUtbGUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 052/152] mptcp: fix bit MPTCP_PUSH_PENDING tests
Date:   Mon,  5 Apr 2021 10:53:21 +0200
Message-Id: <20210405085035.969887353@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2e5de7e0c8d2caa860e133ef71fc94671cb8e0bf ]

The MPTCP_PUSH_PENDING define is 6 and these tests should be testing if
BIT(6) is set.

Fixes: c2e6048fa1cf ("mptcp: fix race in release_cb")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7cbb544c6d02..5932b0ebecc3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2947,7 +2947,7 @@ static void mptcp_release_cb(struct sock *sk)
 	for (;;) {
 		flags = 0;
 		if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
-			flags |= MPTCP_PUSH_PENDING;
+			flags |= BIT(MPTCP_PUSH_PENDING);
 		if (!flags)
 			break;
 
@@ -2960,7 +2960,7 @@ static void mptcp_release_cb(struct sock *sk)
 		 */
 
 		spin_unlock_bh(&sk->sk_lock.slock);
-		if (flags & MPTCP_PUSH_PENDING)
+		if (flags & BIT(MPTCP_PUSH_PENDING))
 			__mptcp_push_pending(sk, 0);
 
 		cond_resched();
-- 
2.30.1



