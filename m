Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EE13C4726
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbhGLGbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236951AbhGLGa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6968560234;
        Mon, 12 Jul 2021 06:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071260;
        bh=q/WSWvDxY9O4dTACy3WW7pDQ7RvU77ls+OLvBCZx1Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYVPYSC3TOHOG8JYr0QZV2xUUPIU8QdDW9tXs/8ikyMGYEcCR5AqNoNE1cPcdIknV
         TuFbFxEWikKXA78jnyJoV6FOZEpbqY3KNBk4nlUCstTSSyKdZVP3Xl4MofpAYhYXg7
         uMkR6iVetvbd+MrtfqYCimm558gUap2naDpzh/hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 341/348] mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
Date:   Mon, 12 Jul 2021 08:12:05 +0200
Message-Id: <20210712060749.333088031@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 6d3d3f698ebb..e97143713021 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -839,6 +839,7 @@ static void z3fold_destroy_pool(struct z3fold_pool *pool)
 	destroy_workqueue(pool->compact_wq);
 	destroy_workqueue(pool->release_wq);
 	z3fold_unregister_migration(pool);
+	free_percpu(pool->unbuddied);
 	kfree(pool);
 }
 
-- 
2.30.2



