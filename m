Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C0A3C53D4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348799AbhGLH4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350713AbhGLHvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA766191A;
        Mon, 12 Jul 2021 07:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076053;
        bh=DtxPYX7uCBlwj0jULAwa+5gtQTwcVooFOqJZif4rFkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czYsL+rO3XcJUPxSPzy1k7aZe/PgbptvY/Xw1dsOfd4nUBGrT/gI/lEy/23seLaA8
         WBf551CS5Z6jEBP/T8ft3OmOapbrzGjmsAxcxOHY5id76Zx6UBgySnoxjKvtZJI8OX
         S26CtvI+xMeR30qmtS3nZsbyi+aFbbuiHi65/5JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 425/800] mptcp: generate subflow hmac after mptcp_finish_join()
Date:   Mon, 12 Jul 2021 08:07:28 +0200
Message-Id: <20210712061012.352920878@linuxfoundation.org>
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

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit 0a4d8e96e4fd687af92b961d5cdcea0fdbde05fe ]

For outgoing subflow join, when recv SYNACK, in subflow_finish_connect(),
the mptcp_finish_join() may return false in some cases, and send a RESET
to remote, and no local hmac is required.
So generate subflow hmac after mptcp_finish_join().

Fixes: ec3edaa7ca6c ("mptcp: Add handling of outgoing MP_JOIN requests")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index be1de4084196..3a396451d628 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -430,15 +430,15 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			goto do_reset;
 		}
 
+		if (!mptcp_finish_join(sk))
+			goto do_reset;
+
 		subflow_generate_hmac(subflow->local_key, subflow->remote_key,
 				      subflow->local_nonce,
 				      subflow->remote_nonce,
 				      hmac);
 		memcpy(subflow->hmac, hmac, MPTCPOPT_HMAC_LEN);
 
-		if (!mptcp_finish_join(sk))
-			goto do_reset;
-
 		subflow->mp_join = 1;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
 
-- 
2.30.2



