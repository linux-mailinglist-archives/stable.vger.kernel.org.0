Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF8838A4DA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhETKKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235549AbhETKJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:09:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E80A46192C;
        Thu, 20 May 2021 09:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503738;
        bh=/vVAZBTJczzepv2ZvtiWaqztKonQBlujdTGiwK4gbPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeZlzdGNBowxW8XDipGR+MdcN7BamYwE8QxIdkXMfSmGv/7hpKoMoaXt9GgjxAXdh
         aKiAVT1vzwBjJzY6Uqa7NKEUDEe7l8T6Llm3huGuxH56KBK5YhKGT1Ell6hKKcL4nf
         35XYlEBZxfcLPmdIvBHt+WAI44QRfnzPA96WOTSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
Subject: [PATCH 4.19 356/425] smc: disallow TCP_ULP in smc_setsockopt()
Date:   Thu, 20 May 2021 11:22:05 +0200
Message-Id: <20210520092143.108614291@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 8621436671f3a4bba5db57482e1ee604708bf1eb ]

syzbot is able to setup kTLS on an SMC socket which coincidentally
uses sk_user_data too. Later, kTLS treats it as psock so triggers a
refcnt warning. The root cause is that smc_setsockopt() simply calls
TCP setsockopt() which includes TCP_ULP. I do not think it makes
sense to setup kTLS on top of SMC sockets, so we should just disallow
this setup.

It is hard to find a commit to blame, but we can apply this patch
since the beginning of TCP_ULP.

Reported-and-tested-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
Fixes: 734942cc4ea6 ("tcp: ULP infrastructure")
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 26dcd02b2d0c..9aab4ab8161b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1644,6 +1644,9 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	struct smc_sock *smc;
 	int val, rc;
 
+	if (level == SOL_TCP && optname == TCP_ULP)
+		return -EOPNOTSUPP;
+
 	smc = smc_sk(sk);
 
 	/* generic setsockopts reaching us here always apply to the
@@ -1665,7 +1668,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 
 	lock_sock(sk);
 	switch (optname) {
-	case TCP_ULP:
 	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_KEY:
-- 
2.30.2



