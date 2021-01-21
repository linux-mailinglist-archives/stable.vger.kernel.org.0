Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5752FE177
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 06:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbhAUFTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 00:19:07 -0500
Received: from relay5.mymailcheap.com ([159.100.241.64]:33380 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388068AbhAUDuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 22:50:21 -0500
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.102])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 951F1200FE;
        Thu, 21 Jan 2021 03:49:26 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id 9BBC53F157;
        Thu, 21 Jan 2021 03:43:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 7D2482A17D;
        Wed, 20 Jan 2021 22:43:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1611200602;
        bh=3+s0yTdz2/e6zrgdoSmiyFqE7ryRDzPPZVDPvSpSv94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=quUMjqB+pBLzoJTLgOUbOEtkxQQVRNETFX+lKYH0cRfgedz/XT+6hKqsQDN0NAFTS
         q1RzHjCm43TsXIhzdQGVvelMY6txjzhcSZbdOMY54ILWRHU9ZTZ1qk/9w4/dfyRIeu
         gLG3hZULRu0AFGhA+VJYO4ny98VBDzV6bABRSLwM=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LZthJGfw6W_w; Wed, 20 Jan 2021 22:43:21 -0500 (EST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Wed, 20 Jan 2021 22:43:21 -0500 (EST)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 0E58140AF8;
        Thu, 21 Jan 2021 03:43:20 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="O9/n28UZ";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from ice-e5v2.lan (unknown [59.41.163.171])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 7727841EC2;
        Thu, 21 Jan 2021 03:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1611200594; bh=3+s0yTdz2/e6zrgdoSmiyFqE7ryRDzPPZVDPvSpSv94=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O9/n28UZCaOdJ4OmatRGyijpVcRjMZ8jU/MiYVGdKGEUYD9/441xbNCc9Ioht7B5a
         tyYl6eB9eQJ4d3iobxo6orCqzwJgWjXPyma/5/Ant2lJBaiIn1XT1Jhh+0XKEqKD5B
         SIGG28WCPvANvEPmAQ6adn+LLION7evclUrm2hK0=
Message-ID: <83bb613212ee81648e5bf7c0f9cd3219e0046f80.camel@aosc.io>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile
 caching
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date:   Thu, 21 Jan 2021 11:43:07 +0800
In-Reply-To: <20210120102045.GD1236412@miu.piliscsaba.redhat.com>
References: <20210105003611.194511-1-icenowy@aosc.io>
         <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
         <20210120102045.GD1236412@miu.piliscsaba.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.163.171:received];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[6];
         ML_SERVERS(-3.10)[213.133.102.83];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[aosc.io:+];
         FREEMAIL_TO(0.00)[szeredi.hu,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Queue-Id: 0E58140AF8
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021-01-20星期三的 11:20 +0100，Miklos Szeredi写道：
> On Tue, Jan 05, 2021 at 08:47:41AM +0200, Amir Goldstein wrote:
> > On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io>
> > wrote:
> > > 
> > > The function ovl_dir_real_file() currently uses the semaphore of
> > > the
> > > inode to synchronize write to the upperfile cache field.
> > 
> > Although the inode lock is a rw_sem it is referred to as the "inode
> > lock"
> > and you also left semaphore in the commit subject.
> > No need to re-post. This can be fixed on commit.
> > 
> > > 
> > > However, this function will get called by ovl_ioctl_set_flags(),
> > > which
> > > utilizes the inode semaphore too. In this case
> > > ovl_dir_real_file() will
> > > try to claim a lock that is owned by a function in its call
> > > stack, which
> > > won't get released before ovl_dir_real_file() returns.
> > > 
> > > Define a dedicated semaphore for the upperfile cache, so that the
> > > deadlock won't happen.
> > > 
> > > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and
> > > FS[S|G]ETXATTR ioctls for directories")
> > > Cc: stable@vger.kernel.org # v5.10
> > > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > > ---
> > > Changes in v2:
> > > - Fixed missing replacement in error handling path.
> > > Changes in v3:
> > > - Use mutex instead of semaphore.
> > > 
> > >  fs/overlayfs/readdir.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index 01620ebae1bd..3980f9982f34 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> > >         struct list_head *cursor;
> > >         struct file *realfile;
> > >         struct file *upperfile;
> > > +       struct mutex upperfile_mutex;
> > 
> > That's a very specific name.
> > This mutex protects members of struct ovl_dir_file, which could
> > evolve
> > into struct ovl_file one day (because no reason to cache only dir
> > upper file),
> > so I would go with a more generic name, but let's leave it to
> > Miklos to decide.
> > 
> > He could have a different idea altogether for fixing this bug.
> 
> How about this (untested) patch?
> 
> It's a cleanup as well as a fix, but maybe we should separate the
> cleanup from
> the fix...

If you are going to post this, feel free to add

Tested-by: Icenowy Zheng <icenowy@aosc.io>

(And if you remove the IS_ERR(realfile) part, the tested-by tag still
applies.)

> 
> Thanks,
> Miklos
> ---
> 
>  fs/overlayfs/readdir.c |   23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -865,7 +865,7 @@ struct file *ovl_dir_real_file(const str
>  
>         struct ovl_dir_file *od = file->private_data;
>         struct dentry *dentry = file->f_path.dentry;
> -       struct file *realfile = od->realfile;
> +       struct file *old, *realfile = od->realfile;
>  
>         if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
>                 return want_upper ? NULL : realfile;
> @@ -874,29 +874,20 @@ struct file *ovl_dir_real_file(const str
>          * Need to check if we started out being a lower dir, but got
> copied up
>          */
>         if (!od->is_upper) {
> -               struct inode *inode = file_inode(file);
> -
>                 realfile = READ_ONCE(od->upperfile);
>                 if (!realfile) {
>                         struct path upperpath;
>  
>                         ovl_path_upper(dentry, &upperpath);
>                         realfile = ovl_dir_open_realfile(file,
> &upperpath);
> +                       if (IS_ERR(realfile))
> +                               return realfile;
>  
> -                       inode_lock(inode);
> -                       if (!od->upperfile) {
> -                               if (IS_ERR(realfile)) {
> -                                       inode_unlock(inode);
> -                                       return realfile;
> -                               }
> -                               smp_store_release(&od->upperfile,
> realfile);
> -                       } else {
> -                               /* somebody has beaten us to it */
> -                               if (!IS_ERR(realfile))
> -                                       fput(realfile);
> -                               realfile = od->upperfile;
> +                       old = cmpxchg_release(&od->upperfile, NULL,
> realfile);
> +                       if (old) {
> +                               fput(realfile);
> +                               realfile = old;
>                         }
> -                       inode_unlock(inode);
>                 }
>         }
>  

