Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295515AB800
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 20:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiIBSMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 14:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIBSMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 14:12:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A059F14094;
        Fri,  2 Sep 2022 11:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58FA0B82D01;
        Fri,  2 Sep 2022 18:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38367C433D6;
        Fri,  2 Sep 2022 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662142346;
        bh=E30b+14ku7Sf32GYr68BrvzpZrKcbccz0XGByZ9Zg9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fB2mw+I83hOQ4LUp3b4wj8MNJ6whFO3s7CneREbnLn1ZmeR+z+GVpBDJuWjCTOxkk
         APXjVzkJ83/bl6yILOcty4K4QwmVEbB/5xbBmCqs+vTDQ2jfFvhH/PWtgvV0oPrKBj
         cusAh3f96ul5s5W8Rw+jKM44lXJWZAx3+zduKDSsG/Ph/SlLLRs/ZVigQrwATxN2h4
         iyeVwrMTw8rFbQqrmBUaY/W+PdxdstiL5tpllOowQ7Zq5TuuKl5CpAYmLfqibmP6Vf
         TRVLJy1TsG4DiNRPhploGx/ZR3XzgUGTMYp2VTD3WislJhV9KMgECl2EAx3LjKIveL
         MBjqaExFPs41w==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        SeongJae Park <sj@kernel.org>, linux-kernel@vger.kernel.org,
        damon@lists.linux.dev, linux-mm@kvack.org,
        stable <stable@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/dbgfs: fix memory leak when using debugfs_lookup()
Date:   Fri,  2 Sep 2022 18:12:22 +0000
Message-Id: <20220902181222.83287-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220902091703.dcee7737e7ce8857e3235fa7@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew and Greg!

On Fri, 2 Sep 2022 09:17:03 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri,  2 Sep 2022 14:56:31 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > When calling debugfs_lookup() the result must have dput() called on it,
> > otherwise the memory will leak over time.  Fix this up by properly
> > calling dput().

Thank you for finding this bug and posting this patch, Greg!

> > 
> > ...
> >
> 
> Fixes: 75c1c2b53c78b, I assume.

Correct, Andrew.

Fixes: 75c1c2b53c78b ("mm/damon/dbgfs: support multiple contexts")
Cc: <stable@vger.kernel.org> # 5.15.x

> 
> > --- a/mm/damon/dbgfs.c
> > +++ b/mm/damon/dbgfs.c
> > @@ -915,6 +915,7 @@ static int dbgfs_rm_context(char *name)
> >  		new_ctxs[j++] = dbgfs_ctxs[i];
> >  	}
> >  
> > +	dput(dir);
> >  	kfree(dbgfs_dirs);
> >  	kfree(dbgfs_ctxs);
> >  
> 
> dput() is also needed if either of the kmalloc_array() calls fail?
> Maybe something like

Good catch.

> 
> --- a/mm/damon/dbgfs.c~a
> +++ a/mm/damon/dbgfs.c
> @@ -884,6 +884,7 @@ static int dbgfs_rm_context(char *name)
>  	struct dentry *root, *dir, **new_dirs;
>  	struct damon_ctx **new_ctxs;
>  	int i, j;
> +	int ret = 0;
>  
>  	if (damon_nr_running_ctxs())
>  		return -EBUSY;
> @@ -899,14 +900,12 @@ static int dbgfs_rm_context(char *name)
>  	new_dirs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_dirs),
>  			GFP_KERNEL);
>  	if (!new_dirs)
> -		return -ENOMEM;
> +		goto out_dput;

Shouldn't we also do 'ret = -ENOMEM;' before 'godo out_dput'?

>  
>  	new_ctxs = kmalloc_array(dbgfs_nr_ctxs - 1, sizeof(*dbgfs_ctxs),
>  			GFP_KERNEL);
> -	if (!new_ctxs) {
> -		kfree(new_dirs);
> -		return -ENOMEM;
> -	}
> +	if (!new_ctxs)
> +		goto out_new_dirs;

ditto.

>  
>  	for (i = 0, j = 0; i < dbgfs_nr_ctxs; i++) {
>  		if (dbgfs_dirs[i] == dir) {
> @@ -925,7 +924,13 @@ static int dbgfs_rm_context(char *name)
>  	dbgfs_ctxs = new_ctxs;
>  	dbgfs_nr_ctxs--;
>  
> -	return 0;
> +	goto out_dput;
> +
> +out_new_dirs:
> +	kfree(new_dirs);
> +out_dput:
> +	dput(dir);
> +	return ret;
>  }
>  
>  static ssize_t dbgfs_rm_context_write(struct file *file,
> _


Thanks,
SJ
