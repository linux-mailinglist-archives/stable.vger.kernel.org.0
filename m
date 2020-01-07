Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D11331F4
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgAGVFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbgAGVFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F339208C4;
        Tue,  7 Jan 2020 21:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431145;
        bh=RHOGp9HQeQyoK17jjlwbXxaBDWuYVfp1PcCIQL9KW2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vCI+9ISt0OkFf4fKU8yR4sT7yolPDtsdA6SJCdRhIJ6v4wh4/X/vrX3dazS5iOG2
         hDC1H1vBJJK2DzSavy3U6pvBB0YNXzsocgmHqzTcNDhongjtl1jE57KuedrL9wQIXr
         IqQ66eEqFKWIVxhNHdm8YYJAuuNc8N/KKDLgSojg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 053/115] memcg: account security cred as well to kmemcg
Date:   Tue,  7 Jan 2020 21:54:23 +0100
Message-Id: <20200107205302.692285245@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit 84029fd04c201a4c7e0b07ba262664900f47c6f5 upstream.

The cred_jar kmem_cache is already memcg accounted in the current kernel
but cred->security is not.  Account cred->security to kmemcg.

Recently we saw high root slab usage on our production and on further
inspection, we found a buggy application leaking processes.  Though that
buggy application was contained within its memcg but we observe much
more system memory overhead, couple of GiBs, during that period.  This
overhead can adversely impact the isolation on the system.

One source of high overhead we found was cred->security objects, which
have a lifetime of at least the life of the process which allocated
them.

Link: http://lkml.kernel.org/r/20191205223721.40034-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cred.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -220,7 +220,7 @@ struct cred *cred_alloc_blank(void)
 	new->magic = CRED_MAGIC;
 #endif
 
-	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
+	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
 	return new;
@@ -279,7 +279,7 @@ struct cred *prepare_creds(void)
 	new->security = NULL;
 #endif
 
-	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 	validate_creds(new);
 	return new;
@@ -654,7 +654,7 @@ struct cred *prepare_kernel_cred(struct
 #ifdef CONFIG_SECURITY
 	new->security = NULL;
 #endif
-	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
 	put_cred(old);


