Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325893C4B22
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhGLGzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241498AbhGLGzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCA4A60233;
        Mon, 12 Jul 2021 06:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072738;
        bh=CrNiUpvVdssbfpCQSRuDsw6FoeW/iZSxE+l3CEWMafg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlwNWIhE2SwsHJBdQ1Uo0Y9nra9dzDkHrkG0LWHUbMgkI63CuwrPnWbPo2wG9mYwq
         oHA1P09yykoE5yj+dK9WgwzneXbdaqY7I/PFqIoobZR/TCARJjN6ZIz1bhE0NMoffZ
         4jllcsbqJqwpUB0tQgGijYsk2gi5PShhlOLUbVvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 572/593] mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page
Date:   Mon, 12 Jul 2021 08:12:12 +0200
Message-Id: <20210712060957.891281147@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 28473d91ff7f686d58047ff55f2fa98ab59114a4 ]

We should use release_z3fold_page_locked() to release z3fold page when
it's locked, although it looks harmless to use release_z3fold_page() now.

Link: https://lkml.kernel.org/r/20210619093151.1492174-7-linmiaohe@huawei.com
Fixes: dcf5aedb24f8 ("z3fold: stricter locking and more careful reclaim")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/z3fold.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index 636a71c291bf..912ac9a64a15 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1387,7 +1387,7 @@ static int z3fold_reclaim_page(struct z3fold_pool *pool, unsigned int retries)
 			if (zhdr->foreign_handles ||
 			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
 				if (kref_put(&zhdr->refcount,
-						release_z3fold_page))
+						release_z3fold_page_locked))
 					atomic64_dec(&pool->pages_nr);
 				else
 					z3fold_page_unlock(zhdr);
-- 
2.30.2



