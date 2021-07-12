Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E463C5049
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344592AbhGLHbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345406AbhGLH3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A657761483;
        Mon, 12 Jul 2021 07:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074761;
        bh=60pKYxyB4DFKFr2vp2XZhwR3mQoqt60znHryeyuKBkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3JRUyiNdFUgQ23XgCjpBtezX6ev7bvWqzUHZQIC4ClP2nOJawrlBDlpknMU1w7dT
         KSZf5dqNSKXAV444GnfJ6ckVgZ5bdiguUzuZEie0Zxu4o/uSct/s5wTJxIJBlDzOf0
         54HxUQAtB3YK44XBgDqSvqJnbsJ7CRkzOivCVCas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 671/700] mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page
Date:   Mon, 12 Jul 2021 08:12:34 +0200
Message-Id: <20210712061047.289209660@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 56a5551f2ba8..7c417fb8404a 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1383,7 +1383,7 @@ static int z3fold_reclaim_page(struct z3fold_pool *pool, unsigned int retries)
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



