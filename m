Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E95D59C46E
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 18:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiHVQwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 12:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbiHVQwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 12:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0A926572;
        Mon, 22 Aug 2022 09:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73D3261212;
        Mon, 22 Aug 2022 16:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417EEC433C1;
        Mon, 22 Aug 2022 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661187158;
        bh=ua+EemPhFEiGOECa+PnGXwOWqdK9IkIdgInQOv3c9K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pT3kjSF+QEXT8O0OlO59j9zM4jtb5K+UdzgN4uZwb6n7hQxauBiQTUmCHt2VMwzqr
         SusENy0EE1NXLTK6z9oSNdwZtUQf8R/7h5jqy11FkaA1h1sC8QePF6tcB9quDtDW8J
         MhqAxXyh3uOO7SxMbBDKlBv1b0CQfSHSti6zsJJi5SuWjtKZ9NXM9S8ijxPGQEI1CX
         dzuSFdu7pnqtof3txRVzo1VWUOAtkX/xYfp6ybd99DysZjxdwYbEvP9ZsYgNkY+4NF
         ITyrI3vi6t3q9ZOz47VUjgkvNhseZ1nEkBI0wgBcdPjuC5ir7Z8yDQnE81HHAZSIfO
         o9qxptSAMLHfQ==
From:   SeongJae Park <sj@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     SeongJae Park <sj@kernel.org>, akpm@linux-foundation.org,
        badari.pulavarty@intel.com, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon/dbgfs: avoid duplicate context directory creation
Date:   Mon, 22 Aug 2022 16:52:36 +0000
Message-Id: <20220822165236.87421-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YwMhLHNfc7Fcdrd5@kroah.com>
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

Hi Greg,


On Mon, 22 Aug 2022 08:24:44 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Aug 21, 2022 at 06:08:53PM +0000, SeongJae Park wrote:
> > From: Badari Pulavarty <badari.pulavarty@intel.com>
> > 
> > From: Badari Pulavarty <badari.pulavarty@intel.com>
> 
> Twice?

My dumb mistake, sorry.  Fortunately Andrew fixed the mess on his own before
adding this to mm[1].  Thanks, Andrew!

[1] https://lore.kernel.org/mm-commits/20220821233916.8FC63C433D6@smtp.kernel.org/

> 
> > 
> > When user tries to create a DAMON context via the DAMON debugfs
> > interface with a name of an already existing context, the context
> > directory creation fails but a new context is created and added in the
> > internal data structure, due to absence of the directory creation
> > success check.  As a result, memory could leak and DAMON cannot be
> > turned on.  An example test case is as below:
> > 
> >     # cd /sys/kernel/debug/damon/
> >     # echo "off" >  monitor_on
> >     # echo paddr > target_ids
> >     # echo "abc" > mk_context
> >     # echo "abc" > mk_context
> >     # echo $$ > abc/target_ids
> >     # echo "on" > monitor_on  <<< fails
> > 
> > Return value of 'debugfs_create_dir()' is expected to be ignored in
> > general, but this is an exceptional case as DAMON feature is depending
> > on the debugfs functionality and it has the potential duplicate name
> > issue.  This commit therefore fixes the issue by checking the directory
> > creation failure and immediately return the error in the case.
> > 
> > Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
> > Cc: <stable@vger.kernel.org> # 5.15.x
> > Signed-off-by: Badari Pulavarty <badari.pulavarty@intel.com>
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> > Changes from v2
> > (https://lore.kernel.org/damon/20220819171930.16166-1-sj@kernel.org/)
> > - Simply check the debugfs_create_dir() return value (Andrew Morton)
> > - Put a comment for justifying check of the return value (Greg KH)
> > 
> > Changes from v1
> > (https://lore.kernel.org/damon/DM6PR11MB3978994F75A4104D714437379C679@DM6PR11MB3978.namprd11.prod.outlook.com/)
> > - Manually check duplicate entry instead of checking
> >   'debugfs_create_dir()' return value
> > - Reword commit message and the test case
> > 
> > Seems Badari have some email client issue, so I (SJ) am making this
> > third version of the patch based on Badari's final proposal and
> > reposting on behalf of Badari.
> > 
> >  mm/damon/dbgfs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/damon/dbgfs.c b/mm/damon/dbgfs.c
> > index 51d67c8050dd..3b55a1b219b5 100644
> > --- a/mm/damon/dbgfs.c
> > +++ b/mm/damon/dbgfs.c
> > @@ -818,6 +818,9 @@ static int dbgfs_mk_context(char *name)
> >  		return -ENOENT;
> >  
> >  	new_dir = debugfs_create_dir(name, root);
> > +	/* Below check is required for a potential duplicated name case */
> > +	if (IS_ERR(new_dir))
> > +		return PTR_ERR(new_dir);
> 
> Did you just leak the memory allocated above this check?  It's hard to
> determine as you are setting global variables.

We re-alloc the metadata arrays for context above for this new context, and we
do not re-alloc those in this failure case.  So yes, the arrays will have one
more item that not really needed and also not really will be used.

However, the variable for the array, 'dbgfs_nr_ctxs' is not increased here.
Therefore, the arrays will be re-allocated to the proper size when this
function or other function that re-alloc the arrays based on 'dbgfs_nr_ctxs'
(For example, 'dbgfs_rm_context()') are called.

So, though the arrays could have not-really-needed one entry that is only waste
of memory, as it's only a small and fixed amount of memory (just one more
pointer), and as the unneeded memory will eventually be returned (by a next
'dbgfs_{mk,rm}_context()' call), I think that's no problem.  This is what I
intended for keeping the logic simple.

If I'm missing something, please let me know, though.


Thanks,
SJ

> 
> thanks,
> 
> greg k-h
