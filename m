Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FEC32177D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhBVMtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231641AbhBVMof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A16564F50;
        Mon, 22 Feb 2021 12:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997680;
        bh=C63N+M1LH+aHDrqabny7wZ3zf4eLkZdKVj7jxNqG1yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GetZMnTQS9oee9CNzzqHF4YJORvLaSa+Ze0+q7RBGymjfB7GeNSmlRKuN2RdLl8aV
         FrSP5dYZVkuKKfdNvXwgWn0mgYIyEC1a+AVKqx79dIBIeudItzzfYdPBCiM46JR34u
         o9cI0d7EVxRI/77UoSNmg7j3tl6Z4p6CwnJ6Mlrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/49] bpf: Check for integer overflow when using roundup_pow_of_two()
Date:   Mon, 22 Feb 2021 13:36:22 +0100
Message-Id: <20210222121026.720135690@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
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
index a2a232dec2363..2fdf6f96f9762 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -70,6 +70,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 
 	/* hash table size must be power of 2 */
 	n_buckets = roundup_pow_of_two(attr->max_entries);
+	if (!n_buckets)
+		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
 	if (cost >= U32_MAX - PAGE_SIZE)
-- 
2.27.0



