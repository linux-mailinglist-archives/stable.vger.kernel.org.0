Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452464A9325
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 05:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356876AbiBDEth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 23:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238673AbiBDEtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 23:49:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD4AC061714;
        Thu,  3 Feb 2022 20:49:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE1AF61AAC;
        Fri,  4 Feb 2022 04:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68DBC340E9;
        Fri,  4 Feb 2022 04:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643950175;
        bh=D1pLLIbAAt2KQpwLnzj66vfNlI8SvQaQIa3Kfuug6OQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=A7BibzfOSeUAAubSLnLl+QXzJpoD+MDHbV8zSaqItlo+iSlG4uqPhoLhfKprwbqgZ
         fF9HhAFGDdihO/Bs3ie2C330D2R6uNgK9Giqn0QP3CF/MgIABs5TIynEmEUjRHZT+C
         BLnawaTHP+LKN7noty6CD6qkayJG8rhwK3my3MHU=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 20:49:33 -0800
Date:   Thu, 03 Feb 2022 20:49:33 -0800
To:     zealci@zte.com.cn, vvs@virtuozzo.com, unixbhaskar@gmail.com,
        stable@vger.kernel.org, shakeelb@google.com, rdunlap@infradead.org,
        manfred@colorfullife.com, dbueso@suse.de, cgel.zte@gmail.com,
        arnd@arndb.de, chi.minghao@zte.com.cn, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 07/10] ipc/sem: do not sleep with a spin lock held
Message-Id: <20220204044933.C68DBC340E9@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>
Subject: ipc/sem: do not sleep with a spin lock held

We can't call kvfree() with a spin lock held, so defer it.

Link: https://lkml.kernel.org/r/20211223031207.556189-1-chi.minghao@zte.com.cn
Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo allocation")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Yang Guang <cgel.zte@gmail.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/ipc/sem.c~ipc-sem-do-not-sleep-with-a-spin-lock-held
+++ a/ipc/sem.c
@@ -1964,6 +1964,7 @@ static struct sem_undo *find_alloc_undo(
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
+		spin_unlock(&ulp->lock);
 		kvfree(new);
 		goto success;
 	}
@@ -1976,9 +1977,8 @@ static struct sem_undo *find_alloc_undo(
 	ipc_assert_locked_object(&sma->sem_perm);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
-
-success:
 	spin_unlock(&ulp->lock);
+success:
 	sem_unlock(sma, -1);
 out:
 	return un;
_
