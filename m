Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE8C2FFC0F
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 06:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbhAVFUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 00:20:25 -0500
Received: from relay5.mymailcheap.com ([159.100.248.207]:53795 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbhAVFUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 00:20:15 -0500
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.66.162])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 206B3260EB;
        Fri, 22 Jan 2021 05:19:21 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay2.mymailcheap.com (Postfix) with ESMTPS id B88173EDEC;
        Fri, 22 Jan 2021 06:17:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 9734F2A510;
        Fri, 22 Jan 2021 06:17:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1611292661;
        bh=rRKgtiGTcCFkbIJgrA1D99gu1b5jfXEZujQLTKBD3PE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EYUXsbM0bPtjn7+8s94shScNCkCP69cMbZ+yQ/D47a7QQ+/B2WeKOx3oNpd60gUv3
         OaCRGodkn77XcaUK9lCZAU17ifTr+2Tde55Kk1YZhGrsWa3sOwZLJRzHtUV6tyWCt/
         ZbZe871J7xGT2wlHnkxP0PbMMGXs8rhRGMSUQ+bw=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SwL9I7S9yZWJ; Fri, 22 Jan 2021 06:17:40 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Fri, 22 Jan 2021 06:17:40 +0100 (CET)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 7C228400CF;
        Fri, 22 Jan 2021 05:17:39 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="p/bz1Dk7";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [192.168.1.216] (unknown [59.41.162.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 235814100C;
        Fri, 22 Jan 2021 05:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1611292652; bh=rRKgtiGTcCFkbIJgrA1D99gu1b5jfXEZujQLTKBD3PE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p/bz1Dk7J7IGtNouIiXf6SqfZ+e/rsjnqGGosyeVcHOhtzOAO8PGIX9AUw++DbP0t
         Cvwa9jL5Sl1/ywTn+A6xrBKsHrkyxFkZ10K4jOrHcAsiYkyrWiYoPea+tdcb10pN3w
         XwdEhgNMGgwPz9oDiX7ZkyhIsbs15rF3jFA59aFk=
Message-ID: <5ce1a5ceba591d6df3e04b8aa71af9d25fac63ea.camel@aosc.io>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile
 caching
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date:   Fri, 22 Jan 2021 13:17:07 +0800
In-Reply-To: <CAJfpegsVnpV38j4ShOG0m9xh8Fy=P2kmZ_hwyfiaAzmM3tVaOg@mail.gmail.com>
References: <20210105003611.194511-1-icenowy@aosc.io>
         <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
         <20210120102045.GD1236412@miu.piliscsaba.redhat.com>
         <83bb613212ee81648e5bf7c0f9cd3219e0046f80.camel@aosc.io>
         <CAJfpegsVnpV38j4ShOG0m9xh8Fy=P2kmZ_hwyfiaAzmM3tVaOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[6];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.162.145:received];
         ML_SERVERS(-3.10)[148.251.23.173];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[aosc.io:+];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         FREEMAIL_CC(0.00)[gmail.com,cn.fujitsu.com,vger.kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Queue-Id: 7C228400CF
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021-01-21星期四的 09:07 +0100，Miklos Szeredi写道：
> On Thu, Jan 21, 2021 at 4:43 AM Icenowy Zheng <icenowy@aosc.io>
> wrote:
> > 
> > 在 2021-01-20星期三的 11:20 +0100，Miklos Szeredi写道：
> > > On Tue, Jan 05, 2021 at 08:47:41AM +0200, Amir Goldstein wrote:
> > > > On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io>
> > > > wrote:
> > > > > 
> > > > > The function ovl_dir_real_file() currently uses the semaphore
> > > > > of
> > > > > the
> > > > > inode to synchronize write to the upperfile cache field.
> > > > 
> > > > Although the inode lock is a rw_sem it is referred to as the
> > > > "inode
> > > > lock"
> > > > and you also left semaphore in the commit subject.
> > > > No need to re-post. This can be fixed on commit.
> > > > 
> > > > > 
> > > > > However, this function will get called by
> > > > > ovl_ioctl_set_flags(),
> > > > > which
> > > > > utilizes the inode semaphore too. In this case
> > > > > ovl_dir_real_file() will
> > > > > try to claim a lock that is owned by a function in its call
> > > > > stack, which
> > > > > won't get released before ovl_dir_real_file() returns.
> > > > > 
> > > > > Define a dedicated semaphore for the upperfile cache, so that
> > > > > the
> > > > > deadlock won't happen.
> > > > > 
> > > > > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and
> > > > > FS[S|G]ETXATTR ioctls for directories")
> > > > > Cc: stable@vger.kernel.org # v5.10
> > > > > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > > > > ---
> > > > > Changes in v2:
> > > > > - Fixed missing replacement in error handling path.
> > > > > Changes in v3:
> > > > > - Use mutex instead of semaphore.
> > > > > 
> > > > >  fs/overlayfs/readdir.c | 10 +++++-----
> > > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > > > index 01620ebae1bd..3980f9982f34 100644
> > > > > --- a/fs/overlayfs/readdir.c
> > > > > +++ b/fs/overlayfs/readdir.c
> > > > > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> > > > >         struct list_head *cursor;
> > > > >         struct file *realfile;
> > > > >         struct file *upperfile;
> > > > > +       struct mutex upperfile_mutex;
> > > > 
> > > > That's a very specific name.
> > > > This mutex protects members of struct ovl_dir_file, which could
> > > > evolve
> > > > into struct ovl_file one day (because no reason to cache only
> > > > dir
> > > > upper file),
> > > > so I would go with a more generic name, but let's leave it to
> > > > Miklos to decide.
> > > > 
> > > > He could have a different idea altogether for fixing this bug.
> > > 
> > > How about this (untested) patch?
> > > 
> > > It's a cleanup as well as a fix, but maybe we should separate the
> > > cleanup from
> > > the fix...
> > 
> > If you are going to post this, feel free to add
> > 
> > Tested-by: Icenowy Zheng <icenowy@aosc.io>
> 
> Okay, thanks.
> 
> > (And if you remove the IS_ERR(realfile) part, the tested-by tag
> > still
> > applies.)
> 
> Dropping the IS_ERR(realfile) here would mean having to add the same
> check before relevant fput() calls, which would make it more complex
> not less.
> 
> Or did you mean something else?

I mean "seperate the cleanup from the fix".

This is only for when you do the seperation.

> 
> Thanks,
> Miklos

