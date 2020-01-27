Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102D014A13C
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 10:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgA0Jzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 04:55:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52511 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgA0Jzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 04:55:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so6097046wmc.2;
        Mon, 27 Jan 2020 01:55:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I2VdxwWfGUSvETRstHOrgGIKAIJsoyuCf6YtlGNX5P8=;
        b=U84ReDomJ3DbU0kf3ckcN571oCljRHZHsZxyscYqSJM2GmgP0GTrmOI+a6FYIeEhTn
         74n/9JtaS0gfbn8XwteGU23GPW9H2arPlnPVWkw5ShZgIYJB2mVdMe6s+K+HCVkDDpIS
         z0uivrqDM9LaaJyDOTyBt0YRtw5yHCbm7Tv9tWqRy1FrZyl6xlDHT92j6KztTlInnRML
         5TrS/OWbmEe37UYQsbjZ4+Cqeh4bI8cFd9Y6LBltXFHJu7QhNxIbfqV8Ly42ur2WRHwN
         hMqHBwPlnk0mskhWmsYLIPR8c48c4TxKBzOHfa4rcIWtYr9ORfe5M+AKYcjPHOkcqCJF
         oyIw==
X-Gm-Message-State: APjAAAWA9twnq/yE+340UASr4rtV0JRPZiH4fAOsrE4ndrKhA6nq4+UG
        FCIHZwlE7WTyrrVOQ3Z5OmZ06pNV
X-Google-Smtp-Source: APXvYqxQMP8hvBohgggF3tCXcNtD3qEf5zB4fS4tSmBBjR3AxrikdpnCn9A8odmj3iYor5JvAprQ1g==
X-Received: by 2002:a05:600c:218a:: with SMTP id e10mr6641625wme.6.1580118934602;
        Mon, 27 Jan 2020 01:55:34 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id a22sm15112133wmd.20.2020.01.27.01.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 01:55:33 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:55:33 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     richardw.yang@linux.intel.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200127095533.GD1183@dhcp22.suse.cz>
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 23-01-20 07:38:51, Yang Shi wrote:
> Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
> the semantic of move_pages() was changed to return the number of
> non-migrated pages (failed to migration) and the call would be aborted
> immediately if migrate_pages() returns positive value.  But it didn't
> report the number of pages that we even haven't attempted to migrate.
> So, fix it by including non-attempted pages in the return value.

I would rephrased the changelog like this
"
Since commit 49bd4d71637 ("mm, numa: rework do_pages_move"),
the semantic of move_pages() has changed to return the number of
non-migrated pages if they were result of a non-fatal reasons (usually a
busy page). This was an unintentional change that hasn't been noticed
except for LTP tests which checked for the documented behavior.

There are two ways to go around this change. We can even get back to the
original behavior and return -EAGAIN whenever migrate_pages is not able
to migrate pages due to non-fatal reasons. Another option would be to
simply continue with the changed semantic and extend move_pages
documentation to clarify that -errno is returned on an invalid input or
when migration simply cannot succeed (e.g. -ENOMEM, -EBUSY) or the
number of pages that couldn't have been migrated due to ephemeral
reasons (e.g. page is pinned or locked for other reasons).

This patch implements the second option because this behavior is in
place for some time without anybody complaining and possibly new users
depending on it. Also it allows to have a slightly easier error handling
as the caller knows that it is worth to retry when err > 0.
"

> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Cc: Wei Yang <richardw.yang@linux.intel.com>
> Cc: <stable@vger.kernel.org>    [4.17+]
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>

With a more clarification, feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> v2: Rebased on top of the latest mainline kernel per Andrew
> 
>  mm/migrate.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 86873b6..9b8eb5d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1627,8 +1627,18 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  			start = i;
>  		} else if (node != current_node) {
>  			err = do_move_pages_to_node(mm, &pagelist, current_node);
> -			if (err)
> +			if (err) {
> +				/*
> +				 * Positive err means the number of failed
> +				 * pages to migrate.  Since we are going to
> +				 * abort and return the number of non-migrated
> +				 * pages, so need incude the rest of the
> +				 * nr_pages that have not attempted as well.
> +				 */
> +				if (err > 0)
> +					err += nr_pages - i - 1;
>  				goto out;
> +			}
>  			err = store_status(status, start, current_node, i - start);
>  			if (err)
>  				goto out;
> @@ -1659,8 +1669,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  			goto out_flush;
>  
>  		err = do_move_pages_to_node(mm, &pagelist, current_node);
> -		if (err)
> +		if (err) {
> +			if (err > 0)
> +				err += nr_pages - i - 1;
>  			goto out;
> +		}
>  		if (i > start) {
>  			err = store_status(status, start, current_node, i - start);
>  			if (err)
> @@ -1674,6 +1687,13 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  
>  	/* Make sure we do not overwrite the existing error */
>  	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
> +	/*
> +	 * Don't have to report non-attempted pages here since:
> +	 *     - If the above loop is done gracefully there is not non-attempted
> +	 *       page.
> +	 *     - If the above loop is aborted to it means more fatal error
> +	 *       happened, should return err.
> +	 */
>  	if (!err1)
>  		err1 = store_status(status, start, current_node, i - start);
>  	if (!err)
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
