Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32752C3E5D
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfJARPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:15:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46480 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfJARPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 13:15:53 -0400
Received: by mail-io1-f65.google.com with SMTP id c6so49800009ioo.13;
        Tue, 01 Oct 2019 10:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xu9mIUeG8Hcz0lOqfBLA1+CwCuPD3jFNmQ7iOIYU3x4=;
        b=FRMVxcBHcd1+N35DHWMGKKjOHcKURbQ98/5g7YKFf07zDDazVS2zJVkHkjmS2CA0X7
         kWbZrrl+jvEkxkrhNegf+buiEwcLYglZKmyEpxxebxrvIOO7l69dlNTzwB9yKeKr992C
         ahFwsU/tbsPGZ5fiCOs+CTeKmlYZtuvCT7emqm5cTuKawgvvZLaKOzyjdk9smk+T+31J
         n5+Gy3QnFvXSzvYq6jK4AwoUY6LWSm3C5TLt6d7dFFe0Gsoe7tBisdd52Dd9lp4Vb1HZ
         U2tM/Y8mX8rsfCiIcoC51K65jx3b5tD4eJ1ztwY3mfO39V0vddOwSbOcWDMt8ZrXObYh
         9yiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xu9mIUeG8Hcz0lOqfBLA1+CwCuPD3jFNmQ7iOIYU3x4=;
        b=L8/RZtufBzi4Jq0MdXROHbK0VkfnntlA0uIbQa9lK8j9Fc/Fzewqv3MyRiwR7hNpIV
         +l56buhP7h1cGHOcbJRdmG0LsyUxaXW+SxS7weN2p9Q09RM1kYfnghOU1TJPcKDhFrJR
         e5otFR1GPWYCbI3331ovJ7RPhAR+8ofvG5tMwcHDMgTA3wZIBcXMNop5HC6aa5vY70Xg
         5RX4lBgY2vdE8G/sxku9xn12QSX4axRBpnYFnD1lVlcCCTtZU6+u/6CH3R8WugN0E4ds
         rvQJbu0RazudFEz0BM6OyaHSCsNEb6QPOvj8+HTE13InwwwdwKVxBoI6fQGFm9q7sIyL
         0yjw==
X-Gm-Message-State: APjAAAVXuQ4PVaSpXMlB5Oq3k2ZdOxHxFla9g+2xZimvYAR0DBFuU8N1
        J6hD8mmcBP9rwinl1VFz4/Ln3PohzOAqOvcbZezEG8M4
X-Google-Smtp-Source: APXvYqwhVLhDPHdY3pVTIpmWCKtEk5hURjUQDpU3+51kVAPkGw4SME8F7rmmPHJ1iDSkth3/EfR+W2roF1UyG07MNbg=
X-Received: by 2002:a02:ba12:: with SMTP id z18mr24979721jan.16.1569950151370;
 Tue, 01 Oct 2019 10:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191001163922.14735-1-sashal@kernel.org> <20191001163922.14735-15-sashal@kernel.org>
In-Reply-To: <20191001163922.14735-15-sashal@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 1 Oct 2019 19:15:49 +0200
Message-ID: <CAOi1vP-2iSHxJVOabN05+NCiSZ0DxBC9fGN=5cx98mk5RvaDZA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.3 15/71] rbd: fix response length parameter for
 encoded strings
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 1, 2019 at 6:39 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Dongsheng Yang <dongsheng.yang@easystack.cn>
>
> [ Upstream commit 5435d2069503e2aa89c34a94154f4f2fa4a0c9c4 ]
>
> rbd_dev_image_id() allocates space for length but passes a smaller
> value to rbd_obj_method_sync().  rbd_dev_v2_object_prefix() doesn't
> allocate space for length.  Fix both to be consistent.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/block/rbd.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index c8fb886aebd4e..69db7385c8df5 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -5669,17 +5669,20 @@ static int rbd_dev_v2_image_size(struct rbd_device *rbd_dev)
>
>  static int rbd_dev_v2_object_prefix(struct rbd_device *rbd_dev)
>  {
> +       size_t size;
>         void *reply_buf;
>         int ret;
>         void *p;
>
> -       reply_buf = kzalloc(RBD_OBJ_PREFIX_LEN_MAX, GFP_KERNEL);
> +       /* Response will be an encoded string, which includes a length */
> +       size = sizeof(__le32) + RBD_OBJ_PREFIX_LEN_MAX;
> +       reply_buf = kzalloc(size, GFP_KERNEL);
>         if (!reply_buf)
>                 return -ENOMEM;
>
>         ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
>                                   &rbd_dev->header_oloc, "get_object_prefix",
> -                                 NULL, 0, reply_buf, RBD_OBJ_PREFIX_LEN_MAX);
> +                                 NULL, 0, reply_buf, size);
>         dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>         if (ret < 0)
>                 goto out;
> @@ -6696,7 +6699,6 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
>         dout("rbd id object name is %s\n", oid.name);
>
>         /* Response will be an encoded string, which includes a length */
> -
>         size = sizeof (__le32) + RBD_IMAGE_ID_LEN_MAX;
>         response = kzalloc(size, GFP_NOIO);
>         if (!response) {
> @@ -6708,7 +6710,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
>
>         ret = rbd_obj_method_sync(rbd_dev, &oid, &rbd_dev->header_oloc,
>                                   "get_id", NULL, 0,
> -                                 response, RBD_IMAGE_ID_LEN_MAX);
> +                                 response, size);
>         dout("%s: rbd_obj_method_sync returned %d\n", __func__, ret);
>         if (ret == -ENOENT) {
>                 image_id = kstrdup("", GFP_KERNEL);

Hi Sasha,

This patch just made things consistent, there was no bug here.  I don't
think it should be backported.

Thanks,

                Ilya
