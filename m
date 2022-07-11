Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128AC56FA3C
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiGKJPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiGKJO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CB433E3E;
        Mon, 11 Jul 2022 02:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 940046118F;
        Mon, 11 Jul 2022 09:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC3DC34115;
        Mon, 11 Jul 2022 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530622;
        bh=zp3JffDA6rZtfMFo04/+4E4M7pjTJoUkbaSDYbzk3MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRR6PJeQxHP+Osvhi1eOsReGunngrK6Bug4YiP0/AfzUuf8S+dm6KIFhho3ujcGyi
         WfTQxTTMgYcyt3dVFeVxAbD6gDnGstp+ohZtPBpLMm4PMAHxABaaQEL5YMCfzoAQ1s
         YE3EkNH2KtykUEoQ4LfTxDXUpNZUMFTl4TzEDgPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.4 02/38] mm/slub: add missing TID updates on slab deactivation
Date:   Mon, 11 Jul 2022 11:06:44 +0200
Message-Id: <20220711090538.798574175@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit eeaa345e128515135ccb864c04482180c08e3259 upstream.

The fastpath in slab_alloc_node() assumes that c->slab is stable as long as
the TID stays the same. However, two places in __slab_alloc() currently
don't update the TID when deactivating the CPU slab.

If multiple operations race the right way, this could lead to an object
getting lost; or, in an even more unlikely situation, it could even lead to
an object being freed onto the wrong slab's freelist, messing up the
`inuse` counter and eventually causing a page to be freed to the page
allocator while it still contains slab objects.

(I haven't actually tested these cases though, this is just based on
looking at the code. Writing testcases for this stuff seems like it'd be
a pain...)

The race leading to state inconsistency is (all operations on the same CPU
and kmem_cache):

 - task A: begin do_slab_free():
    - read TID
    - read pcpu freelist (==NULL)
    - check `slab == c->slab` (true)
 - [PREEMPT A->B]
 - task B: begin slab_alloc_node():
    - fastpath fails (`c->freelist` is NULL)
    - enter __slab_alloc()
    - slub_get_cpu_ptr() (disables preemption)
    - enter ___slab_alloc()
    - take local_lock_irqsave()
    - read c->freelist as NULL
    - get_freelist() returns NULL
    - write `c->slab = NULL`
    - drop local_unlock_irqrestore()
    - goto new_slab
    - slub_percpu_partial() is NULL
    - get_partial() returns NULL
    - slub_put_cpu_ptr() (enables preemption)
 - [PREEMPT B->A]
 - task A: finish do_slab_free():
    - this_cpu_cmpxchg_double() succeeds()
    - [CORRUPT STATE: c->slab==NULL, c->freelist!=NULL]

>From there, the object on c->freelist will get lost if task B is allowed to
continue from here: It will proceed to the retry_load_slab label,
set c->slab, then jump to load_freelist, which clobbers c->freelist.

But if we instead continue as follows, we get worse corruption:

 - task A: run __slab_free() on object from other struct slab:
    - CPU_PARTIAL_FREE case (slab was on no list, is now on pcpu partial)
 - task A: run slab_alloc_node() with NUMA node constraint:
    - fastpath fails (c->slab is NULL)
    - call __slab_alloc()
    - slub_get_cpu_ptr() (disables preemption)
    - enter ___slab_alloc()
    - c->slab is NULL: goto new_slab
    - slub_percpu_partial() is non-NULL
    - set c->slab to slub_percpu_partial(c)
    - [CORRUPT STATE: c->slab points to slab-1, c->freelist has objects
      from slab-2]
    - goto redo
    - node_match() fails
    - goto deactivate_slab
    - existing c->freelist is passed into deactivate_slab()
    - inuse count of slab-1 is decremented to account for object from
      slab-2

At this point, the inuse count of slab-1 is 1 lower than it should be.
This means that if we free all allocated objects in slab-1 except for one,
SLUB will think that slab-1 is completely unused, and may free its page,
leading to use-after-free.

Fixes: c17dda40a6a4e ("slub: Separate out kmem_cache_cpu processing from deactivate_slab")
Fixes: 03e404af26dc2 ("slub: fast release on full slab")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/r/20220608182205.2945720-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2214,6 +2214,7 @@ redo:
 
 	c->page = NULL;
 	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
 }
 
 /*
@@ -2347,8 +2348,6 @@ static inline void flush_slab(struct kme
 {
 	stat(s, CPUSLAB_FLUSH);
 	deactivate_slab(s, c->page, c->freelist, c);
-
-	c->tid = next_tid(c->tid);
 }
 
 /*
@@ -2632,6 +2631,7 @@ redo:
 
 	if (!freelist) {
 		c->page = NULL;
+		c->tid = next_tid(c->tid);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}


