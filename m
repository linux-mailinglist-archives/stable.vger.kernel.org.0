Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B8B5A9FD3
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 21:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiIATWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 15:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbiIATWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 15:22:42 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F9E79ECB
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 12:22:40 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso1938132wmh.5
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 12:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=PApicBa6D9vyX3ADglW+83E7jZv28yFl5iAN5FkAoBk=;
        b=fjP7QbGpcXghQ+r4YnDSRbDpNITGNypUfHMYn0uhZKsQKZeZk/tBYcwZ9t0q/276nS
         g7pT5Cd1WdZzUMtZOerxp44e/wTq8q97NRhQmlxUKmWuk4jM8D/TR7h64DrPmTgvsCRu
         or5k/13lVO2o1mow40wQYXuQR97IUXo5Sl91KGfF0v31oMxpXqf8fmM15xXGMgyanRCs
         61ev7YR0n7UKIaG9C9BSvX0OU/mI5YAck/nmzN5Noth7lpXejIWaBIzyjXy5u1Aelz2/
         hOsEJ+Lf8lwF9wZaSulIZlkNXS5DBTy1OtMe4NsSFJHgInnrZ48psGPKYcRO49OUiLrj
         y9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=PApicBa6D9vyX3ADglW+83E7jZv28yFl5iAN5FkAoBk=;
        b=IDrz/aa2Fzia5FtnmfJg8OvC9RTzZgRguHlOT5+0rhal/o1xYTKnFFPXlrfBo6On6h
         OEqrQF5UoUlOqOVkK9rTDg3PraVlYvdaK08+TojP44JNo670T68w3dLZEBpSMfZNKH7T
         DP0bz9kdcgWVBE5Crg8RuCjWUrXZNa1z6ctq/sU5vkBcp24XjrZyLNE4WTim7uXsNkrx
         uajTLplt2i5A52u9KR4NzGQ4sKmhgNQAMxi0ARCMXlvrrkI5C7KrEauJEgkXWlI2M/tA
         XCslcExQxvKjlGrsB3Kk5qGxa5zv8d32x+zRbOYIHk5b0oBKpVamtOKdcX1/MdXirF/T
         8zyw==
X-Gm-Message-State: ACgBeo38KP8Zrwda1Gv4I8e1HBuZ/JZWSXHUPDahkHCeAFHzpYeuvw1R
        eQBKC05T4PsLC4cPGPp+1ViZ3ud9Tc310g==
X-Google-Smtp-Source: AA6agR6mGX0sJpNburmFIRLqOxE08Ly0Fosie2aROladyg6lODeNRT7dPfoJsl5BJOmaNSwQ0/4mcg==
X-Received: by 2002:a1c:3b55:0:b0:3a6:7b62:3901 with SMTP id i82-20020a1c3b55000000b003a67b623901mr382747wma.113.1662060158785;
        Thu, 01 Sep 2022 12:22:38 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:f0f9:964d:23a9:4916])
        by smtp.gmail.com with ESMTPSA id t8-20020adfdc08000000b002258413c310sm15508293wri.88.2022.09.01.12.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 12:22:38 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9] mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse
Date:   Thu,  1 Sep 2022 21:22:30 +0200
Message-Id: <20220901192230.4099716-1-jannh@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2555283eb40df89945557273121e9393ef9b542b upstream.

anon_vma->degree tracks the combined number of child anon_vmas and VMAs
that use the anon_vma as their ->anon_vma.

anon_vma_clone() then assumes that for any anon_vma attached to
src->anon_vma_chain other than src->anon_vma, it is impossible for it to
be a leaf node of the VMA tree, meaning that for such VMAs ->degree is
elevated by 1 because of a child anon_vma, meaning that if ->degree
equals 1 there are no VMAs that use the anon_vma as their ->anon_vma.

This assumption is wrong because the ->degree optimization leads to leaf
nodes being abandoned on anon_vma_clone() - an existing anon_vma is
reused and no new parent-child relationship is created.  So it is
possible to reuse an anon_vma for one VMA while it is still tied to
another VMA.

This is an issue because is_mergeable_anon_vma() and its callers assume
that if two VMAs have the same ->anon_vma, the list of anon_vmas
attached to the VMAs is guaranteed to be the same.  When this assumption
is violated, vma_merge() can merge pages into a VMA that is not attached
to the corresponding anon_vma, leading to dangling page->mapping
pointers that will be dereferenced during rmap walks.

Fix it by separately tracking the number of child anon_vmas and the
number of VMAs using the anon_vma as their ->anon_vma.

Fixes: 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy")
Cc: stable@kernel.org
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[manually fixed up different indentation in stable]
Signed-off-by: Jann Horn <jannh@google.com>
---
 include/linux/rmap.h |  7 +++++--
 mm/rmap.c            | 31 +++++++++++++++++--------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index b46bb5620a76d..9dc3617a5bfce 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -37,12 +37,15 @@ struct anon_vma {
 	atomic_t refcount;
=20
 	/*
-	 * Count of child anon_vmas and VMAs which points to this anon_vma.
+	 * Count of child anon_vmas. Equals to the count of all anon_vmas that
+	 * have ->parent pointing to this one, including itself.
 	 *
 	 * This counter is used for making decision about reusing anon_vma
 	 * instead of forking new one. See comments in function anon_vma_clone.
 	 */
-	unsigned degree;
+	unsigned long num_children;
+	/* Count of VMAs whose ->anon_vma pointer points to this object. */
+	unsigned long num_active_vmas;
=20
 	struct anon_vma *parent;	/* Parent of this anon_vma */
=20
diff --git a/mm/rmap.c b/mm/rmap.c
index 0a5310b76ec85..76064d9649186 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -78,7 +78,8 @@ static inline struct anon_vma *anon_vma_alloc(void)
 	anon_vma =3D kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
 	if (anon_vma) {
 		atomic_set(&anon_vma->refcount, 1);
-		anon_vma->degree =3D 1;	/* Reference for first vma */
+		anon_vma->num_children =3D 0;
+		anon_vma->num_active_vmas =3D 0;
 		anon_vma->parent =3D anon_vma;
 		/*
 		 * Initialise the anon_vma root to point to itself. If called
@@ -187,6 +188,7 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 			anon_vma =3D anon_vma_alloc();
 			if (unlikely(!anon_vma))
 				goto out_enomem_free_avc;
+			anon_vma->num_children++; /* self-parent link for new root */
 			allocated =3D anon_vma;
 		}
=20
@@ -196,8 +198,7 @@ int anon_vma_prepare(struct vm_area_struct *vma)
 		if (likely(!vma->anon_vma)) {
 			vma->anon_vma =3D anon_vma;
 			anon_vma_chain_link(vma, avc, anon_vma);
-			/* vma reference or self-parent link for new root */
-			anon_vma->degree++;
+			anon_vma->num_active_vmas++;
 			allocated =3D NULL;
 			avc =3D NULL;
 		}
@@ -276,19 +277,19 @@ int anon_vma_clone(struct vm_area_struct *dst, struct=
 vm_area_struct *src)
 		anon_vma_chain_link(dst, avc, anon_vma);
=20
 		/*
-		 * Reuse existing anon_vma if its degree lower than two,
-		 * that means it has no vma and only one anon_vma child.
+		 * Reuse existing anon_vma if it has no vma and only one
+		 * anon_vma child.
 		 *
-		 * Do not chose parent anon_vma, otherwise first child
-		 * will always reuse it. Root anon_vma is never reused:
+		 * Root anon_vma is never reused:
 		 * it has self-parent reference and at least one child.
 		 */
-		if (!dst->anon_vma && anon_vma !=3D src->anon_vma &&
-				anon_vma->degree < 2)
+		if (!dst->anon_vma &&
+		    anon_vma->num_children < 2 &&
+		    anon_vma->num_active_vmas =3D=3D 0)
 			dst->anon_vma =3D anon_vma;
 	}
 	if (dst->anon_vma)
-		dst->anon_vma->degree++;
+		dst->anon_vma->num_active_vmas++;
 	unlock_anon_vma_root(root);
 	return 0;
=20
@@ -338,6 +339,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm=
_area_struct *pvma)
 	anon_vma =3D anon_vma_alloc();
 	if (!anon_vma)
 		goto out_error;
+	anon_vma->num_active_vmas++;
 	avc =3D anon_vma_chain_alloc(GFP_KERNEL);
 	if (!avc)
 		goto out_error_free_anon_vma;
@@ -358,7 +360,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm=
_area_struct *pvma)
 	vma->anon_vma =3D anon_vma;
 	anon_vma_lock_write(anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma->parent->degree++;
+	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
=20
 	return 0;
@@ -390,7 +392,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		 * to free them outside the lock.
 		 */
 		if (RB_EMPTY_ROOT(&anon_vma->rb_root)) {
-			anon_vma->parent->degree--;
+			anon_vma->parent->num_children--;
 			continue;
 		}
=20
@@ -398,7 +400,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 	if (vma->anon_vma)
-		vma->anon_vma->degree--;
+		vma->anon_vma->num_active_vmas--;
 	unlock_anon_vma_root(root);
=20
 	/*
@@ -409,7 +411,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma =3D avc->anon_vma;
=20
-		VM_WARN_ON(anon_vma->degree);
+		VM_WARN_ON(anon_vma->num_children);
+		VM_WARN_ON(anon_vma->num_active_vmas);
 		put_anon_vma(anon_vma);
=20
 		list_del(&avc->same_vma);

base-commit: c97531caf70f2b533fa1944bf64dd06ac20edad6
--=20
2.37.2.789.g6183377224-goog

