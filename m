Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA0C59A789
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 23:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352343AbiHSVQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 17:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352273AbiHSVQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 17:16:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DDDE7265;
        Fri, 19 Aug 2022 14:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6BD616E4;
        Fri, 19 Aug 2022 21:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B56C433D6;
        Fri, 19 Aug 2022 21:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660943793;
        bh=GOhiVfsBqX2y7z90q7076zjMmF36TVkpwUIPXpa8SDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y550pgYDKfKcM94iqZr/Kgq976SROYgaTEdPCdGJTjVuM9A8E9QcWgimbBLXTrhgC
         wFFQeAuB8KcNOT+QpevCOXkINubcBNAPa1d24Q0EBAxU5908J5ExF6xMOcwgxZDNUN
         OfF9Ohl6YRulDg4I8E9E1kcGPHJ2yCG7Qwf0n7NalTbH08DnVK91ipOBZrpsgsIIaI
         5h7yZxM71gpMmuIQjUh353asy0fDMY8F/VJCNC9aoB/cAswa6sDF6nVNMniOi8WrcH
         eJm1uH+UyCmoqEMAiM9/PlgF9nleEDZlPAKon/5iBGyNTQ/7zdDIQWWp2cub8TYMt9
         JYqLUlDZr7G+w==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     SeongJae Park <sj@kernel.org>, gregkh@linuxfoundation.org,
        badari.pulavarty@intel.com, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/dbgfs: avoid duplicate context directory creation
Date:   Fri, 19 Aug 2022 21:16:31 +0000
Message-Id: <20220819211631.16658-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819140809.1e3929fd8f50bfc32cae31d3@linux-foundation.org>
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

On Fri, 19 Aug 2022 14:08:09 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

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

I was merely following Greg's previous advice for ignoring the return value[1]
of the function, but I might misunderstanding his intention, so CC-ing Greg.
Greg, may I ask your opinion?

[1] https://lore.kernel.org/linux-mm/YB1kZaD%2F7omxXztF@kroah.com/


Thanks,
SJ
