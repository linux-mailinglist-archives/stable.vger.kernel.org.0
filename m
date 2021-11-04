Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA0F444DE9
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 05:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhKDE2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 00:28:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59350 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhKDE2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 00:28:07 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7BA521F782;
        Thu,  4 Nov 2021 04:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635999928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yntzhDNIJrkZKWGzY5nRMMPO6e41UbyPYEXGXhOKLqY=;
        b=URZCXGAqp/tkaOz9zrdP0Jh2crQFHTBqi0DRxG0ePuDRt3IkDhjnflJanRtmavZrL7Yic3
        4c/3AMqY82ASkjxUkDiRI1bnXp7lnkSvW58kJtspWAbR0NeksUbnypPD2X9PbeUH85EJnb
        p9WF3ApdgryUm22L4j5IXkytqFqWpfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635999928;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yntzhDNIJrkZKWGzY5nRMMPO6e41UbyPYEXGXhOKLqY=;
        b=CD4hIV85y16wNABlLj4KuB3EpZ+qWavoRNGnKdahVA3hRqnHZ7qVzkD/j59pCim2fPh7LK
        x0TwkbVgBdaLDwAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1941513DA3;
        Thu,  4 Nov 2021 04:25:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7JdINbZgg2FrUQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 04 Nov 2021 04:25:26 +0000
Message-ID: <9e23e103-40ff-963f-739f-730da4d5fe3f@suse.de>
Date:   Thu, 4 Nov 2021 12:25:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, stable@vger.kernel.org
References: <20211103151041.70516-1-colyli@suse.de>
 <20211103154644.GA30686@lst.de>
 <1d1180e0-32bc-e571-3252-ce496508d2b5@suse.de> <20211103161955.GA394@lst.de>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211103161955.GA394@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 12:19 AM, Christoph Hellwig wrote:
> On Thu, Nov 04, 2021 at 12:11:45AM +0800, Coly Li wrote:
>>> fresh page for each vec, and bio_for_each_segment_all iterates page
>>> by page.  IFF there is an offset there is proble in the surrounding
>>> code as bch_bio_alloc_pages assumes that it is called on a freshly
>>> allocate and initialized bio.
>> Yes, the offset is modified in bch_bio_alloc_pages().
> Where?   In my upstream copy of bch_bio_alloc_pages there is no bv_offset
> manipulation, and I could not see how such a manipulation would make
> sense.

Forgive my typo. It was bch_bio_map() before bch_bio_alloc_pages(), both 
in do_btree_node_write() and in util.c, bv->bv_offset is set by,
     bv->bv_offset = base ? offset_in_page(base) : 0;

Here base is bset *i which is initialized in do_btree_node_write() as,
     struct bset *i = btree_bset_last(b);

The unit size of bset is 1 bcache-defined-block size, minimized value is 
512.

>> Normally the bcache
>> defined block size is 4KB so the issue was not triggered frequently. I
>> found it during testing my nvdimm enabling code for bcache, where I happen
>> to make the bcache defined block size to non-4KB. The offset is from the
>> previous written bkey set, which the minimized unit size is 1
>> bcache-defined-block-size.
> So you have some out of tree changes here?  Copying a PAGE_SIZE into
> a 'segment' bvec just does not make any sense if there is an offset,
> as segments are defined as bvecs that do not span page boundaries.
>
> I suspect the best thing to do in do_btree_node_write would be something
> like the patch below instead of poking into the internals here, but I'd
> also really like to understand the root cause as it does point to a bug
> somewhere else.
>
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 93b67b8d31c3d..f69914848f32f 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -378,8 +378,8 @@ static void do_btree_node_write(struct btree *b)
>   		struct bvec_iter_all iter_all;
>   
>   		bio_for_each_segment_all(bv, b->bio, iter_all) {
> -			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
> -			addr += PAGE_SIZE;
> +			memcpy_to_bvec(bvec_virt(bv), addr);
> +			addr += bv->bv_len;
>   		}
>   
>   		bch_submit_bbio(b->bio, b->c, &k.key, 0);

The above change doesn't work, still observe panic[1].

Before calling bio_for_each_segment_all(), void *addr is calculated by,
     void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
which is a page size aligned address.  When writing down a dirty btree 
node, it requires whole page to be written. Your original patch works 
fine when there is not previously unwirtten keys in the page as previous 
bkey set (and corrupts memory when bv->bv_offset is non-zero). The above 
change seems missing the part in offset [0, bv->bv_offset] inside the 
dirty page, I am not sure how the bellowed panic happens by the above 
change, it seems like wild pointer from the missing part of btree node 
when iterating the btree.

If you don't want to directly access members inside struct bio_vec, is 
there something like page_base(vb) which returns bv->bv_page ?

Thanks.

Coly Li



[1] the panic message starts like,

[ 1926.350362] ------------[ cut here ]------------
[ 1926.405603] kernel BUG at ./include/linux/highmem.h:316!
[ 1926.469172] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
[ 1926.540006] CPU: 10 PID: 477 Comm: kworker/10:2 Kdump: loaded 
Tainted: G            E     5.15.0-59.27-default+ #57
[ 1926.350362 1926.540009] Hardware name: Lenovo ThinkSystem SR650 
-[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE164L-2.80]- 10/23/2020
[ 1926.540010] Workqueue: bcache bch_data_insert_keys [bcache]
[ 1926.806482] RIP: 0010:__bch_btree_node_write+0x662/0x690 [bcache]
<snipped>
