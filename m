Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A740748B616
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbiAKSss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243152AbiAKSsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:48:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A5BC06173F;
        Tue, 11 Jan 2022 10:48:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC7BBB81CBC;
        Tue, 11 Jan 2022 18:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EBEC36AE3;
        Tue, 11 Jan 2022 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641926924;
        bh=5nGYIYBRmlX498OYXLYdWFITJZwpiQZZoetGM7GB/fE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wd7AZGPkge+6cI3FvoFCWSh82K8CVRceabYCdOCrTyvHKDLqB1Q9P2A2tba+RaQqw
         POmUe9J82+/tMLueySgCXzzGAUtvrIwMxivx8KFmQCpZCdW+ViqxSNO8ghVbq7x7rk
         9TZytphLIPVL5ayUv9kDm1o7LAoLdoPFw0ylo2ly+e6nR4IbrYxD1fVXSpGKRP9fGu
         zZ1gsocbGXmFjqfEkfD41WGCEQQpmkzit5KYHDHmkGwTVOMZQDYhgSzMkrNaD9tO3m
         g7Jkiij8SxNEBbWhKOmilIUU77Y3ES6H7fr7WvENO8Ux5hD+k2qYywSEZbtzAiYrW9
         DPI6pWEz2c00w==
Date:   Tue, 11 Jan 2022 10:48:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     hannes@cmpxchg.org, torvalds@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, bristot@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@android.com,
        syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Message-ID: <Yd3RClhoz24rrU04@sol.localdomain>
References: <20220111071212.1210124-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111071212.1210124-1-surenb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 11:12:12PM -0800, Suren Baghdasaryan wrote:
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index cafb8c114a21..93b51a2104f7 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3642,6 +3642,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
>  	cgroup_get(cgrp);
>  	cgroup_kn_unlock(of->kn);
>  
> +	/* Allow only one trigger per file descriptor */
> +	if (ctx->psi.trigger) {
> +		cgroup_put(cgrp);
> +		return -EBUSY;
> +	}
> +
>  	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
>  	new = psi_trigger_create(psi, buf, nbytes, res);
>  	if (IS_ERR(new)) {
> @@ -3649,8 +3655,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
>  		return PTR_ERR(new);
>  	}
>  
> -	psi_trigger_replace(&ctx->psi.trigger, new);
> -
> +	ctx->psi.trigger = new;
>  	cgroup_put(cgrp);

The write here needs to use smp_store_release(), since it is paired with the
concurrent READ_ONCE() in psi_trigger_poll().

> @@ -1305,14 +1287,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
>  
>  	buf[buf_size - 1] = '\0';
>  
> -	new = psi_trigger_create(&psi_system, buf, nbytes, res);
> -	if (IS_ERR(new))
> -		return PTR_ERR(new);
> -
>  	seq = file->private_data;
> +
>  	/* Take seq->lock to protect seq->private from concurrent writes */
>  	mutex_lock(&seq->lock);
> -	psi_trigger_replace(&seq->private, new);
> +
> +	/* Allow only one trigger per file descriptor */
> +	if (seq->private) {
> +		mutex_unlock(&seq->lock);
> +		return -EBUSY;
> +	}
> +
> +	new = psi_trigger_create(&psi_system, buf, nbytes, res);
> +	if (IS_ERR(new)) {
> +		mutex_unlock(&seq->lock);
> +		return PTR_ERR(new);
> +	}
> +
> +	seq->private = new;

Likewise here.

- Eric
