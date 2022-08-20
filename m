Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD359B25F
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 08:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiHUG6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 02:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiHUG61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 02:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E112ADE;
        Sat, 20 Aug 2022 23:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0017060CD4;
        Sun, 21 Aug 2022 06:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D12EC433D6;
        Sun, 21 Aug 2022 06:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065103;
        bh=tbuVzHoEL8ZVZPHiH4E6B7fj2SIHZgFp4d15ptne13A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qeS88CcrbZxYoNjnNZ8rrfUJAL0QH8+Ilq9eUT2AWxAB/JeIQ5ONfou68r+J8agdD
         Kd2kevU/0A4V3wpOZAv32UzCjcexHXYMLyYAa4cWfNDtwWKtddQxNh5ADur/eZP5vj
         CHtkQ+AHGAuqFb0t0Z4ZBk6MTfI66ufO+p5Glitw=
Date:   Sat, 20 Aug 2022 19:32:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     SeongJae Park <sj@kernel.org>, badari.pulavarty@intel.com,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/dbgfs: avoid duplicate context directory
 creation
Message-ID: <YwEatUUtU8570PRV@kroah.com>
References: <20220819171930.16166-1-sj@kernel.org>
 <20220819140809.1e3929fd8f50bfc32cae31d3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819140809.1e3929fd8f50bfc32cae31d3@linux-foundation.org>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 02:08:09PM -0700, Andrew Morton wrote:
> On Fri, 19 Aug 2022 17:19:30 +0000 SeongJae Park <sj@kernel.org> wrote:
> 
> > From: Badari Pulavarty <badari.pulavarty@intel.com>
> > 
> > When user tries to create a DAMON context via the DAMON debugfs
> > interface with a name of an already existing context, the context
> > directory creation silently fails but the context is added in the
> > internal data structure.  As a result, memory could leak and DAMON
> > cannot be turned on.  An example test case is as below:
> > 
> >     # cd /sys/kernel/debug/damon/
> >     # echo "off" >  monitor_on
> >     # echo paddr > target_ids
> >     # echo "abc" > mk_context
> >     # echo "abc" > mk_context
> >     # echo $$ > abc/target_ids
> >     # echo "on" > monitor_on  <<< fails
> > 
> > This commit fixes the issue by checking if the name already exist and
> > immediately returning '-EEXIST' in the case.
> > 
> > ...
> >
> > --- a/mm/damon/dbgfs.c
> > +++ b/mm/damon/dbgfs.c
> > @@ -795,7 +795,7 @@ static void dbgfs_destroy_ctx(struct damon_ctx *ctx)
> >   */
> >  static int dbgfs_mk_context(char *name)
> >  {
> > -	struct dentry *root, **new_dirs, *new_dir;
> > +	struct dentry *root, **new_dirs, *new_dir, *dir;
> >  	struct damon_ctx **new_ctxs, *new_ctx;
> >  
> >  	if (damon_nr_running_ctxs())
> > @@ -817,6 +817,12 @@ static int dbgfs_mk_context(char *name)
> >  	if (!root)
> >  		return -ENOENT;
> >  
> > +	dir = debugfs_lookup(name, root);
> > +	if (dir) {
> > +		dput(dir);
> > +		return -EEXIST;
> > +	}
> > +
> >  	new_dir = debugfs_create_dir(name, root);
> >  	dbgfs_dirs[dbgfs_nr_ctxs] = new_dir;
> 
> It would be simpler (and less racy) to check the debugfs_create_dir()
> return value for IS_ERR()?
> 

Yes, if you _HAVE_ to know if the code works properly (i.e. because your
feature totally depends on debugfs like damon does), or you have a
potential duplicate name like this, then sure, check the return value
and do something based on it.

It's odd enough that you should put a comment above the check just so I
don't go and send a patch to delete it later on :)

thanks,

greg k-h
