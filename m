Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3634CEA4C
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 10:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiCFJiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 04:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiCFJiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 04:38:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4831443E9
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 01:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50791611E1
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 09:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF73C340EC;
        Sun,  6 Mar 2022 09:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646559443;
        bh=eap8gfVvHfZOTEz/2tCUqjdhmul/upUlMdxbIRbUndI=;
        h=Subject:To:Cc:From:Date:From;
        b=e3iDMYpa6sZqAmKckak2BXLbq6WpN/02qNmY382uFxVcfA0uKdAe8pBOl7woAfc1s
         8HjwhFrgQYb3U5RxsMGfZcQfVOMpcKHYoz9Nr3zM2lpUP/OrMv8CStZBp+G8Vr2rlF
         5HIO5kXYApU9EaB4jhWqSjQty8ovq3UEAzhfNzSI=
Subject: FAILED: patch "[PATCH] mm: prevent vm_area_struct::anon_name refcount saturation" failed to apply to 5.16-stable tree
To:     surenb@google.com, akpm@linux-foundation.org, brauner@kernel.org,
        caoxiaofeng@yulong.com, ccross@google.com, chris.hyser@oracle.com,
        dave.hansen@intel.com, dave@stgolabs.net, david@redhat.com,
        ebiederm@xmission.com, gorcunov@gmail.com, hannes@cmpxchg.org,
        keescook@chromium.org, kirill.shutemov@linux.intel.com,
        legion@kernel.org, mhocko@suse.com, pcc@google.com,
        sashal@kernel.org, sumit.semwal@linaro.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Mar 2022 10:37:20 +0100
Message-ID: <164655944021616@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 96403e11283def1d1c465c8279514c9a504d8630 Mon Sep 17 00:00:00 2001
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 4 Mar 2022 20:28:55 -0800
Subject: [PATCH] mm: prevent vm_area_struct::anon_name refcount saturation

A deep process chain with many vmas could grow really high.  With
default sysctl_max_map_count (64k) and default pid_max (32k) the max
number of vmas in the system is 2147450880 and the refcounter has
headroom of 1073774592 before it reaches REFCOUNT_SATURATED
(3221225472).

Therefore it's unlikely that an anonymous name refcounter will overflow
with these defaults.  Currently the max for pid_max is PID_MAX_LIMIT
(4194304) and for sysctl_max_map_count it's INT_MAX (2147483647).  In
this configuration anon_vma_name refcount overflow becomes theoretically
possible (that still require heavy sharing of that anon_vma_name between
processes).

kref refcounting interface used in anon_vma_name structure will detect a
counter overflow when it reaches REFCOUNT_SATURATED value but will only
generate a warning and freeze the ref counter.  This would lead to the
refcounted object never being freed.  A determined attacker could leak
memory like that but it would be rather expensive and inefficient way to
do so.

To ensure anon_vma_name refcount does not overflow, stop anon_vma_name
sharing when the refcount reaches REFCOUNT_MAX (2147483647), which still
leaves INT_MAX/2 (1073741823) values before the counter reaches
REFCOUNT_SATURATED.  This should provide enough headroom for raising the
refcounts temporarily.

Link: https://lkml.kernel.org/r/20220223153613.835563-2-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Chris Hyser <chris.hyser@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xiaofeng Cao <caoxiaofeng@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index dd3accaa4e6d..cf90b1fa2c60 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -161,15 +161,25 @@ static inline void anon_vma_name_put(struct anon_vma_name *anon_name)
 		kref_put(&anon_name->kref, anon_vma_name_free);
 }
 
+static inline
+struct anon_vma_name *anon_vma_name_reuse(struct anon_vma_name *anon_name)
+{
+	/* Prevent anon_name refcount saturation early on */
+	if (kref_read(&anon_name->kref) < REFCOUNT_MAX) {
+		anon_vma_name_get(anon_name);
+		return anon_name;
+
+	}
+	return anon_vma_name_alloc(anon_name->name);
+}
+
 static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
 				     struct vm_area_struct *new_vma)
 {
 	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
 
-	if (anon_name) {
-		anon_vma_name_get(anon_name);
-		new_vma->anon_name = anon_name;
-	}
+	if (anon_name)
+		new_vma->anon_name = anon_vma_name_reuse(anon_name);
 }
 
 static inline void free_anon_vma_name(struct vm_area_struct *vma)
diff --git a/mm/madvise.c b/mm/madvise.c
index 081b1cded21e..1f2693dccf7b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -113,8 +113,7 @@ static int replace_anon_vma_name(struct vm_area_struct *vma,
 	if (anon_vma_name_eq(orig_name, anon_name))
 		return 0;
 
-	anon_vma_name_get(anon_name);
-	vma->anon_name = anon_name;
+	vma->anon_name = anon_vma_name_reuse(anon_name);
 	anon_vma_name_put(orig_name);
 
 	return 0;

