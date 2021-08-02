Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C883DD9E3
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhHBOFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236343AbhHBOCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1645D61132;
        Mon,  2 Aug 2021 13:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912618;
        bh=LledJ40SuU6u/o005yaxGhJF2oQz7Xfix55IiIKMjXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzpEC9j1Bd+xUFAaUfENNA5qGJQ+D3n/6q+GbNM7YqqnYlCJYxwrswt3Ddoad0nOR
         0t2LMpxlXmGtr4jTGQ34BcptlovActGglHJgztX6Z8AhjBJOj0IWUbeZgIWyYNwpQK
         M1mfzI2idkwF4jp/AWhwzT5qtJgwyKRHQd4YStcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 074/104] bpf, sockmap: Zap ingress queues after stopping strparser
Date:   Mon,  2 Aug 2021 15:45:11 +0200
Message-Id: <20210802134346.452247267@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 343597d558e79fe704ba8846b5b2ed24056b89c2 ]

We don't want strparser to run and pass skbs into skmsg handlers when
the psock is null. We just sk_drop them in this case. When removing
a live socket from map it means extra drops that we do not need to
incur. Move the zap below strparser close to avoid this condition.

This way we stop the stream parser first stopping it from processing
packets and then delete the psock.

Fixes: a136678c0bdbb ("bpf: sk_msg, zap ingress queue on psock down")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20210727160500.1713554-2-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index b2410a1bfa23..45b3a3adc886 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -790,8 +790,6 @@ static void sk_psock_destroy(struct work_struct *work)
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	sk_psock_stop(psock, false);
-
 	write_lock_bh(&sk->sk_callback_lock);
 	sk_psock_restore_proto(sk, psock);
 	rcu_assign_sk_user_data(sk, NULL);
@@ -801,6 +799,8 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
+	sk_psock_stop(psock, false);
+
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
 }
-- 
2.30.2



