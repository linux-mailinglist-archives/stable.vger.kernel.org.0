Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3803D5EADC5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiIZRNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiIZRM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:12:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231EC1CB0D;
        Mon, 26 Sep 2022 09:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC892B80B2B;
        Mon, 26 Sep 2022 16:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BB4C433D7;
        Mon, 26 Sep 2022 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664209408;
        bh=3NryUWgV4wNFcxmk/xIXBo2lc6PqLNsFir7j/J5ql+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9VxvHOWkGdHyuAUNDqCqlOxg64J4VVjtASjH5BQowJtyDWQK04xux3uC2Lnn5h/b
         PrDHkRjm3biuNgaFNpRDLtC0LGOHMXy2LsFtz7uO0XdOqRb+Eh4ivOmptA/35CS9AE
         97gPV8P4XpmwkyFJwfaaTnPJGVJAGhX3Jt9lGsGaH0vIyxp426Yp0DFXZ1V6CjQq0T
         Th3Il54+19a9FLERiAON15iosTLwqWxoAYdJNf1gGmlbBYPj7NHlZ8EjnvVJX5kywR
         +fugilr2jLjXoD9mxnrbzQyvT57xD9145ZkkEUXa1cuHN5TUZy/GvncTnsQsxcuBG7
         SC+gT25qjxAFA==
From:   SeongJae Park <sj@kernel.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     akpm@linux-foundation.org, ppbuk5246@gmail.com,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
Date:   Mon, 26 Sep 2022 16:23:26 +0000
Message-Id: <20220926162326.49013-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926160611.48536-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I forgot removing the closing dot of the subject and making the subject
lower-case.

On Mon, 26 Sep 2022 16:06:11 +0000 SeongJae Park <sj@kernel.org> wrote:

> From: Levi Yun <ppbuk5246@gmail.com>
> 
> When damon_sysfs_add_target couldn't find proper task,
> New allocated damon_target structure isn't registered yet,
> So, it's impossible to free new allocated one by
> damon_sysfs_destroy_targets.
> 
> By calling daemon_add_target as soon as allocating new target, Fix this

Also we should s/daemon/damon/

I will revise and send v5.

> possible memory leak.
> 
> Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
> Cc: <stable@vger.kernel.org> # 5.17.x
> Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
> 
> Changes from v3
> (https://lore.kernel.org/damon/20220925234327.26345-1-ppbuk5246@gmail.com/)
> - Fix Fixes: tag
> - Add patch changelog
> 
> Changes from v2
> (https://lore.kernel.org/damon/20220925234053.26090-1-ppbuk5246@gmail.com/)
> - Add Fixes: and Cc: stable
> 
> Changes from v1
> (https://lore.kernel.org/damon/20220925140257.23431-1-ppbuk5246@gmail.com/)
> - Do damon_add_target() earlier instead of explicitly freeing the object
> 
>  mm/damon/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 455215a5c059..9f1219a67e3f 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -2172,12 +2172,12 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
>  
>  	if (!t)
>  		return -ENOMEM;
> +	damon_add_target(ctx, t);
>  	if (damon_target_has_pid(ctx)) {
>  		t->pid = find_get_pid(sys_target->pid);
>  		if (!t->pid)
>  			goto destroy_targets_out;
>  	}
> -	damon_add_target(ctx, t);
>  	err = damon_sysfs_set_regions(t, sys_target->regions);
>  	if (err)
>  		goto destroy_targets_out;
> -- 
> 2.25.1
