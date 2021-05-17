Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03F338345B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242646AbhEQPHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241487AbhEQPFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:05:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 959C561C18;
        Mon, 17 May 2021 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261735;
        bh=OI7SHoj/96q6FNR/T7I7IjueoZjTzmwUd7kx/d4GQSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSi8OLnq7NYWaW2M89XihETdrShW4S7oTCRoYPfXMvdZ/k/xKrfOAwhkRHheqNd2T
         O691Od4McTkpa9EXwLpYbNwsE9dFlVV58HcajdQkezWdu9whYava2Fxtq7zlciOKWl
         sr0S40r+h1BbgW6t/GxowYSBjV3OWQ7T6mpeQJ3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/141] ksm: fix potential missing rmap_item for stable_node
Date:   Mon, 17 May 2021 16:02:15 +0200
Message-Id: <20210517140245.570336284@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit c89a384e2551c692a9fe60d093fd7080f50afc51 ]

When removing rmap_item from stable tree, STABLE_FLAG of rmap_item is
cleared with head reserved.  So the following scenario might happen: For
ksm page with rmap_item1:

cmp_and_merge_page
  stable_node->head = &migrate_nodes;
  remove_rmap_item_from_tree, but head still equal to stable_node;
  try_to_merge_with_ksm_page failed;
  return;

For the same ksm page with rmap_item2, stable node migration succeed this
time.  The stable_node->head does not equal to migrate_nodes now.  For ksm
page with rmap_item1 again:

cmp_and_merge_page
 stable_node->head != &migrate_nodes && rmap_item->head == stable_node
 return;

We would miss the rmap_item for stable_node and might result in failed
rmap_walk_ksm().  Fix this by set rmap_item->head to NULL when rmap_item
is removed from stable tree.

Link: https://lkml.kernel.org/r/20210330140228.45635-5-linmiaohe@huawei.com
Fixes: 4146d2d673e8 ("ksm: make !merge_across_nodes migration safe")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index e486c54d921b..0bbae78aaaa0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -793,6 +793,7 @@ static void remove_rmap_item_from_tree(struct rmap_item *rmap_item)
 		stable_node->rmap_hlist_len--;
 
 		put_anon_vma(rmap_item->anon_vma);
+		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;
 
 	} else if (rmap_item->address & UNSTABLE_FLAG) {
-- 
2.30.2



