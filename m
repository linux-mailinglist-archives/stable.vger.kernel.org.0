Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E453C55C6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345439AbhGLIL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353922AbhGLIDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A3FF61D1D;
        Mon, 12 Jul 2021 07:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076732;
        bh=KR+G80l4C3aATKw04JHd5ZCD36XtzLSDd9cMnWIVHUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAcqlyvj3BKbWwQXxWix91RVn/Ithfom+7e4i5Y/GOgGCoKuHWoPcTAyjddIvml0P
         FFkkOHANQgmO9G0sE2JAOeELuDrtoJ2DL8QSnttm4XIIIaeX4ILp4WFWEd4RTRlOqr
         NHO6dJokxgSC+q2Uxpn/bbeLUjOv/4kQ8odtgs5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 770/800] mm/z3fold: use release_z3fold_page_locked() to release locked z3fold page
Date:   Mon, 12 Jul 2021 08:13:13 +0200
Message-Id: <20210712061048.749809125@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 33d8487ef6a8..ed0023dc5a3d 100644
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



