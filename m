Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E99332853A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbhCAQvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235229AbhCAQn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:43:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A1464EF4;
        Mon,  1 Mar 2021 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616179;
        bh=2FxptM7cAiFt/0R+VBGHvu+JWMDHMGHF4B2JkXn4PiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+Wg43dabIbc59SolqignY+a1cSJlm276CyzTdzdut5A7CngNrmMV44IIE3wKCEB0
         G0Fywp0RlCQA2JajSUvID68WE6Dq3Oo+bZiOmGZcZzL1mgRLQmbHOmCdaxTZtOMREP
         Bljzre9hkAc4Q/wHOY5xWJhwJtZYTcEHxVM3nfIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com,
        syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com,
        Marco Elver <elver@google.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 031/176] bpf_lru_list: Read double-checked variable once without lock
Date:   Mon,  1 Mar 2021 17:11:44 +0100
Message-Id: <20210301161022.522442105@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 6df8fb83301d68ea0a0c0e1cbcc790fcc333ed12 ]

For double-checked locking in bpf_common_lru_push_free(), node->type is
read outside the critical section and then re-checked under the lock.
However, concurrent writes to node->type result in data races.

For example, the following concurrent access was observed by KCSAN:

  write to 0xffff88801521bc22 of 1 bytes by task 10038 on cpu 1:
   __bpf_lru_node_move_in        kernel/bpf/bpf_lru_list.c:91
   __local_list_flush            kernel/bpf/bpf_lru_list.c:298
   ...
  read to 0xffff88801521bc22 of 1 bytes by task 10043 on cpu 0:
   bpf_common_lru_push_free      kernel/bpf/bpf_lru_list.c:507
   bpf_lru_push_free             kernel/bpf/bpf_lru_list.c:555
   ...

Fix the data races where node->type is read outside the critical section
(for double-checked locking) by marking the access with READ_ONCE() as
well as ensuring the variable is only accessed once.

Fixes: 3a08c2fd7634 ("bpf: LRU List")
Reported-by: syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com
Reported-by: syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20210209112701.3341724-1-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lru_list.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
index e6ef4401a1380..9b5eeff72fd37 100644
--- a/kernel/bpf/bpf_lru_list.c
+++ b/kernel/bpf/bpf_lru_list.c
@@ -505,13 +505,14 @@ struct bpf_lru_node *bpf_lru_pop_free(struct bpf_lru *lru, u32 hash)
 static void bpf_common_lru_push_free(struct bpf_lru *lru,
 				     struct bpf_lru_node *node)
 {
+	u8 node_type = READ_ONCE(node->type);
 	unsigned long flags;
 
-	if (WARN_ON_ONCE(node->type == BPF_LRU_LIST_T_FREE) ||
-	    WARN_ON_ONCE(node->type == BPF_LRU_LOCAL_LIST_T_FREE))
+	if (WARN_ON_ONCE(node_type == BPF_LRU_LIST_T_FREE) ||
+	    WARN_ON_ONCE(node_type == BPF_LRU_LOCAL_LIST_T_FREE))
 		return;
 
-	if (node->type == BPF_LRU_LOCAL_LIST_T_PENDING) {
+	if (node_type == BPF_LRU_LOCAL_LIST_T_PENDING) {
 		struct bpf_lru_locallist *loc_l;
 
 		loc_l = per_cpu_ptr(lru->common_lru.local_list, node->cpu);
-- 
2.27.0



