Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12B44329A7
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 00:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhJRWSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 18:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbhJRWSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 18:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF0AC610FB;
        Mon, 18 Oct 2021 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595360;
        bh=hNMtuF4oGaw8xVzQviaGPI9CVESM1tAI/kQadZH8Dcc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cNZK2mDidHhQe2r1tNf+UflS+bwhPI1cGf56EPv4sFTsBUIgELnrmQIGnEslg96hM
         afgdAuOyPkFago3G9v1CxMsGndA5a/4+v0xD+XD405kyAm4ut8WjXS/N3PnbCL1/qF
         om15o20GwWEsQPznCUjtqCbp5xry8JS34t3kjYj4=
Date:   Mon, 18 Oct 2021 15:15:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bharata@linux.ibm.com, cl@linux.com, faiyazm@codeaurora.org,
        gregkh@linuxfoundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, ryabinin.a.a@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 12/19] mm, slub: fix potential memoryleak in
 kmem_cache_open()
Message-ID: <20211018221559.ulag88CbY%akpm@linux-foundation.org>
In-Reply-To: <20211018151438.f2246e2656c041b6753a8bdd@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix potential memoryleak in kmem_cache_open()

In error path, the random_seq of slub cache might be leaked.  Fix this by
using __kmem_cache_release() to release all the relevant resources.

Link: https://lkml.kernel.org/r/20210916123920.48704-4-linmiaohe@huawei.com
Fixes: 210e7a43fa90 ("mm: SLUB freelist randomization")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-potential-memoryleak-in-kmem_cache_open
+++ a/mm/slub.c
@@ -4210,8 +4210,8 @@ static int kmem_cache_open(struct kmem_c
 	if (alloc_kmem_cache_cpus(s))
 		return 0;
 
-	free_kmem_cache_nodes(s);
 error:
+	__kmem_cache_release(s);
 	return -EINVAL;
 }
 
_
