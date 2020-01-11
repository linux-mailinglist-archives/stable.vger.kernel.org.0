Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53EC137D9E
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgAKJ7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgAKJ7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:59:38 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5648D2084D;
        Sat, 11 Jan 2020 09:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736777;
        bh=V+O5gXI50UZr9RiSdJTgPSb6wN43+H/8XMVH3x8sdWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRVMtXJV3OA7FmIhvZq21OPW7DZx4zF4Pz9aVLY41eknF8QZ3DLjtM6kzhfdcFX22
         2e0a3xldr6RJPfJACC+SapUMMl5MXdE7mb9az/wESAiiYt477pV90Omouc44/HE8iW
         XnI2qBcbWAghBDbZYRozFdrun55z8QvPj55gd2fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 22/91] memcg: account security cred as well to kmemcg
Date:   Sat, 11 Jan 2020 10:49:15 +0100
Message-Id: <20200111094852.213118498@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
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
@@ -219,7 +219,7 @@ struct cred *cred_alloc_blank(void)
 	new->magic = CRED_MAGIC;
 #endif
 
-	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
+	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
 	return new;
@@ -278,7 +278,7 @@ struct cred *prepare_creds(void)
 	new->security = NULL;
 #endif
 
-	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 	validate_creds(new);
 	return new;
@@ -653,7 +653,7 @@ struct cred *prepare_kernel_cred(struct
 #ifdef CONFIG_SECURITY
 	new->security = NULL;
 #endif
-	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
 	put_cred(old);


