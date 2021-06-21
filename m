Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8564F3AEFA2
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhFUQkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232137AbhFUQhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82F8D6108E;
        Mon, 21 Jun 2021 16:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292942;
        bh=qv1stP+xCY8eceU+/jZqPRtnb1Bt/Wv3iFl93CVvVY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLSt5MWJR1V8/BzO1Z9tPN6kpLPa/adTM/yafshdzmvX+JAsGfdg+7JUThCgFNEOM
         vVgZPo9WTNRt57dvUUy7pH6TnsKKU7DKA+8QK0M32G0CeD0FB/MM1Efvz2oEWg1gL0
         DsB0l3OCZM5Q8g6Zr8SOEo8LlPTW8Y8fnCjiIqWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 041/178] netfilter: synproxy: Fix out of bounds when parsing TCP options
Date:   Mon, 21 Jun 2021 18:14:15 +0200
Message-Id: <20210621154923.536748996@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index b100c04a0e43..3d6d49420db8 100644
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



