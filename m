Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD4C3216FB
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBVMkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231415AbhBVMjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A8264F0D;
        Mon, 22 Feb 2021 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997487;
        bh=XianCNyb7F1IUz8OjevKtLHFPZQljCtTlQt1TdwJxEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPuUsLLylHI+8n+fqFlpNFwzH+yVkLKSU3b+bISUVRcyhgBhoO0cTLIolK0J6g4jN
         qyHt57aF3GtETh6laoRJA619WkCx9xCSAI4ZJ4y28qG7ecNfKtfP+DIcO1/USso6IA
         Tlh2uZGgJrU87eRwZRvFTv0UVQVVn/0bmbtZQwH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 29/57] bpf: Check for integer overflow when using roundup_pow_of_two()
Date:   Mon, 22 Feb 2021 13:35:55 +0100
Message-Id: <20210222121029.612694240@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 6183f4d3a0a2ad230511987c6c362ca43ec0055f ]

On 32-bit architecture, roundup_pow_of_two() can return 0 when the argument
has upper most bit set due to resulting 1UL << 32. Add a check for this case.

Fixes: d5a3b1f69186 ("bpf: introduce BPF_MAP_TYPE_STACK_TRACE")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210127063653.3576-1-minhquangbui99@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 135be433e9a0f..1d4c3fba0f8cd 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -71,6 +71,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 
 	/* hash table size must be power of 2 */
 	n_buckets = roundup_pow_of_two(attr->max_entries);
+	if (!n_buckets)
+		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
 	if (cost >= U32_MAX - PAGE_SIZE)
-- 
2.27.0



