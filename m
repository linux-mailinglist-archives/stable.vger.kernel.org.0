Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5997687F1F
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 14:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjBBNte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 08:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbjBBNtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 08:49:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56ED74A57;
        Thu,  2 Feb 2023 05:49:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57887B82662;
        Thu,  2 Feb 2023 13:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80400C433EF;
        Thu,  2 Feb 2023 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675345762;
        bh=Tw8qDJmg4j36sCimz8Di5hitk+WZSYw1jDYMfD4y4p0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eYFdkgfhkVfuxLBfzGsj9YjnophMzs2rGrtlP4nP98W7c6M6GZaF5dcymHTHbAB8w
         KH0P4GlYTuYc7WXbug8ndCieWaU0AaCIlDpXvr5lw+cyPj68zkyvYNrZwj/5OvVIeE
         /DsfxVhu8GP3uVg05D0M+xc75f6LrewHUZRA6GoY=
Date:   Thu, 2 Feb 2023 14:49:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     stable@vger.kernel.org, jack@suse.cz, paolo.valente@linaro.org,
        axboe@kernel.dk, linux-block@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 4.19] cfq: fix memory leak for cfqq
Message-ID: <Y9u/XoY2k+zqSrr2@kroah.com>
References: <20230202135850.2415165-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202135850.2415165-1-yukuai1@huaweicloud.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 09:58:50PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> If cfqq is merged with another cfqq(assume that no cfqq is merged to
> this cfqq) and then user thread is moved to another cgroup, then
> check_blkcg_changed() will set cic->cfqq[1] to NULL. However, this cfqq is
> still merged and no one will referece this cfqq, which will cause
> following kmemleak:
> 
> comm "cgexec", pid 2541110, jiffies 4317578508 (age 5728.064s)
> hex dump (first 32 bytes):
> 03 00 00 00 90 03 00 00 80 8d 0f be 20 80 ff ff ............ ...
> a0 16 c6 a1 21 80 ff ff 00 00 00 00 00 00 00 00 ....!...........
> backtrace:
> [<0000000071d2775e>] kmem_cache_alloc_node+0x13c/0x660
> [<00000000e827e6fd>] cfq_get_queue+0x318/0x6f0
> [<00000000945249ee>] cfq_set_request+0x724/0xe38
> [<00000000af64d5a9>] elv_set_request+0x84/0xd0
> [<0000000047344f0d>] __get_request+0x970/0xf90
> [<00000000d016bd51>] get_request+0x278/0x970
> [<0000000052512d36>] blk_queue_bio+0x278/0xcc0
> [<0000000085282101>] generic_make_request+0x3c0/0x778
> [<0000000089f69c24>] submit_bio+0xdc/0x408
> [<00000000748509ae>] ext4_mpage_readpages+0xc84/0x13b8 [ext4]
> [<0000000078bfc705>] ext4_readpages+0x80/0xc0 [ext4]
> [<00000000317f2ed7>] read_pages+0xd0/0x610
> [<00000000e7ab01d2>] __do_page_cache_readahead+0x36c/0x430
> [<0000000071df2285>] ondemand_readahead+0x24c/0x6b0
> [<00000000124a824a>] page_cache_sync_readahead+0x188/0x448
> [<00000000bca561ae>] generic_file_buffered_read+0x648/0x2b58
> unreferenced object 0xffffa028411d4720 (size 240):
> 
> Fix the problem by put cooperator in check_blkcg_changed(), so that old
> cfqq can be freed.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  block/cfq-iosched.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 2eb87444b157..88bae553ece3 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3778,6 +3778,7 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
>  	if (cfqq) {
>  		cfq_log_cfqq(cfqd, cfqq, "changed cgroup");
>  		cic_set_cfqq(cic, NULL, true);
> +		cfq_put_cooperator(cfqq);
>  		cfq_put_queue(cfqq);
>  	}
>  
> -- 
> 2.31.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
