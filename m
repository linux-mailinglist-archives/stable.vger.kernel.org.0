Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1823123EA8
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 05:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfLREvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 23:51:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfLREvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 23:51:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5373921582;
        Wed, 18 Dec 2019 04:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576644713;
        bh=Vl2hyvtu7Iviw5OO/kfGHA1hcWxfcadVdsZrNSk66dE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gSOXi81HNbOMQlPe4599bknzdcu5VEtlFBca3FzYiDWDmwCLD/wNzt7PV28XUkKQg
         vsYS5Zj9XCU2Y17aYEDhG8tjTvg05LKAzEMp37x55IZK3YjFQOZ5/0HzMRBEtmgZdb
         s9S9DWaYqePecyFg3Shsb6cALxxsZo1Cgjl4P2dU=
Date:   Tue, 17 Dec 2019 20:51:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 5/6] mm: vmscan: protect shrinker idr replace with
 CONFIG_MEMCG
Message-ID: <20191218045152.iNg-dg4P2%akpm@linux-foundation.org>
In-Reply-To: <20191217205020.6e2eaefc78710ec646e99aa9@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmscan: protect shrinker idr replace with CONFIG_MEMCG

Since commit 0a432dcbeb32edc ("mm: shrinker: make shrinker not depend on
memcg kmem"), shrinkers' idr is protected by CONFIG_MEMCG instead of
CONFIG_MEMCG_KMEM, so it makes no sense to protect shrinker idr replace
with CONFIG_MEMCG_KMEM.

And in the CONFIG_MEMCG && CONFIG_SLOB case, shrinker_idr contains only
shrinker, and it is deferred_split_shrinker.  But it is never actually
called, since idr_replace() is never compiled due to the wrong #ifdef. 
The deferred_split_shrinker all the time is staying in half-registered
state, and it's never called for subordinate mem cgroups.

Link: http://lkml.kernel.org/r/1575486978-45249-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-protect-shrinker-idr-replace-with-config_memcg
+++ a/mm/vmscan.c
@@ -387,7 +387,7 @@ void register_shrinker_prepared(struct s
 {
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		idr_replace(&shrinker_idr, shrinker, shrinker->id);
 #endif
_
