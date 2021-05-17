Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D43835B2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243659AbhEQPYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244426AbhEQPUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F313561928;
        Mon, 17 May 2021 14:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262063;
        bh=rpSqR4MR4S37JY+TbR1OCsT8vEv9VQu8ZuJfas7Qs2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZV343FNVo4kxF7y5FgzjVVMb2E79LEcplHAZZWc2WP6TWAwqcU/l4mMUOGUvqgTkO
         Ih8lqs+NNQ30+lHzpOKebBCBDVWnhczhiCd909ZG/7ro2Qkxr+eyumZgGEOjqJcW5E
         cUdxe1IrVYfE9wdEt0PEVILKmJYh25Sev01dFXXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
Subject: [PATCH 5.11 210/329] smc: disallow TCP_ULP in smc_setsockopt()
Date:   Mon, 17 May 2021 16:02:01 +0200
Message-Id: <20210517140309.243688750@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 47340b3b514f..cb23cca72c24 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2162,6 +2162,9 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	struct smc_sock *smc;
 	int val, rc;
 
+	if (level == SOL_TCP && optname == TCP_ULP)
+		return -EOPNOTSUPP;
+
 	smc = smc_sk(sk);
 
 	/* generic setsockopts reaching us here always apply to the
@@ -2186,7 +2189,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	if (rc || smc->use_fallback)
 		goto out;
 	switch (optname) {
-	case TCP_ULP:
 	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_KEY:
-- 
2.30.2



