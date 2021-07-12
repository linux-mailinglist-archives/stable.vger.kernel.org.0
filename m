Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C9F3C4984
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhGLGpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238902AbhGLGo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CB1D6113A;
        Mon, 12 Jul 2021 06:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072023;
        bh=JDCHfzRRxqFM3mlWflFPd2QT1nSKBO+3xo5gMnTWLMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q90Nj8L4tuxDFKHc+ZvZm/wuN2hZrVfMK6J534CcW9NSfv5Qr/fXboMxdMiZTuV8E
         Bj7erytZWDQcDUcVYGuX5B+/qgEqm2e/nHiiLq85jb6cXJZWefms/PCT26QKveuqr7
         pEzz74BwBnRkG/38Aax96QtvpRADcc8EafXtGNwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/593] mptcp: generate subflow hmac after mptcp_finish_join()
Date:   Mon, 12 Jul 2021 08:08:00 +0200
Message-Id: <20210712060920.786124903@linuxfoundation.org>
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
index 851fb3d8c791..bba5696fee36 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -338,15 +338,15 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
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
 	} else if (mptcp_check_fallback(sk)) {
-- 
2.30.2



