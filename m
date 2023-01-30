Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B176810E9
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbjA3OIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbjA3OIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8190E8686
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35660B811BD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6365FC433D2;
        Mon, 30 Jan 2023 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087691;
        bh=Y+i2gkQnmChDAVNtorTVPXAohCFUGGd5arZWOS2uUCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5YrMD4qmwkWBf9fW1ahiZA0h6q7MID8DrzCLGXTv2I2Osa0Ard/aQhLT4AghPA0l
         gTMshFhI1tRLTKKhV3kDCzrTSWFxfXiCMgNfywUqV8TLJOjnGo+/YfTY701NoU4SyM
         YHhlhxkP1kb3wQ/Zvt3WYYU3As44S+RcwfCPidMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/313] net: mctp: mark socks as dead on unhash, prevent re-add
Date:   Mon, 30 Jan 2023 14:52:07 +0100
Message-Id: <20230130134350.341765098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit b98e1a04e27fddfdc808bf46fe78eca30db89ab3 ]

Once a socket has been unhashed, we want to prevent it from being
re-used in a sk_key entry as part of a routing operation.

This change marks the sk as SOCK_DEAD on unhash, which prevents addition
into the net's key list.

We need to do this during the key add path, rather than key lookup, as
we release the net keys_lock between those operations.

Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 1 +
 net/mctp/route.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index fb6ae3110528..45bbe3e54cc2 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -577,6 +577,7 @@ static void mctp_sk_unhash(struct sock *sk)
 		spin_lock_irqsave(&key->lock, fl2);
 		__mctp_key_remove(key, net, fl2, MCTP_TRACE_KEY_CLOSED);
 	}
+	sock_set_flag(sk, SOCK_DEAD);
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	/* Since there are no more tag allocations (we have removed all of the
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 06c0de21984d..f51a05ec7162 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -179,6 +179,11 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 
 	spin_lock_irqsave(&net->mctp.keys_lock, flags);
 
+	if (sock_flag(&msk->sk, SOCK_DEAD)) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+
 	hlist_for_each_entry(tmp, &net->mctp.keys, hlist) {
 		if (mctp_key_match(tmp, key->local_addr, key->peer_addr,
 				   key->tag)) {
@@ -200,6 +205,7 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 		hlist_add_head(&key->sklist, &msk->keys);
 	}
 
+out_unlock:
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	return rc;
-- 
2.39.0



