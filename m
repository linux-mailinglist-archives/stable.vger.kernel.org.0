Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A843831BD10
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhBOPjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhBOPhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00A9964E2B;
        Mon, 15 Feb 2021 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403175;
        bh=EfpinbcHLPPvDJOkQagkohqGBIe9x5GA2yQAJgFeMq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0Cqf4dKN6Y9GTYJZsulAwnseYjlYNeBIgBt5RyRPgQ8OrH+eAd6XjDRcGlsi9D5k
         7z/MQj4DM/gMdix4Oo1iU4Hhp7oIuML2Qm7nvOWbjKE2Q2FmwDwfg0WwbNN9kEHmb/
         Rvzviamr5w3+yGbibqKS0J+MDdJb8GHJTdo7xQLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/104] bpf: Check for integer overflow when using roundup_pow_of_two()
Date:   Mon, 15 Feb 2021 16:27:09 +0100
Message-Id: <20210215152721.291084523@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
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
index 06065fa271241..6e83bf8c080db 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -116,6 +116,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 
 	/* hash table size must be power of 2 */
 	n_buckets = roundup_pow_of_two(attr->max_entries);
+	if (!n_buckets)
+		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
 	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
-- 
2.27.0



