Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C133166E39
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 05:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgBUEEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 23:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgBUEEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:31 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BF7C24650;
        Fri, 21 Feb 2020 04:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582257870;
        bh=VeMMDsWOrLkkKKT7pK/6KpxUXKR/ybJy5aCuITWhPfk=;
        h=Date:From:To:Subject:From;
        b=0uHSHy1UyIVh1Uf65a0ERv/C9kS97Q2p2jXS92ZWU86HN08EAS7sa4xb6a4/3LKmZ
         DTDfhsW5/TWcK5nGDrDGf8gCcYQ0yfA+edrr3Vwlwl+wY12/jzWhs/qkdqw5UtdPRS
         Os2Ec1W71hegC1lejKAYbXXdnvaGlp4dvKczUi68=
Date:   Thu, 20 Feb 2020 20:04:30 -0800
From:   akpm@linux-foundation.org
To:     walter-zh.wu@mediatek.com, tglx@linutronix.de,
        stable@vger.kernel.org, matthias.bgg@gmail.com,
        kstewart@linuxfoundation.org, jpoimboe@redhat.com,
        gregkh@linuxfoundation.org, dvyukov@google.com, glider@google.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-mm@kvack.org, torvalds@linux-foundation.org
Subject:  [patch 14/15] lib/stackdepot.c: fix global out-of-bounds in
 stack_slabs
Message-ID: <20200221040430.yhCYr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>
Subject: lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Walter Wu has reported a potential case in which init_stack_slab() is
called after stack_slabs[STACK_ALLOC_MAX_SLABS - 1] has already been
initialized.  In that case init_stack_slab() will overwrite
stack_slabs[STACK_ALLOC_MAX_SLABS], which may result in a memory
corruption.

Link: http://lkml.kernel.org/r/20200218102950.260263-1-glider@google.com
Fixes: cd11016e5f521 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-fix-global-out-of-bounds-in-stack_slabs
+++ a/lib/stackdepot.c
@@ -83,15 +83,19 @@ static bool init_stack_slab(void **preal
 		return true;
 	if (stack_slabs[depot_index] == NULL) {
 		stack_slabs[depot_index] = *prealloc;
+		*prealloc = NULL;
 	} else {
-		stack_slabs[depot_index + 1] = *prealloc;
+		/* If this is the last depot slab, do not touch the next one. */
+		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS) {
+			stack_slabs[depot_index + 1] = *prealloc;
+			*prealloc = NULL;
+		}
 		/*
 		 * This smp_store_release pairs with smp_load_acquire() from
 		 * |next_slab_inited| above and in stack_depot_save().
 		 */
 		smp_store_release(&next_slab_inited, 1);
 	}
-	*prealloc = NULL;
 	return true;
 }
 
_
