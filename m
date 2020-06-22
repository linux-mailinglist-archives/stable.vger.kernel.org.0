Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15699203384
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgFVJfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 05:35:25 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:40337 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbgFVJfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 05:35:24 -0400
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id nIrGj0VKQn3JWnIrKjZQ0s; Mon, 22 Jun 2020 11:35:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1592818522; bh=aHepb5XOZCgP9XmyTmu3hY4Vg2K7tQSxxdSCpd2tK1o=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=ROENSS6sL2rRbfprROMfPWw0mWNlF7qh0MH/8X5JerxkLMXVzFGeAC98a0p68QiP6
         DzvQCE5PdGc1Jl9VBdeAjYAYzaebgMFJ/QTe0dUrJ0+ZMdA5EFz87f2pjwkbSBMSe8
         W2+IAampJ07ug4I04iK5pqOf45IB81mw4qCioaOgqfkndT6E97GOHBADakOkn08v3K
         p5cvbx63cszOrcOAZC0Scq4bKudOQ7PqqiqaD83C/13gYb0gfVMvVR7kqYmoXQboYp
         B7bKmBd/CFxTvMMEv24sdjZg3yE0h+3ExGTA8oS/n+J4paHfeHrdkgM5UHnf1LAGzC
         yXIz8ekt+nMjw==
Subject: Re: [PATCH] media: media-request: Fix crash if memory allocation
 fails
To:     Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>, mchehab@kernel.org
Cc:     laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200621113040.3540-1-tuomas.tynkkynen@iki.fi>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <06559806-3191-2e98-03d7-3ccfa8b7257c@xs4all.nl>
Date:   Mon, 22 Jun 2020 11:35:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200621113040.3540-1-tuomas.tynkkynen@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFPEoWu6Fmha/9LMpKrWqjzT7+cRI6e9lWSeV9HIcLklVVUbQw0/TYUNspp/cN8C1R+g7pznVu/l9wqBdp7xrUYGmtS7fXkGR9KvYC6jsEKpjzfenL+I
 +/1mcy9FmCf73EJBtmO9Y2ys8AfOrS4WpRul1EDJktqrhJjTmzS6rTu7C/X9Sxh4v2IJAm14Y9OlCW9KGvdE5RSv1pSp4saNq72OcuGBdYOq6OXHqDJkYkAr
 n2bQuk8KUS2KH9S+MkH70eNkw6ckAn0B2fLND9DDn/dFjm2G4lFgLTfyplGSLznw+rN/p9+jIqnHHYUXqx00WHzqTyL+O+dR9O9TF5XOvRxQkAFZoGU582lc
 jVOV1qPjpUMOUqGcUVvI8Aqgx5/+oaO+LhJQXL4SQ3rzeNZs/ffhoNailN0pVZkcOypJnh7N
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/06/2020 13:30, Tuomas Tynkkynen wrote:
> Syzbot reports a NULL-ptr deref in the kref_put() call:
> 
> BUG: KASAN: null-ptr-deref in media_request_put drivers/media/mc/mc-request.c:81 [inline]
>  kref_put include/linux/kref.h:64 [inline]
>  media_request_put drivers/media/mc/mc-request.c:81 [inline]
>  media_request_close+0x4d/0x170 drivers/media/mc/mc-request.c:89
>  __fput+0x2ed/0x750 fs/file_table.c:281
>  task_work_run+0x147/0x1d0 kernel/task_work.c:123
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_usermode_loop arch/x86/entry/common.c:165 [inline]
>  prepare_exit_to_usermode+0x48e/0x600 arch/x86/entry/common.c:196
> 
> What led to this crash was an injected memory allocation failure in
> media_request_alloc():
> 
> FAULT_INJECTION: forcing a failure.
> name failslab, interval 1, probability 0, space 0, times 0
>  should_failslab+0x5/0x20
>  kmem_cache_alloc_trace+0x57/0x300
>  ? anon_inode_getfile+0xe5/0x170
>  media_request_alloc+0x339/0x440
>  media_device_request_alloc+0x94/0xc0
>  media_device_ioctl+0x1fb/0x330
>  ? do_vfs_ioctl+0x6ea/0x1a00
>  ? media_ioctl+0x101/0x120
>  ? __media_device_usb_init+0x430/0x430
>  ? media_poll+0x110/0x110
>  __se_sys_ioctl+0xf9/0x160
>  do_syscall_64+0xf3/0x1b0
> 
> When that allocation fails, filp->private_data is left uninitialized
> which media_request_close() does not expect and crashes.
> 
> To avoid this, reorder media_request_alloc() such that
> allocating the struct file happens as the last step thus
> media_request_close() will no longer get called for a partially created
> media request.
> 
> Reported-by: syzbot+6bed2d543cf7e48b822b@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans

> ---
>  drivers/media/mc/mc-request.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/mc/mc-request.c b/drivers/media/mc/mc-request.c
> index e3fca436c75b..c0782fd96c59 100644
> --- a/drivers/media/mc/mc-request.c
> +++ b/drivers/media/mc/mc-request.c
> @@ -296,9 +296,18 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
>  	if (WARN_ON(!mdev->ops->req_alloc ^ !mdev->ops->req_free))
>  		return -ENOMEM;
>  
> +	if (mdev->ops->req_alloc)
> +		req = mdev->ops->req_alloc(mdev);
> +	else
> +		req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
> +
>  	fd = get_unused_fd_flags(O_CLOEXEC);
> -	if (fd < 0)
> -		return fd;
> +	if (fd < 0) {
> +		ret = fd;
> +		goto err_free_req;
> +	}
>  
>  	filp = anon_inode_getfile("request", &request_fops, NULL, O_CLOEXEC);
>  	if (IS_ERR(filp)) {
> @@ -306,15 +315,6 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
>  		goto err_put_fd;
>  	}
>  
> -	if (mdev->ops->req_alloc)
> -		req = mdev->ops->req_alloc(mdev);
> -	else
> -		req = kzalloc(sizeof(*req), GFP_KERNEL);
> -	if (!req) {
> -		ret = -ENOMEM;
> -		goto err_fput;
> -	}
> -
>  	filp->private_data = req;
>  	req->mdev = mdev;
>  	req->state = MEDIA_REQUEST_STATE_IDLE;
> @@ -336,12 +336,15 @@ int media_request_alloc(struct media_device *mdev, int *alloc_fd)
>  
>  	return 0;
>  
> -err_fput:
> -	fput(filp);
> -
>  err_put_fd:
>  	put_unused_fd(fd);
>  
> +err_free_req:
> +	if (mdev->ops->req_free)
> +		mdev->ops->req_free(req);
> +	else
> +		kfree(req);
> +
>  	return ret;
>  }
>  
> 

