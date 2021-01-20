Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43F82FCEBC
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbhATLCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732953AbhATKVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 05:21:30 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26E4C061575
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 02:20:49 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ox12so8451448ejb.2
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 02:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OFlx5d568EFpNe9zqZr0JFVr1l6hwq2H86uMHDeKgAU=;
        b=PaKorZz0uyZmvpKhqu2AmueiUhbr//g/JNsEnzOFJufa0fcuO9uxjW/v98mEqPZkkl
         xtxyL36Y8py3tJ91KkDfxkouAPZ1174zgkxeGJFFr729coYc1wLND9JOK1hVElqqYfYb
         jFSG5jqara+VXbGcTLs6Uu68kNWVEvQqss88w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OFlx5d568EFpNe9zqZr0JFVr1l6hwq2H86uMHDeKgAU=;
        b=c4ylDgH28DVld3U4JwjgwCdxgmNEm8dbNd8/xvs+4Fam4lEV3/IW40J0cjfqZv7P0Q
         waHGGUmD92LBswm7hPbfYNwGYRcG3ft1NA4+jnlIw9D4m5HKtyCFBOg9MM6DqtZDoysG
         xmOVpLUnh/LI5lAaN+DiqbigU0RuqkzNl5bZ/qlo4LAVuPV+THK74ZzlIDHOM7vUsY7P
         Tpl+7YZ7x7u/lgEBqqpq/DoYfz8/+CLwrfd09eAT5BjlhbZizcE6+uv0wxOTUA1tKTkv
         jzndJOS/LU2aiVInSg6HRT3OVMEHmj+Rggg7+DSK1QdLva7VNFbVOGzCMbycqmUxrLVp
         kasQ==
X-Gm-Message-State: AOAM532UWroluWgzMxR6w4ZGxKBH4j4KLns//2Pzu+Cxrb/8qxnGPaAU
        +s9OAhVNidLuvpp0pNw8VaPPAg==
X-Google-Smtp-Source: ABdhPJxrI8ym6Z6hQLOERyZmRX2Nfb8mT/4BqaIad4wret3urMAsxf0QrI4675iqmGySlz20R0D9+g==
X-Received: by 2002:a17:906:fcae:: with SMTP id qw14mr5454879ejb.245.1611138048464;
        Wed, 20 Jan 2021 02:20:48 -0800 (PST)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id c7sm838063edv.70.2021.01.20.02.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 02:20:47 -0800 (PST)
Date:   Wed, 20 Jan 2021 11:20:45 +0100
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile
 caching
Message-ID: <20210120102045.GD1236412@miu.piliscsaba.redhat.com>
References: <20210105003611.194511-1-icenowy@aosc.io>
 <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 08:47:41AM +0200, Amir Goldstein wrote:
> On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io> wrote:
> >
> > The function ovl_dir_real_file() currently uses the semaphore of the
> > inode to synchronize write to the upperfile cache field.
> 
> Although the inode lock is a rw_sem it is referred to as the "inode lock"
> and you also left semaphore in the commit subject.
> No need to re-post. This can be fixed on commit.
> 
> >
> > However, this function will get called by ovl_ioctl_set_flags(), which
> > utilizes the inode semaphore too. In this case ovl_dir_real_file() will
> > try to claim a lock that is owned by a function in its call stack, which
> > won't get released before ovl_dir_real_file() returns.
> >
> > Define a dedicated semaphore for the upperfile cache, so that the
> > deadlock won't happen.
> >
> > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories")
> > Cc: stable@vger.kernel.org # v5.10
> > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > ---
> > Changes in v2:
> > - Fixed missing replacement in error handling path.
> > Changes in v3:
> > - Use mutex instead of semaphore.
> >
> >  fs/overlayfs/readdir.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 01620ebae1bd..3980f9982f34 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> >         struct list_head *cursor;
> >         struct file *realfile;
> >         struct file *upperfile;
> > +       struct mutex upperfile_mutex;
> 
> That's a very specific name.
> This mutex protects members of struct ovl_dir_file, which could evolve
> into struct ovl_file one day (because no reason to cache only dir upper file),
> so I would go with a more generic name, but let's leave it to Miklos to decide.
> 
> He could have a different idea altogether for fixing this bug.

How about this (untested) patch?

It's a cleanup as well as a fix, but maybe we should separate the cleanup from
the fix...

Thanks,
Miklos
---

 fs/overlayfs/readdir.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -865,7 +865,7 @@ struct file *ovl_dir_real_file(const str
 
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
-	struct file *realfile = od->realfile;
+	struct file *old, *realfile = od->realfile;
 
 	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
 		return want_upper ? NULL : realfile;
@@ -874,29 +874,20 @@ struct file *ovl_dir_real_file(const str
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
 	if (!od->is_upper) {
-		struct inode *inode = file_inode(file);
-
 		realfile = READ_ONCE(od->upperfile);
 		if (!realfile) {
 			struct path upperpath;
 
 			ovl_path_upper(dentry, &upperpath);
 			realfile = ovl_dir_open_realfile(file, &upperpath);
+			if (IS_ERR(realfile))
+				return realfile;
 
-			inode_lock(inode);
-			if (!od->upperfile) {
-				if (IS_ERR(realfile)) {
-					inode_unlock(inode);
-					return realfile;
-				}
-				smp_store_release(&od->upperfile, realfile);
-			} else {
-				/* somebody has beaten us to it */
-				if (!IS_ERR(realfile))
-					fput(realfile);
-				realfile = od->upperfile;
+			old = cmpxchg_release(&od->upperfile, NULL, realfile);
+			if (old) {
+				fput(realfile);
+				realfile = old;
 			}
-			inode_unlock(inode);
 		}
 	}
 
