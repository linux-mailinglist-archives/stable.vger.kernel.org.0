Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305EE1D19C7
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgEMPq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 11:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgEMPq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 11:46:57 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D1DC061A0E
        for <stable@vger.kernel.org>; Wed, 13 May 2020 08:46:57 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l18so21471684wrn.6
        for <stable@vger.kernel.org>; Wed, 13 May 2020 08:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=kC/Wx5fDOrFA5V1TSUixxtmSIDDSd8BbVGT5BWnbRLM=;
        b=dAMtO8jQD+Ai7SeyseP4v3EFTC2agTgJgukJDbFISow3JiC4+kE0+Upo/+G/vtUaup
         z0jHsmd1c4EI8nM6pZ+oTxxet6V4uMuelqKH4SSJGk5naOmH6ASqvGxH32CpP6GRkres
         F/Dw60q3SwetZ9pGZpJYPtTkJvV6KqDZ7EbL4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=kC/Wx5fDOrFA5V1TSUixxtmSIDDSd8BbVGT5BWnbRLM=;
        b=d89UikeCP+uMu06+kp+08SGOBJIjLwxMdhUqz4v1VoNWbj/51ZjDXYYvyUetxsr/Px
         c7gPJebSAEUFlAOJGXL8DZY4O/7oFs/UPvZV5ml61xp4/Skc1WB/PRsZCadnOppTjsQD
         ECCEO4XToAbo3OUMZdmpfWTq7rQW3Qmc9XLSZEu+WQ8QlQvTSgCIhoOBvlLe3QxrEa+j
         ufAyPhVy0dGHgIjluDgXhjv3SwYN6GILc5iGvq7H1mOnEBRumKHugxlhBhiVcZtmU86M
         crro02cbWiIzVpM0+1k2Gg4WkcD4Z1kg2uMXK4mqlwwIieUt71Y2zPIsPyEoxS3I93DT
         fgzQ==
X-Gm-Message-State: AGi0PubMX4rX8beUeTUP+GG3/nA5CMXbujvOTcaLktyO+WKARTSosXya
        pnENDcjrO0InrvUGfmr5vAvK5w==
X-Google-Smtp-Source: APiQypK41W1FEz5rgWALE5Md3INO+YCZ+8cKSmS/VxwlX6x4xSY/wGBizAJVuaBQsZtsneI0jS3mBA==
X-Received: by 2002:a05:6000:47:: with SMTP id k7mr23651194wrx.233.1589384816191;
        Wed, 13 May 2020 08:46:56 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id v205sm18901272wmg.11.2020.05.13.08.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 08:46:55 -0700 (PDT)
Date:   Wed, 13 May 2020 17:46:53 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg KH <greg@kroah.com>
Cc:     Charan Teja Kalla <charante@codeaurora.org>, fengc@google.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, vinmenon@codeaurora.org,
        ghackmann@google.com, stable@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] dma-buf: fix use-after-free in dmabuffs_dname
Message-ID: <20200513154653.GK206103@phenom.ffwll.local>
Mail-Followup-To: Greg KH <greg@kroah.com>,
        Charan Teja Kalla <charante@codeaurora.org>, fengc@google.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, vinmenon@codeaurora.org,
        ghackmann@google.com, stable@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
 <20200512085221.GB3557007@kroah.com>
 <a3cbf675-becc-1713-bcdc-664ddfe4a544@codeaurora.org>
 <20200513125112.GC1083139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513125112.GC1083139@kroah.com>
X-Operating-System: Linux phenom 5.6.0-1-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 02:51:12PM +0200, Greg KH wrote:
> On Wed, May 13, 2020 at 05:40:26PM +0530, Charan Teja Kalla wrote:
> > 
> > Thank you Greg for the comments.
> > On 5/12/2020 2:22 PM, Greg KH wrote:
> > > On Fri, May 08, 2020 at 12:11:03PM +0530, Charan Teja Reddy wrote:
> > >> The following race occurs while accessing the dmabuf object exported as
> > >> file:
> > >> P1				P2
> > >> dma_buf_release()          dmabuffs_dname()
> > >> 			   [say lsof reading /proc/<P1 pid>/fd/<num>]
> > >>
> > >> 			   read dmabuf stored in dentry->d_fsdata
> > >> Free the dmabuf object
> > >> 			   Start accessing the dmabuf structure
> > >>
> > >> In the above description, the dmabuf object freed in P1 is being
> > >> accessed from P2 which is resulting into the use-after-free. Below is
> > >> the dump stack reported.
> > >>
> > >> We are reading the dmabuf object stored in the dentry->d_fsdata but
> > >> there is no binding between the dentry and the dmabuf which means that
> > >> the dmabuf can be freed while it is being read from ->d_fsdata and
> > >> inuse. Reviews on the patch V1 says that protecting the dmabuf inuse
> > >> with an extra refcount is not a viable solution as the exported dmabuf
> > >> is already under file's refcount and keeping the multiple refcounts on
> > >> the same object coordinated is not possible.
> > >>
> > >> As we are reading the dmabuf in ->d_fsdata just to get the user passed
> > >> name, we can directly store the name in d_fsdata thus can avoid the
> > >> reading of dmabuf altogether.
> > >>
> > >> Call Trace:
> > >>  kasan_report+0x12/0x20
> > >>  __asan_report_load8_noabort+0x14/0x20
> > >>  dmabuffs_dname+0x4f4/0x560
> > >>  tomoyo_realpath_from_path+0x165/0x660
> > >>  tomoyo_get_realpath
> > >>  tomoyo_check_open_permission+0x2a3/0x3e0
> > >>  tomoyo_file_open
> > >>  tomoyo_file_open+0xa9/0xd0
> > >>  security_file_open+0x71/0x300
> > >>  do_dentry_open+0x37a/0x1380
> > >>  vfs_open+0xa0/0xd0
> > >>  path_openat+0x12ee/0x3490
> > >>  do_filp_open+0x192/0x260
> > >>  do_sys_openat2+0x5eb/0x7e0
> > >>  do_sys_open+0xf2/0x180
> > >>
> > >> Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
> > >> Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
> > >> Cc: <stable@vger.kernel.org> [5.3+]
> > >> Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
> > >> ---
> > >>
> > >> Changes in v2: 
> > >>
> > >> - Pass the user passed name in ->d_fsdata instead of dmabuf
> > >> - Improve the commit message
> > >>
> > >> Changes in v1: (https://patchwork.kernel.org/patch/11514063/)
> > >>
> > >>  drivers/dma-buf/dma-buf.c | 17 ++++++++++-------
> > >>  1 file changed, 10 insertions(+), 7 deletions(-)
> > >>
> > >> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > >> index 01ce125..0071f7d 100644
> > >> --- a/drivers/dma-buf/dma-buf.c
> > >> +++ b/drivers/dma-buf/dma-buf.c
> > >> @@ -25,6 +25,7 @@
> > >>  #include <linux/mm.h>
> > >>  #include <linux/mount.h>
> > >>  #include <linux/pseudo_fs.h>
> > >> +#include <linux/dcache.h>
> > >>  
> > >>  #include <uapi/linux/dma-buf.h>
> > >>  #include <uapi/linux/magic.h>
> > >> @@ -40,15 +41,13 @@ struct dma_buf_list {
> > >>  
> > >>  static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
> > >>  {
> > >> -	struct dma_buf *dmabuf;
> > >>  	char name[DMA_BUF_NAME_LEN];
> > >>  	size_t ret = 0;
> > >>  
> > >> -	dmabuf = dentry->d_fsdata;
> > >> -	dma_resv_lock(dmabuf->resv, NULL);
> > >> -	if (dmabuf->name)
> > >> -		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
> > >> -	dma_resv_unlock(dmabuf->resv);
> > >> +	spin_lock(&dentry->d_lock);
> > > 
> > > Are you sure this lock always protects d_fsdata?
> > 
> > I think yes. In the dma-buf.c, I have to make sure that d_fsdata should
> > always be under d_lock thus it will be protected. (In this posted patch
> > there is one place(in dma_buf_set_name) that is missed, will update this
> > in V3).
> > 
> > > 
> > >> +	if (dentry->d_fsdata)
> > >> +		ret = strlcpy(name, dentry->d_fsdata, DMA_BUF_NAME_LEN);
> > >> +	spin_unlock(&dentry->d_lock);
> > >>  
> > >>  	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
> > >>  			     dentry->d_name.name, ret > 0 ? name : "");
> > > 
> > > If the above check fails the name will be what?  How could d_name.name
> > > be valid but d_fsdata not be valid?
> > 
> > In case of check fails, empty string "" is appended to the name by the
> > code, ret > 0 ? name : "", ret is initialized to zero. Thus the name
> > string will be like "/dmabuf:".
> 
> So multiple objects can have the same "name" if this happens to multiple
> ones at once?
> 
> > Regarding the validity of d_fsdata, we are setting the dmabuf's
> > dentry->d_fsdata to NULL in the dma_buf_release() thus can go invalid if
> > that dmabuf is in the free path.
> 
> Why are we allowing the name to be set if the dmabuf is on the free path
> at all?  Shouldn't that be the real fix here?
> 
> > >> @@ -80,12 +79,16 @@ static int dma_buf_fs_init_context(struct fs_context *fc)
> > >>  static int dma_buf_release(struct inode *inode, struct file *file)
> > >>  {
> > >>  	struct dma_buf *dmabuf;
> > >> +	struct dentry *dentry = file->f_path.dentry;
> > >>  
> > >>  	if (!is_dma_buf_file(file))
> > >>  		return -EINVAL;
> > >>  
> > >>  	dmabuf = file->private_data;
> > >>  
> > >> +	spin_lock(&dentry->d_lock);
> > >> +	dentry->d_fsdata = NULL;
> > >> +	spin_unlock(&dentry->d_lock);
> > >>  	BUG_ON(dmabuf->vmapping_counter);
> > >>  
> > >>  	/*
> > >> @@ -343,6 +346,7 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
> > >>  	}
> > >>  	kfree(dmabuf->name);
> > >>  	dmabuf->name = name;
> > >> +	dmabuf->file->f_path.dentry->d_fsdata = name;
> > > 
> > > You are just changing the use of d_fsdata from being a pointer to the
> > > dmabuf to being a pointer to the name string?  What's to keep that name
> > > string around and not have the same reference counting issues that the
> > > dmabuf structure itself has?  Who frees that string memory?
> > > 
> > 
> > Yes, I am just storing the name string in the d_fsdata in place of
> > dmabuf and this helps to get rid of any extra refcount requirement.
> > Because the user passed name carried in the d_fsdata is copied to the
> > local buffer in dmabuffs_dname under spin_lock(d_lock) and the same
> > d_fsdata is set to NULL(under the d_lock only) when that dmabuf is in
> > the release path. So, when d_fsdata is NULL, name string is not accessed
> > from the dmabuffs_dname thus extra count is not required.
> > 
> > String memory, stored in the dmabuf->name, is released from the
> > dma_buf_release(). Flow will be like, It fist sets d_fsdata=NULL and
> > then free the dmabuf->name.
> > 
> > However from your comments I have realized that there is a race in this
> > patch when using the name string between dma_buf_set_name() and
> > dmabuffs_dname(). But, If the idea of passing the name string inplace of
> > dmabuf in d_fsdata looks fine, I can update this next patch.
> 
> I'll leave that to the dmabuf authors/maintainers, but it feels odd to
> me...

I have zero clue about fs internals. This all scares me, that's all. I
know enough about lifetime bugs that if you don't deeply understand a
subsystem, all that's guaranteed is that you will get it wrong.

/me out

Cheers, Daniel

> 
> thanks,
> 
> greg k-h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
