Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820C05EAD6D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiIZRAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiIZQ7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:59:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6B41CFFE
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 09:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2987B80B06
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 15:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24556C433D6;
        Mon, 26 Sep 2022 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664207998;
        bh=lCXiO5pkSuuEK+otVIzDciHG2H+yZcwpbuBZsPzrWa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgiVK7mlWxF02ggtQ8CCAWjFQap9Zpjtj+0XJ0De6iqH3MkSmfzxxO9L6k1akCCFS
         8Pf9uM333SznQrsjGEKuU7PXs3ESYJDNjfao4hJpww3eO1EntSD263zFhTaJ1qxwgb
         C602ymei1Y6K573DFfnZWSP6Fe03gHrZRjGi83ztEF/7jE+YpHJF5d5g3iVe5JtDF4
         x27ffxgVKpmN5AZNqmvy0aTlSSm+3q9ajX4011KfzhS2kLpypDA2rUkQPTOdH8tZj2
         aMcwbX7QZoIiWLtgPvaJbaQ+sDjt2S5VWNiTOmvgXNRXUPXYhVjBHf3uE3KBaNpw+F
         33RaINjWgiCEA==
From:   SeongJae Park <sj@kernel.org>
To:     Levi Yun <ppbuk5246@gmail.com>
Cc:     sj@kernel.org, akpm@linux-foundation.org, damon@lists.linux.dev,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] damon/sysfs: Fix possible memleak on damon_sysfs_add_target.
Date:   Mon, 26 Sep 2022 15:59:54 +0000
Message-Id: <20220926155954.48379-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220925234327.26345-1-ppbuk5246@gmail.com>
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

Hi Levi,

On Mon, 26 Sep 2022 08:43:27 +0900 Levi Yun <ppbuk5246@gmail.com> wrote:

> When damon_sysfs_add_target couldn't find proper task,
> New allocated damon_target structure isn't registered yet,
> So, it's impossible to free new allocated one by
> damon_sysfs_destroy_targets.
> 
> By calling daemon_add_target as soon as allocating new target, Fix this
> possible memory leak.
> 
> Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
> Fixes:74bd8b7d2f8e7

The commit is indeed the last one which touched the code, but the bug was
introduced earlier than that, by commit a61ea561c871 ("mm/damon/sysfs: link
DAMON for virtual address spaces monitoring").

Also, let's add one space before the commit hash, then only 12 characters for
the hash, and then one line summary of the commit[1], like below.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")

[1] https://www.kernel.org/doc/html/v4.15/process/submitting-patches.html#describe-your-changes

> Cc: <stable@vger.kernel.org>
> ---

Also, putting the change log of the patch here would be a good practice.

Other than the very minor things,

Reviewed-by: SeongJae Park <sj@kernel.org>


As the changes I'm requesting are very minor, I will revise and post a new
version of this patch on my own.


Thanks,
SJ

>  mm/damon/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 7488e27c87c3..bdef9682d0a0 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -2182,12 +2182,12 @@ static int damon_sysfs_add_target(struct damon_sysfs_target *sys_target,
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
> 2.35.1
> 
