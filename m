Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7BE34CA4E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhC2Igd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233607AbhC2IfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 071D0619B7;
        Mon, 29 Mar 2021 08:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006905;
        bh=CWEkAvu3GxHKMXrz/HoF9TR8kjbU4r78qr+NTCyShWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX7It5+6LKR/CVs7kfx3tuJov/C4FoGZ08DJmWuur6izYeasxfVzV+6HnR1Ez+3Cq
         hbL6cbq258BhPuI8i7suwnGnNvDknXP1Ri1zQh9mGUmIwS/F57N2BRac55RJYKAi2Z
         R7VKmI7s8uCfPNBuclHQyaDKKL9Hu/VCk1hjK340=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 146/254] mptcp: fix ADD_ADDR HMAC in case port is specified
Date:   Mon, 29 Mar 2021 09:57:42 +0200
Message-Id: <20210329075638.006194240@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 13832ae2755395b2585500c85b64f5109a44227e ]

Currently, Linux computes the HMAC contained in ADD_ADDR sub-option using
the Address Id and the IP Address, and hardcodes a destination port equal
to zero. This is not ok for ADD_ADDR with port: ensure to account for the
endpoint port when computing the HMAC, in compliance with RFC8684 §3.4.1.

Fixes: 22fb85ffaefb ("mptcp: add port support for ADD_ADDR suboption writing")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 2e26e39169b8..37ef0bf098f6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -555,15 +555,15 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 }
 
 static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
-				  struct in_addr *addr)
+				  struct in_addr *addr, u16 port)
 {
 	u8 hmac[SHA256_DIGEST_SIZE];
 	u8 msg[7];
 
 	msg[0] = addr_id;
 	memcpy(&msg[1], &addr->s_addr, 4);
-	msg[5] = 0;
-	msg[6] = 0;
+	msg[5] = port >> 8;
+	msg[6] = port & 0xFF;
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 7, hmac);
 
@@ -572,15 +572,15 @@ static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
-				   struct in6_addr *addr)
+				   struct in6_addr *addr, u16 port)
 {
 	u8 hmac[SHA256_DIGEST_SIZE];
 	u8 msg[19];
 
 	msg[0] = addr_id;
 	memcpy(&msg[1], &addr->s6_addr, 16);
-	msg[17] = 0;
-	msg[18] = 0;
+	msg[17] = port >> 8;
+	msg[18] = port & 0xFF;
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 19, hmac);
 
@@ -634,7 +634,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 			opts->ahmac = add_addr_generate_hmac(msk->local_key,
 							     msk->remote_key,
 							     opts->addr_id,
-							     &opts->addr);
+							     &opts->addr,
+							     opts->port);
 		}
 	}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -645,7 +646,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 			opts->ahmac = add_addr6_generate_hmac(msk->local_key,
 							      msk->remote_key,
 							      opts->addr_id,
-							      &opts->addr6);
+							      &opts->addr6,
+							      opts->port);
 		}
 	}
 #endif
@@ -922,12 +924,14 @@ static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 	if (mp_opt->family == MPTCP_ADDR_IPVERSION_4)
 		hmac = add_addr_generate_hmac(msk->remote_key,
 					      msk->local_key,
-					      mp_opt->addr_id, &mp_opt->addr);
+					      mp_opt->addr_id, &mp_opt->addr,
+					      mp_opt->port);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	else
 		hmac = add_addr6_generate_hmac(msk->remote_key,
 					       msk->local_key,
-					       mp_opt->addr_id, &mp_opt->addr6);
+					       mp_opt->addr_id, &mp_opt->addr6,
+					       mp_opt->port);
 #endif
 
 	pr_debug("msk=%p, ahmac=%llu, mp_opt->ahmac=%llu\n",
-- 
2.30.1



