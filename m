Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5782F53ADC1
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 22:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiFAUqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 16:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiFAUqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 16:46:03 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CA51EE6CD;
        Wed,  1 Jun 2022 13:37:18 -0700 (PDT)
Received: from [192.168.0.175] (ip5f5aeccf.dynamic.kabel-deutschland.de [95.90.236.207])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5C50761EA1929;
        Wed,  1 Jun 2022 21:58:24 +0200 (CEST)
Message-ID: <4895d5a4-f763-a52e-c7f1-ce25f27e4d54@molgen.mpg.de>
Date:   Wed, 1 Jun 2022 21:58:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] block: fix bio_clone_blkg_association() to associate with
 proper blkcg_gq
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Logan Gunthorpe <logang@deltatee.com>, stable@vger.kernel.org
References: <20220601163405.29478-1-jack@suse.cz>
From:   Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <20220601163405.29478-1-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.06.22 18:34, Jan Kara wrote:
> Commit d92c370a16cb ("block: really clone the block cgroup in
> bio_clone_blkg_association") changed bio_clone_blkg_association() to
> just clone bio->bi_blkg reference from source to destination bio. This
> is however wrong if the source and destination bios are against
> different block devices because struct blkcg_gq is different for each
> bdev-blkcg pair. This will result in IOs being accounted (and throttled
> as a result) multiple times against the same device (src bdev) while
> throttling of the other device (dst bdev) is ignored. In case of BFQ the
> inconsistency can even result in crashes in bfq_bic_update_cgroup().
> Fix the problem by looking up correct blkcg_gq for the cloned bio.
> 
> Reported-by: Logan Gunthorpe <logang@deltatee.com>
> Reported-by: Donald Buczek <buczek@molgen.mpg.de>
> Fixes: d92c370a16cb ("block: really clone the block cgroup in bio_clone_blkg_association")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   block/blk-cgroup.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 40161a3f68d0..ecb4eaff6817 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1975,10 +1975,9 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
>   void bio_clone_blkg_association(struct bio *dst, struct bio *src)
>   {
>   	if (src->bi_blkg) {
> -		if (dst->bi_blkg)
> -			blkg_put(dst->bi_blkg);
> -		blkg_get(src->bi_blkg);
> -		dst->bi_blkg = src->bi_blkg;
> +		rcu_read_lock();
> +		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
> +		rcu_read_unlock();
>   	}
>   }
>   EXPORT_SYMBOL_GPL(bio_clone_blkg_association);


Great. Fixed the problem for me. Thanks to you, also to Logan.

Tested-By: Donald Buczek <buczek@molgen.mpg.de>



-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
