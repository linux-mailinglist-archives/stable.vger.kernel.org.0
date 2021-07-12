Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088D53C55CD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346501AbhGLIMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353917AbhGLIDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF4E361D1C;
        Mon, 12 Jul 2021 07:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076730;
        bh=cNwHHitf67lPPcYZqtAbIU57gKMp7iDeDDY4ZZNeDfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1M00VZ9px8L4RNB57/nmhdK/s5CxNe2YE/22Qxyy4Nk1P+zQ+F4PwqH3my8rPQapG
         8VuV8Ew1Ig1zB2CvlggOyXOZWQMRemH15HnTqg7AhkyVPGeIfin7RHsMFLJgBMXSV9
         LJL0zGNB5irftHO49JtrFpWZG1gkp3M+apc0RWLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 769/800] mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
Date:   Mon, 12 Jul 2021 08:13:12 +0200
Message-Id: <20210712061048.636992400@linuxfoundation.org>
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

[ Upstream commit dac0d1cfda56472378d330b1b76b9973557a7b1d ]

There is a memory leak in z3fold_destroy_pool() as it forgets to
free_percpu pool->unbuddied.  Call free_percpu for pool->unbuddied to fix
this issue.

Link: https://lkml.kernel.org/r/20210619093151.1492174-6-linmiaohe@huawei.com
Fixes: d30561c56f41 ("z3fold: use per-cpu unbuddied lists")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/z3fold.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index 7fe7adaaad01..33d8487ef6a8 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1059,6 +1059,7 @@ static void z3fold_destroy_pool(struct z3fold_pool *pool)
 	destroy_workqueue(pool->compact_wq);
 	destroy_workqueue(pool->release_wq);
 	z3fold_unregister_migration(pool);
+	free_percpu(pool->unbuddied);
 	kfree(pool);
 }
 
-- 
2.30.2



