Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79AE3C4999
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbhGLGpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238861AbhGLGoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE46D61106;
        Mon, 12 Jul 2021 06:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072018;
        bh=YA1aqqi/Kf4K8twhWf8nItqHqjxb6lc5h4VNdssRFZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjvjNyau4VkdWxvBLxskpM43cl8XWTCCCGHefBVF39tiBYNbF1AzJjFbtVIx7BnQf
         Jzvguw1fswAcFTZjR3ZvtX1Gu1tChmp6AD3YxcpmY81yhVDgeHK10hIBiBld282Cd8
         4SrPD44lOEr43VOGykSfpLRwga+5BH1X6RpMaVZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jianguo Wu <wujianguo@chinatelecom.cn>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/593] mptcp: fix pr_debug in mptcp_token_new_connect
Date:   Mon, 12 Jul 2021 08:07:59 +0200
Message-Id: <20210712060920.647424120@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit 2f1af441fd5dd5caf0807bb19ce9bbf9325ce534 ]

After commit 2c5ebd001d4f ("mptcp: refactor token container"),
pr_debug() is called before mptcp_crypto_key_gen_sha() in
mptcp_token_new_connect(), so the output local_key, token and
idsn are 0, like:

  MPTCP: ssk=00000000f6b3c4a2, local_key=0, token=0, idsn=0

Move pr_debug() after mptcp_crypto_key_gen_sha().

Fixes: 2c5ebd001d4f ("mptcp: refactor token container")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/token.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index feb4b9ffd462..0691a4883f3a 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -156,9 +156,6 @@ int mptcp_token_new_connect(struct sock *sk)
 	int retries = TOKEN_MAX_RETRIES;
 	struct token_bucket *bucket;
 
-	pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
-		 sk, subflow->local_key, subflow->token, subflow->idsn);
-
 again:
 	mptcp_crypto_key_gen_sha(&subflow->local_key, &subflow->token,
 				 &subflow->idsn);
@@ -172,6 +169,9 @@ again:
 		goto again;
 	}
 
+	pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
+		 sk, subflow->local_key, subflow->token, subflow->idsn);
+
 	WRITE_ONCE(msk->token, subflow->token);
 	__sk_nulls_add_node_rcu((struct sock *)msk, &bucket->msk_chain);
 	bucket->chain_len++;
-- 
2.30.2



