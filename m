Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E851B1F5112
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 11:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgFJJ1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 05:27:14 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56809 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgFJJ1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 05:27:14 -0400
Received: from mail-qv1-f44.google.com ([209.85.219.44]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MBUyX-1jeF6W2B4R-00Cvz2; Wed, 10 Jun 2020 11:27:11 +0200
Received: by mail-qv1-f44.google.com with SMTP id ec10so712608qvb.5;
        Wed, 10 Jun 2020 02:27:11 -0700 (PDT)
X-Gm-Message-State: AOAM533/O/ROVS3ob1Ld997sj6V/4FCWUVgXa9pb+8LhpfAEEgE9ys5l
        f+Am1dGBbhGpuSUnr0wGs7XZtz3LXcxbDHO1c50=
X-Google-Smtp-Source: ABdhPJxyWtH9LofwEdTYxXzu1ldBiowqiR86mkHaGO4qq++n7gDHop60yxQeWpkgQAbZwvP05ibJC+11h2MwvKlB+/o=
X-Received: by 2002:a05:6214:846:: with SMTP id dg6mr2067587qvb.210.1591781230032;
 Wed, 10 Jun 2020 02:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200610083333.455-1-sumit.semwal@linaro.org>
In-Reply-To: <20200610083333.455-1-sumit.semwal@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 10 Jun 2020 11:26:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0PzmtWc1p-KgHzHhY+=gca0J8YsGD=ALGESWsgijQQ7w@mail.gmail.com>
Message-ID: <CAK8P3a0PzmtWc1p-KgHzHhY+=gca0J8YsGD=ALGESWsgijQQ7w@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Move dma_buf_release() from fops to dentry_ops
To:     Sumit Semwal <sumit.semwal@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chenbo Feng <fengc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-mm-sig@lists.linaro.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:4KN5z80BV4ZSYGD0r4ZJ1xhRvF6rNz4GWsh1vKT87FfSqkxdz1z
 lvdlx/VXv0nPAvhF2ezZ5SVVlk7hWd4T16B9jUnYYgPrDlj8c3hZt6aFCUF4uEHBm3rGbQy
 y8uUxG1Exr0XON0fuZWhe4Z+bugiEEEDIT1mYIBV/wvPzeKvZZc7KptuOmzmDrkYpQ3yMQg
 glUzEvAv6WhhbX9IYETQA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5QuMWLLE2XQ=:KiybF5yfbBVTge3bNZ1H5O
 5cyNKx2tDt29s4nkbkmno0eAPBJKhAcliQtgcWeuNZ9dByBhXObim7dGifMy/9EZmGOao569M
 uXrZk06TkrDbZPJPaLSjry8DNoX/93EMxWPywCq4OrP9JfFJ2Jp7+RnHOPniByLkk+83aEkpb
 8JGsHn4QQqR5x+0mGImScGJ1vkUUUMS8vNLRaER2tRvgDh8yKDkQjpoNIEe3WnGmfm0d2Z0X7
 IuzhYa0ayXpn6VyeXC6gbLklDG9y3YLBS4Y8AXwl94KBSHNXA/RAcCPpulyMjCpJIPdrT2rK8
 ysI5mWk8a3g5kCkliPJpfALOp3OFUlLw93EzRxCe6udmhpi+SjYxo3gFueyJ+nFc1KH7nK3qz
 /4+uFQ5MPfTDQ228MRk6bWDxZEnuWWgxhtbQQzADtQM1upXQCfsIXrw4mLq+73buxNYK+IG24
 ygkm501eH5YF//09TsS/9q9bT/I6X+IoNqoibiNQGBTUjjbaA9LELXqp6JpFz1I2FpIxvYPEe
 IdCgAwbMi7KJ+RZ0RC2p0PIgeFi7aI+30th8IrCgbE5qtPbtYF422+rPdLjZnRChsxSHrWk74
 aeTwJEG/d8Qx5cQz/f1Xx627eUw6TQn5NogdlUMCpBnRboG8qCB3Ggim+71hlSKAnmz9oTYYj
 d60J80qs6oEFySsuSNnO/b+PY6iK7S7UWJe8glfWbVpO9f6V4pfOz/y1cRURUO1hZ6QPUd7Vi
 qthnN7h7WEQDDGxk7JGwb+p2O0eLb8VlV5DDvv85PlBqPiAzBnJMhrknOkXYzKk1vIZ4rI84n
 TTbkJiRGlB5BkapdTaNR/FSOWj7Bl2f+accO6PMwr7OtunThxY=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 10:33 AM Sumit Semwal <sumit.semwal@linaro.org> wrote:
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
> d_ops->d_release().
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
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

The patch looks correct to me.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Obviously this should still be verified against the original report if possible.

>  drivers/dma-buf/dma-buf.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 01ce125f8e8d..92ba4b6ef3e7 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -54,8 +54,11 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
>                              dentry->d_name.name, ret > 0 ? name : "");
>  }
>
> +static void dma_buf_release(struct dentry *dentry);
> +
>  static const struct dentry_operations dma_buf_dentry_ops = {
>         .d_dname = dmabuffs_dname,
> +       .d_release = dma_buf_release,
>  };

I'd suggest rearranging the file to avoid the forward declaration, even
if it makes it a little harder to review the change, the resulting code
will remain organized more logically.

>  static struct vfsmount *dma_buf_mnt;
> @@ -77,14 +80,14 @@ static struct file_system_type dma_buf_fs_type = {
>         .kill_sb = kill_anon_super,
>  };
>
> -static int dma_buf_release(struct inode *inode, struct file *file)
> +static void dma_buf_release(struct dentry *dentry)
>  {
>         struct dma_buf *dmabuf;
>
> -       if (!is_dma_buf_file(file))
> -               return -EINVAL;
> +       if (dentry->d_op != &dma_buf_dentry_ops)
> +               return;

I think the check here is redundant and it's clearer without it.

          Arnd
