Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52B94E9885
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 15:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiC1Np3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 09:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242157AbiC1Np2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 09:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D8F55B9;
        Mon, 28 Mar 2022 06:43:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C7F161169;
        Mon, 28 Mar 2022 13:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EBDC004DD;
        Mon, 28 Mar 2022 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648475026;
        bh=oHPX4dxkslmbgVNn7WyrR3+9FTtOwGZ2SlopKZz6En8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HqinKsJMtlplF1sflshBUOeTcTGiBf1RwWiWlFMUFjZGZrYCWHFHUIBHiMsZbRl42
         kavH74/EfofOpUH1t8yXVjVzMh7zkg4SKJ9SJgktRJd/24RsU6TZHG3qwX9XDQS5eu
         ShENddtBRHePg/QAMFHDkUaoNBKov5yTnYWPd9yI=
Date:   Mon, 28 Mar 2022 15:43:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "xiam0nd.tong@gmail.com" <xiam0nd.tong@gmail.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfs: callback_proc: fix an incorrect NULL check on list
 iterator
Message-ID: <YkG7kPhYm+1fDxPB@kroah.com>
References: <436766b6fb5f3ec513629d4fa0888b77c65cfa16.camel@hammerspace.com>
 <20220328014314.18987-1-xiam0nd.tong@gmail.com>
 <c4af251c0b90180b187e8a328d4ce5b948db9fcd.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4af251c0b90180b187e8a328d4ce5b948db9fcd.camel@hammerspace.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 01:24:57PM +0000, Trond Myklebust wrote:
> On Mon, 2022-03-28 at 09:43 +0800, Xiaomeng Tong wrote:
> > On Sun, 27 Mar 2022 15:20:42 +0000, Trond Myklebust wrote:
> > > On Sun, 2022-03-27 at 16:02 +0800, Xiaomeng Tong wrote:
> > > > The bug is here:
> > > >         if (!server ||
> > > >         server->pnfs_curr_ld->id != dev->cbd_layout_type) {
> > > > 
> > > > The list iterator value 'server' will *always* be set and non-
> > > > NULL
> > > > by list_for_each_entry_rcu, so it is incorrect to assume that the
> > > > iterator value will be NULL if the list is empty or no element is
> > > > found (In fact, it will be a bogus pointer to an invalid struct
> > > > object containing the HEAD, which is used for above check at next
> > > > outer loop). Otherwise it may bypass the check in theory (iif
> > > > server->pnfs_curr_ld->id == dev->cbd_layout_type, 'server' now is
> > > > a bogus pointer) and lead to invalid memory access passing the
> > > > check.
> > > > 
> > > > To fix the bug, use a new variable 'iter' as the list iterator,
> > > > while use the original variable 'server' as a dedicated pointer
> > > > to
> > > > point to the found element.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 1be5683b03a76 ("pnfs: CB_NOTIFY_DEVICEID")
> > > > Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> > > > ---
> > > >  fs/nfs/callback_proc.c | 9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
> > > > index c343666d9a42..84779785dc8d 100644
> > > > --- a/fs/nfs/callback_proc.c
> > > > +++ b/fs/nfs/callback_proc.c
> > > > @@ -361,7 +361,7 @@ __be32 nfs4_callback_devicenotify(void *argp,
> > > > void *resp,
> > > >         uint32_t i;
> > > >         __be32 res = 0;
> > > >         struct nfs_client *clp = cps->clp;
> > > > -       struct nfs_server *server = NULL;
> > > > +       struct nfs_server *server = NULL, *iter;
> > > >  
> > > >         if (!clp) {
> > > >                 res = cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
> > > > @@ -374,10 +374,11 @@ __be32 nfs4_callback_devicenotify(void
> > > > *argp,
> > > > void *resp,
> > > >                 if (!server ||
> > > >                     server->pnfs_curr_ld->id != dev-
> > > > >cbd_layout_type)
> > > > {
> > > >                         rcu_read_lock();
> > > > -                       list_for_each_entry_rcu(server, &clp-
> > > > > cl_superblocks, client_link)
> > > > -                               if (server->pnfs_curr_ld &&
> > > > -                                   server->pnfs_curr_ld->id ==
> > > > dev-
> > > > > cbd_layout_type) {
> > > > +                       list_for_each_entry_rcu(iter, &clp-
> > > > > cl_superblocks, client_link)
> > > > +                               if (iter->pnfs_curr_ld &&
> > > > +                                   iter->pnfs_curr_ld->id ==
> > > > dev-
> > > > > cbd_layout_type) {
> > > >                                         rcu_read_unlock();
> > > > +                                       server = iter;
> > > 
> > > Hmm... We're not holding any locks on the super block for 'iter'
> > > here,
> > > so nothing is preventing it from going away while we're.
> > > 
> > 
> > ok, i am not a 'rcu lock' expert, i will make it hold the
> > rcu_read_lock()
> > if necessary.
> > 
> > > Given that we really only want a pointer to the struct
> > > pnfs_layoutdriver_type anyway, why not just convert the code to
> > > save a
> > > pointer to that (and do it while holding the rcu_read_lock())?
> > > 
> > 
> > Maybe it's not that simple. If you only save a pointer to that and
> > still
> > use 'server' as the list iterator of list_for_each_entry_rcu, there
> > could
> > be problem.
> > 
> > I.e., if no element found in list_for_each_entry_rcu in the first
> > outer
> > 'for' loop, and now 'server' is a bogus pointer to an invalid struct,
> > and
> > continue to go into the second outer 'for' loop, and the check below
> > will
> > lead to invalid memory access (server->pnfs_curr_ld->id), even can
> > potentialy
> > be bypassed with crafted data to make the condition false and
> > mistakely run
> > nfs4_delete_deviceid(server->pnfs_curr_ld, clp, &dev->cbd_dev_id);
> > with bogus
> > 'server'.
> > 
> > if (!server ||
> >     server->pnfs_curr_ld->id != dev->cbd_layout_type) {
> > 
> > > The struct pnfs_layoutdriver is always expected to be a statically
> > > allocated structure, so it won't go away as long as the pNFS driver
> > > module remains loaded.
> > 
> 
> 
> Let's just do the following.
> 
> 8<-----------------------------------------------
> From 7c9d845f0612e5bcd23456a2ec43be8ac43458f1 Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <trond.myklebust@hammerspace.com>
> Date: Mon, 28 Mar 2022 08:36:34 -0400
> Subject: [PATCH] NFSv4/pNFS: Fix another issue with a list iterator pointing
>  to the head
> 
> In nfs4_callback_devicenotify(), if we don't find a matching entry for
> the deviceid, we're left with a pointer to 'struct nfs_server' that
> actually points to the list of super blocks associated with our struct
> nfs_client.
> Furthermore, even if we have a valid pointer, nothing pins the super
> block, and so the struct nfs_server could end up getting freed while
> we're using it.
> 
> Since all we want is a pointer to the struct pnfs_layoutdriver_type,
> let's skip all the iteration over super blocks, and just use APIs to
> find the layout driver directly.
> 
> Reported-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> ---
>  fs/nfs/callback_proc.c | 27 +++++++++------------------
>  fs/nfs/pnfs.c          | 11 +++++++++++
>  fs/nfs/pnfs.h          |  2 ++
>  3 files changed, 22 insertions(+), 18 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
