Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD211130473
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 21:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgADU7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 15:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgADU7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 15:59:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C05C24650;
        Sat,  4 Jan 2020 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578171583;
        bh=6gG0SfHv9rS1lxpgtj1LQOW+GZX7wbweLqDTAmdHTP4=;
        h=Date:From:To:Subject:From;
        b=N4B43sNB9piA9ZYGyGTL7GUY6wq7pbgKLGU4q30Pq89976BVa7+hdfLvPOOFpzIr5
         x0ua8nEPe7VlclduhUzEbpTD3di9ATOG20vXLtKMAMOdvF42s7jFHt8dzTm/wpC6RG
         ql4+sNyzNEzBSDBf+QZPdYTr7MA+QAsVvX8/C0H0=
Date:   Sat, 04 Jan 2020 12:59:43 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 04/17] memcg: account security cred as well to
 kmemcg
Message-ID: <20200104205943.yjTudiqVx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: account security cred as well to kmemcg

The cred_jar kmem_cache is already memcg accounted in the current kernel
but cred->security is not.  Account cred->security to kmemcg.

Recently we saw high root slab usage on our production and on further
inspection, we found a buggy application leaking processes.  Though
that buggy application was contained within its memcg but we observe
much more system memory overhead, couple of GiBs, during that period. 
This overhead can adversely impact the isolation on the system.  One of
source of high overhead, we found was cred->secuity objects, which have
a lifetime of at least the life of the process which allocated them.

Link: http://lkml.kernel.org/r/20191205223721.40034-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cred.c~memcg-account-security-cred-as-well-to-kmemcg
+++ a/kernel/cred.c
@@ -223,7 +223,7 @@ struct cred *cred_alloc_blank(void)
 	new->magic = CRED_MAGIC;
 #endif
 
-	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
+	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
 	return new;
@@ -282,7 +282,7 @@ struct cred *prepare_creds(void)
 	new->security = NULL;
 #endif
 
-	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 	validate_creds(new);
 	return new;
@@ -715,7 +715,7 @@ struct cred *prepare_kernel_cred(struct
 #ifdef CONFIG_SECURITY
 	new->security = NULL;
 #endif
-	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
 	put_cred(old);
_
