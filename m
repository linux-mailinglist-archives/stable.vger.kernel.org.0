Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A994E8BB2
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 03:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbiC1BpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 21:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiC1BpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 21:45:07 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2498149699;
        Sun, 27 Mar 2022 18:43:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c23so13562155plo.0;
        Sun, 27 Mar 2022 18:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9RNR9zr52nHugIxJEYN2sk3uYFpuqaSTDOBoX9HzNO4=;
        b=PFpO6o3zLKChAGfFLiBR0mChWVvul+X+MXHqw+lrP3hBGqUdcMiapDtQTy3RLzbIPb
         wxv+pTm73Q/VAUQmFJC44bRpW35cZigyODEmB1j6Dj/CvkDEyFwdq/Yz5EncRrySVy89
         oGHQz5y/bN7eUcxmMDvGy6HfQxiasQB0UecRQQMqTbnQvZ1Bsq07cKresna+l+ECaCnj
         AygqzIZ5G2wxm4T+AGvFh8vAt3lJ3oWhDmt8fixqV2PJBVegjlQB9AlJ5QIyrLtEJsPP
         Zfx7570QAkY2k2A1E9wl+L5BnhxKL2rPis+hDcZcPlPPnGO5rOh4BwZClUQjr5lazuix
         U1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9RNR9zr52nHugIxJEYN2sk3uYFpuqaSTDOBoX9HzNO4=;
        b=fB/L/Z91/E1Vf22Hxd1/CTY9/9h2Ar5D/z6KIgz9IWgYqF4cVBOowVBIMKJOp+V/cC
         sBd/eEmyWoCf5WEzt3A63UYA0/kTGiDyrHlh9/uu9dD1p1NTAt+W7cbJdwdxQ3vlgXLX
         RqEL+DWustCvzQdaRX8rk0zK5/7XZ9qLXGu2FbPhHCgqlsc62A9kYJw6aLzon0P3Nbh+
         a/N5bfTYHE79tSR3i58dBE5wDHVtPoOhEBLHNjOd39jRz4LSrEHC6XqyAeQRg/hyuNIA
         5R7udmdg//C0nbvCHM6PyKfAy9kTI9Chl79019c8iPXraKs+eQsTBJnl46Iq3KwMOnNt
         /t9Q==
X-Gm-Message-State: AOAM530l57eQmuwC7AlIWrUr5p/CQEGxJ3c8fKrrBslB61nlwsVhhbB7
        AgeRk7mZ2y1qUbDQmHXn92Y=
X-Google-Smtp-Source: ABdhPJywb7Gs9aQi718r3lu2LJAk8/u2Ygdz3SwAdrfgFRrvnbkPk1sXVYBq8NHxMKoTeRWSrFVldg==
X-Received: by 2002:a17:902:b10c:b0:154:a3b5:b33a with SMTP id q12-20020a170902b10c00b00154a3b5b33amr23409743plr.3.1648431806312;
        Sun, 27 Mar 2022 18:43:26 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id v24-20020a634818000000b0036407db4728sm10939289pga.26.2022.03.27.18.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 18:43:25 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     trondmy@hammerspace.com
Cc:     anna@kernel.org, bhalevy@panasas.com, bharrosh@panasas.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        stable@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] nfs: callback_proc: fix an incorrect NULL check on list iterator
Date:   Mon, 28 Mar 2022 09:43:14 +0800
Message-Id: <20220328014314.18987-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <436766b6fb5f3ec513629d4fa0888b77c65cfa16.camel@hammerspace.com>
References: <436766b6fb5f3ec513629d4fa0888b77c65cfa16.camel@hammerspace.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 27 Mar 2022 15:20:42 +0000, Trond Myklebust wrote:
> On Sun, 2022-03-27 at 16:02 +0800, Xiaomeng Tong wrote:
> > The bug is here:
> >         if (!server ||
> >         server->pnfs_curr_ld->id != dev->cbd_layout_type) {
> > 
> > The list iterator value 'server' will *always* be set and non-NULL
> > by list_for_each_entry_rcu, so it is incorrect to assume that the
> > iterator value will be NULL if the list is empty or no element is
> > found (In fact, it will be a bogus pointer to an invalid struct
> > object containing the HEAD, which is used for above check at next
> > outer loop). Otherwise it may bypass the check in theory (iif
> > server->pnfs_curr_ld->id == dev->cbd_layout_type, 'server' now is
> > a bogus pointer) and lead to invalid memory access passing the check.
> > 
> > To fix the bug, use a new variable 'iter' as the list iterator,
> > while use the original variable 'server' as a dedicated pointer to
> > point to the found element.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 1be5683b03a76 ("pnfs: CB_NOTIFY_DEVICEID")
> > Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> > ---
> >  fs/nfs/callback_proc.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
> > index c343666d9a42..84779785dc8d 100644
> > --- a/fs/nfs/callback_proc.c
> > +++ b/fs/nfs/callback_proc.c
> > @@ -361,7 +361,7 @@ __be32 nfs4_callback_devicenotify(void *argp,
> > void *resp,
> >         uint32_t i;
> >         __be32 res = 0;
> >         struct nfs_client *clp = cps->clp;
> > -       struct nfs_server *server = NULL;
> > +       struct nfs_server *server = NULL, *iter;
> >  
> >         if (!clp) {
> >                 res = cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
> > @@ -374,10 +374,11 @@ __be32 nfs4_callback_devicenotify(void *argp,
> > void *resp,
> >                 if (!server ||
> >                     server->pnfs_curr_ld->id != dev->cbd_layout_type)
> > {
> >                         rcu_read_lock();
> > -                       list_for_each_entry_rcu(server, &clp-
> > >cl_superblocks, client_link)
> > -                               if (server->pnfs_curr_ld &&
> > -                                   server->pnfs_curr_ld->id == dev-
> > >cbd_layout_type) {
> > +                       list_for_each_entry_rcu(iter, &clp-
> > >cl_superblocks, client_link)
> > +                               if (iter->pnfs_curr_ld &&
> > +                                   iter->pnfs_curr_ld->id == dev-
> > >cbd_layout_type) {
> >                                         rcu_read_unlock();
> > +                                       server = iter;
> 
> Hmm... We're not holding any locks on the super block for 'iter' here,
> so nothing is preventing it from going away while we're.
> 

ok, i am not a 'rcu lock' expert, i will make it hold the rcu_read_lock()
if necessary.

> Given that we really only want a pointer to the struct
> pnfs_layoutdriver_type anyway, why not just convert the code to save a
> pointer to that (and do it while holding the rcu_read_lock())?
> 

Maybe it's not that simple. If you only save a pointer to that and still
use 'server' as the list iterator of list_for_each_entry_rcu, there could
be problem.

I.e., if no element found in list_for_each_entry_rcu in the first outer
'for' loop, and now 'server' is a bogus pointer to an invalid struct, and
continue to go into the second outer 'for' loop, and the check below will
lead to invalid memory access (server->pnfs_curr_ld->id), even can potentialy
be bypassed with crafted data to make the condition false and mistakely run
nfs4_delete_deviceid(server->pnfs_curr_ld, clp, &dev->cbd_dev_id); with bogus
'server'.

if (!server ||
    server->pnfs_curr_ld->id != dev->cbd_layout_type) {

> The struct pnfs_layoutdriver is always expected to be a statically
> allocated structure, so it won't go away as long as the pNFS driver
> module remains loaded.
>

--
Xiaomeng Tong 
