Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBCC52DFEE
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 00:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbiESWTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 18:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiESWTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 18:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE99C5E768;
        Thu, 19 May 2022 15:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50505B828A9;
        Thu, 19 May 2022 22:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7977CC385AA;
        Thu, 19 May 2022 22:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652998757;
        bh=2I0wd8HhhuccExX6+ugj3cvtFBvuUnCOW+Jwa8lFwUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THJTwGjnkK8tRiRJQt0xzHtF96C0rdejta7QSuDRW0o9QurZVT887Kq8AzCrnIm1X
         wDk9IckjzOMJ1nEoTAOkXKvcZCmmTMSQ1AAB927Qp+jU9f0WxJvebL8Tk4pc61/ssG
         OVx4QCQpI5KqgQqqxDyCS9qQGy9WNqc9L3epobOLyFKqiCI/4cqVD7cBVUgAzFK0fW
         rSPiU8q7ny8/3LttZlL0cVCvxEdYn65/NzYGw8DXN2eAf46o7a1VBaBm1Q9oVJkg67
         kRubn5anOtLVGCoZK9TwhQcxmoJeJTU23ZDDtzmuTAwjnl+iCE/JSnqcGwuXHval67
         YvKvsqo8MxOTg==
Date:   Fri, 20 May 2022 01:17:38 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, stable@vger.kernel.org,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] assoc_array: Fix BUG_ON during garbage collect
Message-ID: <YobCAnG2MwtZ5Jz3@iki.fi>
References: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 09:50:30AM +0100, David Howells wrote:
> From: Stephen Brennan <stephen.s.brennan@oracle.com>
> 
> A rare BUG_ON triggered in assoc_array_gc:
> 
>     [3430308.818153] kernel BUG at lib/assoc_array.c:1609!
> 
> Which corresponded to the statement currently at line 1593 upstream:
> 
>     BUG_ON(assoc_array_ptr_is_meta(p));
> 
> Using the data from the core dump, I was able to generate a userspace
> reproducer[1] and determine the cause of the bug.
> 
> [1]: https://github.com/brenns10/kernel_stuff/tree/master/assoc_array_gc
> 
> After running the iterator on the entire branch, an internal tree node
> looked like the following:
> 
>     NODE (nr_leaves_on_branch: 3)
>       SLOT [0] NODE (2 leaves)
>       SLOT [1] NODE (1 leaf)
>       SLOT [2..f] NODE (empty)
> 
> In the userspace reproducer, the pr_devel output when compressing this
> node was:
> 
>     -- compress node 0x5607cc089380 --
>     free=0, leaves=0
>     [0] retain node 2/1 [nx 0]
>     [1] fold node 1/1 [nx 0]
>     [2] fold node 0/1 [nx 2]
>     [3] fold node 0/2 [nx 2]
>     [4] fold node 0/3 [nx 2]
>     [5] fold node 0/4 [nx 2]
>     [6] fold node 0/5 [nx 2]
>     [7] fold node 0/6 [nx 2]
>     [8] fold node 0/7 [nx 2]
>     [9] fold node 0/8 [nx 2]
>     [10] fold node 0/9 [nx 2]
>     [11] fold node 0/10 [nx 2]
>     [12] fold node 0/11 [nx 2]
>     [13] fold node 0/12 [nx 2]
>     [14] fold node 0/13 [nx 2]
>     [15] fold node 0/14 [nx 2]
>     after: 3
> 
> At slot 0, an internal node with 2 leaves could not be folded into the
> node, because there was only one available slot (slot 0). Thus, the
> internal node was retained. At slot 1, the node had one leaf, and was
> able to be folded in successfully. The remaining nodes had no leaves,
> and so were removed. By the end of the compression stage, there were 14
> free slots, and only 3 leaf nodes. The tree was ascended and then its
> parent node was compressed. When this node was seen, it could not be
> folded, due to the internal node it contained.
> 
> The invariant for compression in this function is: whenever
> nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT, the node should contain all
> leaf nodes. The compression step currently cannot guarantee this, given
> the corner case shown above.
> 
> To fix this issue, retry compression whenever we have retained a node,
> and yet nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT. This second
> compression will then allow the node in slot 1 to be folded in,
> satisfying the invariant. Below is the output of the reproducer once the
> fix is applied:
> 
>     -- compress node 0x560e9c562380 --
>     free=0, leaves=0
>     [0] retain node 2/1 [nx 0]
>     [1] fold node 1/1 [nx 0]
>     [2] fold node 0/1 [nx 2]
>     [3] fold node 0/2 [nx 2]
>     [4] fold node 0/3 [nx 2]
>     [5] fold node 0/4 [nx 2]
>     [6] fold node 0/5 [nx 2]
>     [7] fold node 0/6 [nx 2]
>     [8] fold node 0/7 [nx 2]
>     [9] fold node 0/8 [nx 2]
>     [10] fold node 0/9 [nx 2]
>     [11] fold node 0/10 [nx 2]
>     [12] fold node 0/11 [nx 2]
>     [13] fold node 0/12 [nx 2]
>     [14] fold node 0/13 [nx 2]
>     [15] fold node 0/14 [nx 2]
>     internal nodes remain despite enough space, retrying
>     -- compress node 0x560e9c562380 --
>     free=14, leaves=1
>     [0] fold node 2/15 [nx 0]
>     after: 3
> 
> Changes
> =======
> DH:
>  - Use false instead of 0.
>  - Reorder the inserted lines in a couple of places to put retained before
>    next_slot.
> 
> ver #2)
>  - Fix typo in pr_devel, correct comparison to "<="
> 
> 
> Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jarkko Sakkinen <jarkko@kernel.org>
> cc: Andrew Morton <akpm@linux-foundation.org>
> cc: keyrings@vger.kernel.org
> Link: https://lore.kernel.org/r/20220511225517.407935-1-stephen.s.brennan@oracle.com/ # v1
> Link: https://lore.kernel.org/r/20220512215045.489140-1-stephen.s.brennan@oracle.com/ # v2
> ---
> 
>  lib/assoc_array.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/lib/assoc_array.c b/lib/assoc_array.c
> index 079c72e26493..ca0b4f360c1a 100644
> --- a/lib/assoc_array.c
> +++ b/lib/assoc_array.c
> @@ -1461,6 +1461,7 @@ int assoc_array_gc(struct assoc_array *array,
>  	struct assoc_array_ptr *cursor, *ptr;
>  	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
>  	unsigned long nr_leaves_on_tree;
> +	bool retained;
>  	int keylen, slot, nr_free, next_slot, i;
>  
>  	pr_devel("-->%s()\n", __func__);
> @@ -1536,6 +1537,7 @@ int assoc_array_gc(struct assoc_array *array,
>  		goto descend;
>  	}
>  
> +retry_compress:
>  	pr_devel("-- compress node %p --\n", new_n);
>  
>  	/* Count up the number of empty slots in this node and work out the
> @@ -1553,6 +1555,7 @@ int assoc_array_gc(struct assoc_array *array,
>  	pr_devel("free=%d, leaves=%lu\n", nr_free, new_n->nr_leaves_on_branch);
>  
>  	/* See what we can fold in */
> +	retained = false;
>  	next_slot = 0;
>  	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
>  		struct assoc_array_shortcut *s;
> @@ -1602,9 +1605,14 @@ int assoc_array_gc(struct assoc_array *array,
>  			pr_devel("[%d] retain node %lu/%d [nx %d]\n",
>  				 slot, child->nr_leaves_on_branch, nr_free + 1,
>  				 next_slot);
> +			retained = true;
>  		}
>  	}
>  
> +	if (retained && new_n->nr_leaves_on_branch <= ASSOC_ARRAY_FAN_OUT) {
> +		pr_devel("internal nodes remain despite enough space, retrying\n");
> +		goto retry_compress;
> +	}
>  	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
>  
>  	nr_leaves_on_tree = new_n->nr_leaves_on_branch;
> 
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
