Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C791FB0FC
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgFPMm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 08:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPMmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 08:42:25 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19964C08C5C3
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 05:42:25 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id d4so1396406otk.2
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 05:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q13V/CJ4C0CyeaU3PQKnFBowYarfzkVCYNjXfCo/M1g=;
        b=WWDe74GX3eV9epE3ig+bqnOkHDawoFwWRSShn5mcl7Dye5ohesVAu0q4F8rVGjEhLZ
         JN6AlrPmz3owghYEzUlSpgWZzQl0v1IqN3WTfmQv9bdrsaLyKsAxc29Yp8ptZCwnB0y4
         4CSM40Uw2c/HcQuFvkL9qVj52iJTTP45/8XfXv+lEEffujS0YwQMtP8L3jZ5XnaWv4R3
         Drf1Tw9CF7jvkz9G+z5SqBY+pp3giX38K6S/gELzGMRgZMDW5AAYTXyl6lIYg5cnP0Rm
         tzak88/KUjE5utQzbQEEbTrCUTFoJ4As3bEGi0Bh3yZrB2fnIAsIl201PhAiHgz5nqeS
         +ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q13V/CJ4C0CyeaU3PQKnFBowYarfzkVCYNjXfCo/M1g=;
        b=KPBMNkd08tK2BoLY27/CorLWJsYlcyyYt4F3BKucS3z7rCRx2tngEeGUBvdu56uIbv
         FRmbN0Xos1JJ9WwXAp6QJhNXD5yMloWn2Ai8aSwgGu3UcJiPDGThDX26BhG4w83mzpto
         bQspHJLGf6OSjomInIK1U8dnI9JXd0ssr90V/3y2BIWNxcRTpSm43s8K6XAG2C9kbI1m
         +SyWPAoHsngpq04k1yCyz2jewnd9NwpuESIqtAaZ4bbWCphcrtTguoL0M27/9vvVto7q
         CmviSbk8gTzypBbKflc3TgptNPNRbDo5u2kn0U49sh98y4QoWs01SdshkZlHT7xGe3NB
         1wuA==
X-Gm-Message-State: AOAM533BLtwsi+WbzmxX4v/R6MnFXP+MsoDaddmJ8Ucnk+BZzhZIpq+a
        b85uUvDYAEIwUA6hF7XowxaJt2W7jUWbmOWsVvtzhA==
X-Google-Smtp-Source: ABdhPJzhAV2LivvUc5lRUH69PwIWyJxi2VmbDvUnvq3A5eHKpR9ycJLgvoVE/+1vvl1sKwZOwieTyzQkoxH+C6slI3k=
X-Received: by 2002:a9d:6a85:: with SMTP id l5mr1098400otq.371.1592311344349;
 Tue, 16 Jun 2020 05:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200611114418.19852-1-sumit.semwal@linaro.org>
In-Reply-To: <20200611114418.19852-1-sumit.semwal@linaro.org>
From:   Sumit Semwal <sumit.semwal@linaro.org>
Date:   Tue, 16 Jun 2020 18:12:13 +0530
Message-ID: <CAO_48GFVYOv8Km7fEh8iBPp7d5ziySBV0vB9nu_+oset6hBO8w@mail.gmail.com>
Subject: Re: [PATCH v2] dma-buf: Move dma_buf_release() from fops to dentry_ops
To:     "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Chenbo Feng <fengc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        Charan Teja Reddy <charante@codeaurora.org>,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        "# 3.4.x" <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

If there are no objections to this, I will plan to merge it soon.

Daniel, Chris, Chenbo?

On Thu, 11 Jun 2020 at 17:14, Sumit Semwal <sumit.semwal@linaro.org> wrote:
>
> Charan Teja reported a 'use-after-free' in dmabuffs_dname [1], which
> happens if the dma_buf_release() is called while the userspace is
> accessing the dma_buf pseudo fs's dmabuffs_dname() in another process,
> and dma_buf_release() releases the dmabuf object when the last reference
> to the struct file goes away.
>
> I discussed with Arnd Bergmann, and he suggested that rather than tying
> the dma_buf_release() to the file_operations' release(), we can tie it to
> the dentry_operations' d_release(), which will be called when the last ref
> to the dentry is removed.
>
> The path exercised by __fput() calls f_op->release() first, and then calls
> dput, which eventually calls d_op->d_release().
>
> In the 'normal' case, when no userspace access is happening via dma_buf
> pseudo fs, there should be exactly one fd, file, dentry and inode, so
> closing the fd will kill of everything right away.
>
> In the presented case, the dentry's d_release() will be called only when
> the dentry's last ref is released.
>
> Therefore, lets move dma_buf_release() from fops->release() to
> d_ops->d_release()
>
> Many thanks to Arnd for his FS insights :)
>
> [1]: https://lore.kernel.org/patchwork/patch/1238278/
>
> Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
> Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> [5.3+]
> Cc: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Charan Teja Reddy <charante@codeaurora.org>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>
> ---
> v2: per Arnd: Moved dma_buf_release() above to avoid forward declaration;
>      removed dentry_ops check.
> ---
>  drivers/dma-buf/dma-buf.c | 54 ++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 01ce125f8e8d..412629601ad3 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -54,37 +54,11 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
>                              dentry->d_name.name, ret > 0 ? name : "");
>  }
>
> -static const struct dentry_operations dma_buf_dentry_ops = {
> -       .d_dname = dmabuffs_dname,
> -};
> -
> -static struct vfsmount *dma_buf_mnt;
> -
> -static int dma_buf_fs_init_context(struct fs_context *fc)
> -{
> -       struct pseudo_fs_context *ctx;
> -
> -       ctx = init_pseudo(fc, DMA_BUF_MAGIC);
> -       if (!ctx)
> -               return -ENOMEM;
> -       ctx->dops = &dma_buf_dentry_ops;
> -       return 0;
> -}
> -
> -static struct file_system_type dma_buf_fs_type = {
> -       .name = "dmabuf",
> -       .init_fs_context = dma_buf_fs_init_context,
> -       .kill_sb = kill_anon_super,
> -};
> -
> -static int dma_buf_release(struct inode *inode, struct file *file)
> +static void dma_buf_release(struct dentry *dentry)
>  {
>         struct dma_buf *dmabuf;
>
> -       if (!is_dma_buf_file(file))
> -               return -EINVAL;
> -
> -       dmabuf = file->private_data;
> +       dmabuf = dentry->d_fsdata;
>
>         BUG_ON(dmabuf->vmapping_counter);
>
> @@ -110,9 +84,32 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>         module_put(dmabuf->owner);
>         kfree(dmabuf->name);
>         kfree(dmabuf);
> +}
> +
> +static const struct dentry_operations dma_buf_dentry_ops = {
> +       .d_dname = dmabuffs_dname,
> +       .d_release = dma_buf_release,
> +};
> +
> +static struct vfsmount *dma_buf_mnt;
> +
> +static int dma_buf_fs_init_context(struct fs_context *fc)
> +{
> +       struct pseudo_fs_context *ctx;
> +
> +       ctx = init_pseudo(fc, DMA_BUF_MAGIC);
> +       if (!ctx)
> +               return -ENOMEM;
> +       ctx->dops = &dma_buf_dentry_ops;
>         return 0;
>  }
>
> +static struct file_system_type dma_buf_fs_type = {
> +       .name = "dmabuf",
> +       .init_fs_context = dma_buf_fs_init_context,
> +       .kill_sb = kill_anon_super,
> +};
> +
>  static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
>  {
>         struct dma_buf *dmabuf;
> @@ -412,7 +409,6 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
>  }
>
>  static const struct file_operations dma_buf_fops = {
> -       .release        = dma_buf_release,
>         .mmap           = dma_buf_mmap_internal,
>         .llseek         = dma_buf_llseek,
>         .poll           = dma_buf_poll,
> --
> 2.27.0
>

Best,
Sumit.
