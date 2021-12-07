Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E1E46C357
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 20:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240857AbhLGTMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 14:12:17 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:37886 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240856AbhLGTMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 14:12:16 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3277021B39;
        Tue,  7 Dec 2021 19:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638904125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=niz+gipHwOp3WNjxROtKHr6F+e90fRTIiaV+AhLVRjE=;
        b=CrVG0o9D3ePoRKMpFmdr0JmlbaiFeYYMhpbfUGzbawFoZ+W3UDpTJBg/TaSL3rIUT+uDi0
        SeVEQbv8Eh5NM6OGu8sKA/GU0BRKPIkO0k5k+fNOusOczAYjJ1sWtdO528Owdy1BFsVniR
        ASGmD98/jrKXst4wbFXONPf7vEl+LZA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0FFAB13AB6;
        Tue,  7 Dec 2021 19:08:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id g504Az2xr2HgaAAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 07 Dec 2021 19:08:45 +0000
Date:   Tue, 7 Dec 2021 20:08:43 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        fvogt@suse.de, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        stable@vger.kernel.org, Fabian Vogt <fvogt@suse.com>
Subject: Re: [PATCH] bfq: Fix use-after-free with cgroups
Message-ID: <20211207190843.GA40898@blackbody.suse.cz>
References: <20211201133439.3309-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201133439.3309-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 01, 2021 at 02:34:39PM +0100, Jan Kara <jack@suse.cz> wrote:
> After some analysis we've found out that the culprit of the problem is
> that some task is reparented from cgroup G to the root cgroup and G is
> offlined.

Just sharing my interpretation for context -- (I saw this was a system
using the unified cgroup hierarchy, io_cgrp_subsys_on_dfl_key was
enabled) and what was observed could also have been disabling the io
controller on given level -- that would also manifest similarly -- the
task is migrated to parent and the former blkcg is offlined.


> +static void bfq_reparent_children(struct bfq_data *bfqd, struct bfq_group *bfqg)
> [...]
> -	bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
> [...]
> +	hlist_for_each_entry_safe(bfqq, next, &bfqg->children, children_node)
> +		bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);

Here I assume root_group is (representing) the global blkcg root and
this reparenting thus skips all ancestors between the removed leaf and
the root. IIUC the associated io_context would then be treated as if it
was running in the root blkcg.
(Admittedly, this isn't a change from this patch but it may cause some
surprises if the given process runs after the operation.)

Reparenting to the immediate ancestors should be safe as cgroup core
should ensure children are offlined before parents. Would it make sense
to you?


> @@ -897,38 +844,17 @@ static void bfq_pd_offline(struct blkg_policy_data *pd)
> [...]
> -		 * It may happen that some queues are still active
> -		 * (busy) upon group destruction (if the corresponding
> -		 * processes have been forced to terminate). We move
> -		 * all the leaf entities corresponding to these queues
> -		 * to the root_group.

This comment is removed but it seems to me it assumed that the
reparented entities are only some transitional remainings of terminated
tasks but they may be the processes migrated upwards with a long (IO
active) life ahead.


