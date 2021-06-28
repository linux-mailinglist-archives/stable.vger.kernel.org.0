Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A713B63C3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhF1PAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233808AbhF1O56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 272D061A2B;
        Mon, 28 Jun 2021 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891225;
        bh=8IYpFhp2hw6L6lFpjgsQqpiAmAnjhtSKowwKh1hIkA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIzW4CJI77LcT9cGoR9W9+cJL9ii+AQxhpwVd5uztFUf3Nq8Hcu9184f3MEU7dpYa
         iKg+R6rYOimZsNpyYo1CmvWDB3x6/bI4tsFs+takLZWGmNpvN800NErMYWC+hF70pH
         VOXV4voblarPb08MknEzRaQ5S5Nc62Ze6a4yqITIS52/7i0BdIP7gkmg9rHKNg4PVL
         ipFDZqpuXfVfQym+lCUBubFS4bn1i9ptjuYxgxmZiS1AxrOucRYMF4+OsnpWDjPeA2
         KJ5ggmbatcdcjZXBqpkOgPQm08G+k+BHn8ZVf+4+MKpszOM+Yafh7Bo40LZQ6h0ldT
         xyRF18Qf1BPXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Young Xiao <92siuyang@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/71] netfilter: synproxy: Fix out of bounds when parsing TCP options
Date:   Mon, 28 Jun 2021 10:39:15 -0400
Message-Id: <20210628144003.34260-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index c8a4a48bced9..8be604eb6961 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -34,6 +34,9 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 	int length = (th->doff * 4) - sizeof(*th);
 	u8 buf[40], *ptr;
 
+	if (unlikely(length < 0))
+		return false;
+
 	ptr = skb_header_pointer(skb, doff + sizeof(*th), length, buf);
 	if (ptr == NULL)
 		return false;
@@ -50,6 +53,8 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
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

