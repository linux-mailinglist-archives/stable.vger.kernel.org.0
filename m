Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544E1126D83
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfLSSgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:36:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbfLSSgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:36:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C35624685;
        Thu, 19 Dec 2019 18:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780606;
        bh=9P/PmFr8QwkkPCwyg8tLxg+CnZ8404FjjoYCGQo8n+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7+R8EZuyRnt//JTKL37Vlx5K/FrtcEDgdM6uD1ZELeNeh5xRFz/WxSAec33I2DTX
         tauxyVPL6Y5Rl2BLGmI6yjFZujQv+81fM+SuphvhpRekGMrnvJ4RyMspd3mtfCfd8R
         VZVUMxQAIzNBSl3RSKGxb2J1q8UIM1YNl+JkwIg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 043/162] tcp: fix off-by-one bug on aborting window-probing socket
Date:   Thu, 19 Dec 2019 19:32:31 +0100
Message-Id: <20191219183210.543197518@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 3976535af0cb9fe34a55f2ffb8d7e6b39a2f8188 ]

Previously there is an off-by-one bug on determining when to abort
a stalled window-probing socket. This patch fixes that so it is
consistent with tcp_write_timeout().

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 61359944acc71..710cde1a5a832 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -336,7 +336,7 @@ static void tcp_probe_timer(struct sock *sk)
 			return;
 	}
 
-	if (icsk->icsk_probes_out > max_probes) {
+	if (icsk->icsk_probes_out >= max_probes) {
 abort:		tcp_write_err(sk);
 	} else {
 		/* Only send another probe if we didn't close things up. */
-- 
2.20.1



