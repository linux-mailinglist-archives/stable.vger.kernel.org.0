Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F61A38346E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbhEQPIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242348AbhEQPGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0C0261C22;
        Mon, 17 May 2021 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261748;
        bh=US3hMeH1GUE/kdBn25UaP8ob5GTGD4xJWzzbbSmWuSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kk0OTktpL54Y2LvA+gB8U+Vn9EmtXPP3RSPDaz23L4PO2YAf7aW/t1RGZ0+e5Jyfk
         SpC17TlWm8tLW7v1RojgsIXv9DuilaVexLBYjZaPaUN5ISb7cj6ZqAEM5TT79cBZA8
         bFUcev9LKB/0/6RglzUJNxT+ofL06YFVpduCnq8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
Subject: [PATCH 5.4 085/141] smc: disallow TCP_ULP in smc_setsockopt()
Date:   Mon, 17 May 2021 16:02:17 +0200
Message-Id: <20210517140245.647272111@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index dc09a72f8110..51986f7ead81 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1709,6 +1709,9 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	struct smc_sock *smc;
 	int val, rc;
 
+	if (level == SOL_TCP && optname == TCP_ULP)
+		return -EOPNOTSUPP;
+
 	smc = smc_sk(sk);
 
 	/* generic setsockopts reaching us here always apply to the
@@ -1730,7 +1733,6 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 	if (rc || smc->use_fallback)
 		goto out;
 	switch (optname) {
-	case TCP_ULP:
 	case TCP_FASTOPEN:
 	case TCP_FASTOPEN_CONNECT:
 	case TCP_FASTOPEN_KEY:
-- 
2.30.2



