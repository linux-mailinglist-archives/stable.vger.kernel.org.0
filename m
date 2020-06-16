Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479F41FB0F2
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgFPMkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 08:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728489AbgFPMky (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 08:40:54 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175E6C08C5C3
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 05:40:53 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a21so19067815oic.8
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 05:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yRuEYGWYbCpgbt9WyvifXrnW7xoF05jSYdHgJjfemG4=;
        b=CFVl4b3RIYqk3FRdV+rogfziBje3cFPovLts/hRAcvgo3K7kfBpqVKQ0qGaQ4Fl1eK
         TTnbb+/CNR/h9GUaPp0AMkwc/xXfk1gQRbcW3xIszBscuzjOXp2DEGd8nTuovsQi3/iv
         J4y0PedCS7O0sKr1Y/0euYNNhtYXmrPdlpmByzTbLO1CjlSsSKgALBAXrSmiXmT4pksL
         n6Aj/ms2lrvMjyTKqYqOrFr4pawYIO0j0x8ohPs10SvNJ2gBZk/sfK+bhLB4CpcNZpFv
         8ZyzgvVLlvyOUnpORdott8eQTlCVe6KudWdtPSP0aR+qEquv4b0SUfQyeuXDrj1n9w47
         SJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yRuEYGWYbCpgbt9WyvifXrnW7xoF05jSYdHgJjfemG4=;
        b=nlmafPktZNs817AMfZOVjJCvlCyYH6wTrFdcL243u0HCK74+VMx4xafxIUYoUQGuhB
         KxMQHxTogdTcmCJmv3+grf+3iG6XHrNseNy7OXaK2UyhOmwo1ZbHYuFn5AF7MQvNZiKf
         wBvQnZgx+QQ0AuFwm8Ae+IYNMNHEr7c82Ud6fc7ep1azWg4OfBEuuLcZ2ROuedN9wxt2
         WGWHzlOfAEmQxdJjI1DpvsVkNgs39CwbuMDx5YHlhfP/WT1gWOWL9qwB+dbSWKs5tdhR
         FIvvkA/g2sAwcAVrIQfNX2l3hsjbEd+jXD67uJlPTlik8q7XxKNU6cl2O1HOTYBPwOvV
         Ll5A==
X-Gm-Message-State: AOAM532/PUoqWXZVbbP1fn0cyHoIXeQEsfx1Ww4cRUr2AZG2N8/fybCL
        SidlQ8EYnaoyFRv+imTNYWS3U64OK6IOOMMeLWofww==
X-Google-Smtp-Source: ABdhPJw1HIcntem/ur3nYuYQnYfdpeq3LaH9w6z+uVXnvPpWXi7NcZfGZ06MIquL/3rMm6i3W0PzTlBfRGVBUlNtAcQ=
X-Received: by 2002:a05:6808:a96:: with SMTP id q22mr3251821oij.76.1592311251656;
 Tue, 16 Jun 2020 05:40:51 -0700 (PDT)
MIME-Version: 1.0
References: <316a5cf9-ca71-6506-bf8b-e79ded9055b2@codeaurora.org>
In-Reply-To: <316a5cf9-ca71-6506-bf8b-e79ded9055b2@codeaurora.org>
From:   Sumit Semwal <sumit.semwal@linaro.org>
Date:   Tue, 16 Jun 2020 18:10:40 +0530
Message-ID: <CAO_48GEa2B+a8XbaqurvRPZswRQGWq82YqUr4uotvyQKjPQuFQ@mail.gmail.com>
Subject: Re: [PATCH] dmabuf: use spinlock to access dmabuf->name
To:     Charan Teja Kalla <charante@codeaurora.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, vinmenon@codeaurora.org,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel, Chris,

On Thu, 11 Jun 2020 at 19:10, Charan Teja Kalla <charante@codeaurora.org> wrote:
>
> There exists a sleep-while-atomic bug while accessing the dmabuf->name
> under mutex in the dmabuffs_dname(). This is caused from the SELinux
> permissions checks on a process where it tries to validate the inherited
> files from fork() by traversing them through iterate_fd() (which
> traverse files under spin_lock) and call
> match_file(security/selinux/hooks.c) where the permission checks happen.
> This audit information is logged using dump_common_audit_data() where it
> calls d_path() to get the file path name. If the file check happen on
> the dmabuf's fd, then it ends up in ->dmabuffs_dname() and use mutex to
> access dmabuf->name. The flow will be like below:
> flush_unauthorized_files()
>   iterate_fd()
>     spin_lock() --> Start of the atomic section.
>       match_file()
>         file_has_perm()
>           avc_has_perm()
>             avc_audit()
>               slow_avc_audit()
>                 common_lsm_audit()
>                   dump_common_audit_data()
>                     audit_log_d_path()
>                       d_path()
>                         dmabuffs_dname()
>                           mutex_lock()--> Sleep while atomic.
>
> Call trace captured (on 4.19 kernels) is below:
> ___might_sleep+0x204/0x208
> __might_sleep+0x50/0x88
> __mutex_lock_common+0x5c/0x1068
> __mutex_lock_common+0x5c/0x1068
> mutex_lock_nested+0x40/0x50
> dmabuffs_dname+0xa0/0x170
> d_path+0x84/0x290
> audit_log_d_path+0x74/0x130
> common_lsm_audit+0x334/0x6e8
> slow_avc_audit+0xb8/0xf8
> avc_has_perm+0x154/0x218
> file_has_perm+0x70/0x180
> match_file+0x60/0x78
> iterate_fd+0x128/0x168
> selinux_bprm_committing_creds+0x178/0x248
> security_bprm_committing_creds+0x30/0x48
> install_exec_creds+0x1c/0x68
> load_elf_binary+0x3a4/0x14e0
> search_binary_handler+0xb0/0x1e0
>
> So, use spinlock to access dmabuf->name to avoid sleep-while-atomic.
Any objections to this change? This changes protection only for
dmabuf->name field, but I'd request either of you to review it,
please?
>
> Cc: <stable@vger.kernel.org> [5.3+]
> Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
> ---
>  drivers/dma-buf/dma-buf.c | 13 +++++++------
>  include/linux/dma-buf.h   |  1 +
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 01ce125..2e0456c 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -45,10 +45,10 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
>         size_t ret = 0;
>
>         dmabuf = dentry->d_fsdata;
> -       dma_resv_lock(dmabuf->resv, NULL);
> +       spin_lock(&dmabuf->name_lock);
>         if (dmabuf->name)
>                 ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
> -       dma_resv_unlock(dmabuf->resv);
> +       spin_unlock(&dmabuf->name_lock);
>
>         return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
>                              dentry->d_name.name, ret > 0 ? name : "");
> @@ -335,7 +335,7 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
>         if (IS_ERR(name))
>                 return PTR_ERR(name);
>
> -       dma_resv_lock(dmabuf->resv, NULL);
> +       spin_lock(&dmabuf->name_lock);
>         if (!list_empty(&dmabuf->attachments)) {
>                 ret = -EBUSY;
>                 kfree(name);
> @@ -345,7 +345,7 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
>         dmabuf->name = name;
>
>  out_unlock:
> -       dma_resv_unlock(dmabuf->resv);
> +       spin_unlock(&dmabuf->name_lock);
>         return ret;
>  }
>
> @@ -405,10 +405,10 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
>         /* Don't count the temporary reference taken inside procfs seq_show */
>         seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
>         seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
> -       dma_resv_lock(dmabuf->resv, NULL);
> +       spin_lock(&dmabuf->name_lock);
>         if (dmabuf->name)
>                 seq_printf(m, "name:\t%s\n", dmabuf->name);
> -       dma_resv_unlock(dmabuf->resv);
> +       spin_unlock(&dmabuf->name_lock);
>  }
>
>  static const struct file_operations dma_buf_fops = {
> @@ -546,6 +546,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>         dmabuf->size = exp_info->size;
>         dmabuf->exp_name = exp_info->exp_name;
>         dmabuf->owner = exp_info->owner;
> +       spin_lock_init(&dmabuf->name_lock);
>         init_waitqueue_head(&dmabuf->poll);
>         dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
>         dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index ab0c156..93108fd 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -311,6 +311,7 @@ struct dma_buf {
>         void *vmap_ptr;
>         const char *exp_name;
>         const char *name;
> +       spinlock_t name_lock;
>         struct module *owner;
>         struct list_head list_node;
>         void *priv;
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

Best,
Sumit.
