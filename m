Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4053C4B1B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239820AbhGLGzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241460AbhGLGzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:55:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37D6D6052B;
        Mon, 12 Jul 2021 06:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072735;
        bh=2n3DZGOxfp4+EEijzFe09B/2zFAHlnQwax+cbtXPboY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9txFVxMzDqTpCaXC3pmEzKSVgB4hYibKyq6HG3pnjCpredhQtKp1fXL0OhIifvLP
         FKAiVhC5msBktRij9xn6Q6s4pIDY/aa4MbiDDnmsYRQelNNWZENm1Yo5qhI42ri8Ia
         PZ38fQPP4kCRPItLOeTQNcF5pclMEWtPLSyjD7vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Hillf Danton <hdanton@sina.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 571/593] mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
Date:   Mon, 12 Jul 2021 08:12:11 +0200
Message-Id: <20210712060957.765679086@linuxfoundation.org>
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
index 8ae944eeb8e2..636a71c291bf 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1063,6 +1063,7 @@ static void z3fold_destroy_pool(struct z3fold_pool *pool)
 	destroy_workqueue(pool->compact_wq);
 	destroy_workqueue(pool->release_wq);
 	z3fold_unregister_migration(pool);
+	free_percpu(pool->unbuddied);
 	kfree(pool);
 }
 
-- 
2.30.2



