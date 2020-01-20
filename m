Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A53A142B7B
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 14:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgATNG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 08:06:29 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36168 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgATNG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 08:06:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so14662913wma.1;
        Mon, 20 Jan 2020 05:06:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yAP4AxE8jezFjjNwotXQWmTcKA84LGA03EpyU82A5NQ=;
        b=JFQt4NA9ODEdbrhgqEnltqJvRrqhvFTw6q548TRUBfPZbxeV/NGixFVZHipaxPFn2R
         PfshJIod+7e3W3xcMHzNt+N59SITEe/EbaKu4lmCqZ/D6IDD1KcIMB/uIREOuxpAivLJ
         s6OSGP7hKkVU7ImbGWNyWPu8KyNKxV1waHyl/tSvQteXViGSCZAOGyW2PkJ1MceMRogF
         TOpKj5GfTn5gVcH3xj9uMtIOHHma26n+Zd/gJwDZ+DWs65LpTsTuJuEz+MdSjwfuSz22
         ga1rYipaN2UQEiuEZA08sr6SR6j5eI0xxSxPn2++JjeqCGrOhv1ozuryiU1U52pD6kaI
         mZKg==
X-Gm-Message-State: APjAAAUBHHU/cHq2FqddxOp5TTo21KmOlVI9Q6L1g19JY9VV5e2pqARL
        54XeCGvTciiKJJNdOworKS8cV9Rl
X-Google-Smtp-Source: APXvYqy9ZRyVn2Uj4Hak4b0GCXZIvQoCZGbEy/6ofUz59wN/vXZ2z+9kjnuxMPGnLSbwovzTlQdxwQ==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr18745263wmg.20.1579525586658;
        Mon, 20 Jan 2020 05:06:26 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id c195sm3106848wmd.45.2020.01.20.05.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:06:25 -0800 (PST)
Date:   Mon, 20 Jan 2020 14:06:24 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     richardw.yang@linux.intel.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: move_pages: fix the return value if there are
 not-migrated pages
Message-ID: <20200120130624.GD18451@dhcp22.suse.cz>
References: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat 18-01-20 13:26:43, Yang Shi wrote:
> The do_move_pages_to_node() might return > 0 value, the number of pages
> that are not migrated, then the value will be returned to userspace
> directly.  But, move_pages() syscall would just return 0 or errno.  So,
> we need reset the return value to 0 for such case as what pre-v4.17 did.

The patch is wrong. migrate_pages returns the number of pages it
_hasn't_ migrated or -errno. Yeah that semantic sucks but...
So err != 0 is always an error. Except err > 0 doesn't really provide
any useful information to the userspace. I cannot really remember what
was the actual behavior before my rework because there were some gotchas
hidden there.

If you want to fix this properly then you have to query node status of
each page unmigrated when migrate_pages fails with > 0. This would be
easier if the fix is done on the latest cleanup posted to the list which
consolidates all do_move_pages_to_node and store_status calls to a
single function.

> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Wei Yang <richardw.yang@linux.intel.com>
> Cc: <stable@vger.kernel.org>    [4.17+]
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> ---
>  mm/migrate.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 86873b6..3e75432 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  			goto out_flush;
>  
>  		err = do_move_pages_to_node(mm, &pagelist, current_node);
> -		if (err)
> +		if (err) {
> +			if (err > 0)
> +				err = 0;
>  			goto out;
> +		}
>  		if (i > start) {
>  			err = store_status(status, start, current_node, i - start);
>  			if (err)
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
