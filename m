Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC16E38A79A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbhETKkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237734AbhETKil (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C02A61C71;
        Thu, 20 May 2021 09:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504499;
        bh=olxwLQKUoh0pv7hlajAdGVNyIeCmb2yMv6GLGAzdL9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXuBviGuzR6qq0xJoczMWa68My7HUW6WZ8Y5gCveYU0jvkpsopt3njgUJdFdLrhzX
         j1+NjCU9Bfxd7xW0KTzDZPYtZWQNkXWC/wuHCZfC/waMV/iIm1fn+5ms3omFsy1eUp
         2YzdDUjRy9GeImorrRYFS9K/u9Pxrchv9XvqIWDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 272/323] ksm: fix potential missing rmap_item for stable_node
Date:   Thu, 20 May 2021 11:22:44 +0200
Message-Id: <20210520092129.548113494@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 65d4bf52f543..6d3bc2723c9b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -768,6 +768,7 @@ static void remove_rmap_item_from_tree(struct rmap_item *rmap_item)
 		stable_node->rmap_hlist_len--;
 
 		put_anon_vma(rmap_item->anon_vma);
+		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;
 
 	} else if (rmap_item->address & UNSTABLE_FLAG) {
-- 
2.30.2



