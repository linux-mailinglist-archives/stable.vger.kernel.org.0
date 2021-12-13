Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954E1472DB6
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbhLMNqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:46:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:45370 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbhLMNqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:46:32 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 731C71F3B9;
        Mon, 13 Dec 2021 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639403191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UyolFaM14P3cDEhuPoRNdfQMUKwyv7gy6T2mO+pB6xQ=;
        b=yl41LBoGbpRPzv8MWlVP/S7tRtKgZDXkZBgCoeG85vG7FuG3gjQYUIwF26c29dYJm8sbPR
        YLrT9c9xWsiRbxlIxxsPP55lYRe2vedNbZFXqpfvgpb9KNLX3Qewk/GNL0XPIlQNCsFmDT
        2GUZipePriaBQtnjklCUhmoeML/u58Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639403191;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UyolFaM14P3cDEhuPoRNdfQMUKwyv7gy6T2mO+pB6xQ=;
        b=jsQdHM62n6CiQzQryvCuAGb4jgn+x0EJXupvcFt2HxjHrap6ixb9OWlbosUZXfw6kxIQo6
        OuHQWfteTdVU38Cw==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id 5A7A5A3B81;
        Mon, 13 Dec 2021 13:46:31 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2A7C91E11F3; Mon, 13 Dec 2021 14:46:31 +0100 (CET)
Date:   Mon, 13 Dec 2021 14:46:31 +0100
From:   Jan Kara <jack@suse.cz>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        fvogt@suse.de, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        stable@vger.kernel.org, Fabian Vogt <fvogt@suse.com>
Subject: Re: [PATCH] bfq: Fix use-after-free with cgroups
Message-ID: <20211213134631.GB14044@quack2.suse.cz>
References: <20211201133439.3309-1-jack@suse.cz>
 <28ded939-6339-c9e1-c0a3-ff84fb197eed@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28ded939-6339-c9e1-c0a3-ff84fb197eed@applied-asynchrony.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 15:53:54, Holger Hoffstätte wrote:
> 
> On 2021-12-01 14:34, Jan Kara wrote:
> > BFQ started crashing with 5.15-based kernels like:
> > 
> > BUG: KASAN: use-after-free in rb_erase (lib/rbtree.c:262 lib/rbtr
> > Read of size 8 at addr ffff888008193098 by task bash/1472
> [snip]
> 
> This does not compile when CONFIG_BFQ_GROUP_IOSCHED is disabled.
> I know the patch is meant for the case where it is enabled, but still..
> 
> block/bfq-iosched.c: In function 'bfq_init_bfqq':
> block/bfq-iosched.c:5362:51: error: 'struct bfq_group' has no member named 'children'
>  5362 |         hlist_add_head(&bfqq->children_node, &bfqg->children);
>       |                                                   ^~
> make[1]: *** [scripts/Makefile.build:277: block/bfq-iosched.o] Error 1
> 
> Probably just needs a few more ifdefs :)

Yep, already fixed that up locally. Thanks for notice.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
