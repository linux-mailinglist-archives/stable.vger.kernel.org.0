Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68523AED70
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFUQUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhFUQTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:19:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF8461261;
        Mon, 21 Jun 2021 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292249;
        bh=r5hFlrbhEQOPVmyOTnKJiMArl514zZExxYE1qGVCGuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blMdYytBr89E3Jb7S9mGDjhLuw+Rs6PbtUJUFoN+E38EFHKGjJCAbbz4H38YbUXu1
         bqWe5O0PWfYXygmAfuGU2SV19F+jU1e49CfOPEcvVzY/G7Y9SGvD7kiIgmfR24qWDm
         FFSO/ebxNrEIDIo4lo8owKf1Ym+Tnmfqbj0A06J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/90] netfilter: synproxy: Fix out of bounds when parsing TCP options
Date:   Mon, 21 Jun 2021 18:14:55 +0200
Message-Id: <20210621154904.817295060@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 5fc177ab759418c9537433e63301096e733fb915 ]

The TCP option parser in synproxy (synproxy_parse_options) could read
one byte out of bounds. When the length is 1, the execution flow gets
into the loop, reads one byte of the opcode, and if the opcode is
neither TCPOPT_EOL nor TCPOPT_NOP, it reads one more byte, which exceeds
the length of 1.

This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
out of bounds when parsing TCP options.").

v2 changes:

Added an early return when length < 0 to avoid calling
skb_header_pointer with negative length.

Cc: Young Xiao <92siuyang@gmail.com>
Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 4bb4cfde28b4..c6c0d27caaed 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -31,6 +31,9 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 	int length = (th->doff * 4) - sizeof(*th);
 	u8 buf[40], *ptr;
 
+	if (unlikely(length < 0))
+		return false;
+
 	ptr = skb_header_pointer(skb, doff + sizeof(*th), length, buf);
 	if (ptr == NULL)
 		return false;
@@ -47,6 +50,8 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return true;
 			opsize = *ptr++;
 			if (opsize < 2)
 				return true;
-- 
2.30.2



