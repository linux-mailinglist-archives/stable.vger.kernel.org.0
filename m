Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B44269B542
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 23:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBQWHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 17:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBQWHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 17:07:05 -0500
X-Greylist: delayed 574 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Feb 2023 14:07:03 PST
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAED85F252;
        Fri, 17 Feb 2023 14:07:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 6DBAB85;
        Fri, 17 Feb 2023 13:57:29 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id A70dd8PC0tM6; Fri, 17 Feb 2023 13:57:28 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 655B346;
        Fri, 17 Feb 2023 13:57:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 655B346
Date:   Fri, 17 Feb 2023 13:57:28 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Zheng Wang <zyytlz.wz@163.com>
cc:     colyli@suse.de, hackerzheng666@gmail.com,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex000young@gmail.com,
        stable@vger.kernel.org
Subject: Re: [RESEBD PATCH v3] bcache: Remove some unnecessary NULL point
 check for the return value of __bch_btree_node_alloc-related pointer
In-Reply-To: <20230217100901.707245-1-zyytlz.wz@163.com>
Message-ID: <62507028-c27d-82b8-2db2-5642e2388e3e@ewheeler.net>
References: <20230217100901.707245-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Feb 2023, Zheng Wang wrote:

> Due to the previously fix of __bch_btree_node_alloc, the return value will
> never be a NULL pointer. So IS_ERR is enough to handle the failure
>  situation. Fix it by replacing IS_ERR_OR_NULL check to IS_ERR check.
> 
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
> v3:
> - Add Cc: stable@vger.kernel.org suggested by Eric

Make sure that the commit
	bcache: Fix __bch_btree_node_alloc to make the failure behavior consistent
is committed _before_ this "Remove some unnecessary NULL point check..." 
patch.

It would be a good idea to add "this patch depends on `bcache: Fix 
__bch_btree_node_alloc to make the failure behavior consistent`" to the 
commit message so the stable maintainers know.

-Eric

> v2:
> - Replace more checks
> ---
>  drivers/md/bcache/btree.c | 10 +++++-----
>  drivers/md/bcache/super.c |  4 ++--
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..7c21e54468bf 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1138,7 +1138,7 @@ static struct btree *btree_node_alloc_replacement(struct btree *b,
>  {
>  	struct btree *n = bch_btree_node_alloc(b->c, op, b->level, b->parent);
>  
> -	if (!IS_ERR_OR_NULL(n)) {
> +	if (!IS_ERR(n)) {
>  		mutex_lock(&n->write_lock);
>  		bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
>  		bkey_copy_key(&n->key, &b->key);
> @@ -1340,7 +1340,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
>  	memset(new_nodes, 0, sizeof(new_nodes));
>  	closure_init_stack(&cl);
>  
> -	while (nodes < GC_MERGE_NODES && !IS_ERR_OR_NULL(r[nodes].b))
> +	while (nodes < GC_MERGE_NODES && !IS_ERR(r[nodes].b))
>  		keys += r[nodes++].keys;
>  
>  	blocks = btree_default_blocks(b->c) * 2 / 3;
> @@ -1352,7 +1352,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
>  
>  	for (i = 0; i < nodes; i++) {
>  		new_nodes[i] = btree_node_alloc_replacement(r[i].b, NULL);
> -		if (IS_ERR_OR_NULL(new_nodes[i]))
> +		if (IS_ERR(new_nodes[i]))
>  			goto out_nocoalesce;
>  	}
>  
> @@ -1487,7 +1487,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
>  	bch_keylist_free(&keylist);
>  
>  	for (i = 0; i < nodes; i++)
> -		if (!IS_ERR_OR_NULL(new_nodes[i])) {
> +		if (!IS_ERR(new_nodes[i])) {
>  			btree_node_free(new_nodes[i]);
>  			rw_unlock(true, new_nodes[i]);
>  		}
> @@ -1669,7 +1669,7 @@ static int bch_btree_gc_root(struct btree *b, struct btree_op *op,
>  	if (should_rewrite) {
>  		n = btree_node_alloc_replacement(b, NULL);
>  
> -		if (!IS_ERR_OR_NULL(n)) {
> +		if (!IS_ERR(n)) {
>  			bch_btree_node_write_sync(n);
>  
>  			bch_btree_set_root(n);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..7660962e7b8b 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1724,7 +1724,7 @@ static void cache_set_flush(struct closure *cl)
>  	if (!IS_ERR_OR_NULL(c->gc_thread))
>  		kthread_stop(c->gc_thread);
>  
> -	if (!IS_ERR_OR_NULL(c->root))
> +	if (!IS_ERR(c->root))
>  		list_add(&c->root->list, &c->btree_cache);
>  
>  	/*
> @@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
>  
>  		err = "cannot allocate new btree root";
>  		c->root = __bch_btree_node_alloc(c, NULL, 0, true, NULL);
> -		if (IS_ERR_OR_NULL(c->root))
> +		if (IS_ERR(c->root))
>  			goto err;
>  
>  		mutex_lock(&c->root->write_lock);
> -- 
> 2.25.1
> 
> 
