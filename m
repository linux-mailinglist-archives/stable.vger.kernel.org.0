Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15C842ACEF
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 21:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhJLTIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 15:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhJLTIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 15:08:24 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDAEC061570;
        Tue, 12 Oct 2021 12:06:22 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id z202so184945vkd.1;
        Tue, 12 Oct 2021 12:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yZIw/zH/pjWMiclwP1nzdb1hdseDdepceGOMtgtCc6E=;
        b=PTFAoGCJpEW9bEbzhPLgKI5yFGGCPKLARZpRb8KEFT5LPUHIaLPq85V8Zk88nnmVE4
         4RPIxqFK2dp1+qVFuu5xhz9aDM5+JIukKaAS1KlaTeNzS35cNkwGE0j9eiviToMfcipq
         MS5/CrVc5hsaX+m6E2N4iWydC9FIMSmryBvf3SBb3DzQOpnyTIZAjWjundTrRXzRqNv3
         B1I66iZqlBBsh8sEMZ4AVVQUmi1D9HYuu31pAH9A3lfL8tctfcr66uTpb5BzPeOt1Tjd
         MIE9z1imuopd+cfsEpaC2QODGIj2D6tAtKQF65YYX6+qSfKv4SOTngDyQ1wKOVtugipq
         /hiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yZIw/zH/pjWMiclwP1nzdb1hdseDdepceGOMtgtCc6E=;
        b=lZzKR+C+VQZhjh7MW93TJ7j1D2zr4brSm5XA1AGFQrefzkPDVP6c/z/GmXtZ6gYKnZ
         gzjobPBly+CWmxb5BoQAVRfJe31K4qvqFkT4MA+gZ+7Wht4uFuXckpcNen1UNOmoKzXo
         eKi5Abp/24YxFjDLeMgWW03u2n+r/bp/njzX22EqKyaN3Yn/XsSn6s4bwn9dCfdG7qso
         3O2CGkFQt1SVuQecppl4eY87OfmSxzmTOK9Ds4UZm7H0Zsaehu2Qn1MlTwYk421UDJVl
         a6GGgsX9RLVnWrRDZ5pvOAM8Mpn8cnB7EQk6M4wOyhELFuc3Taj0T708R0yc0gQMfceK
         Urzg==
X-Gm-Message-State: AOAM531bAg24aLPlz8yTObevE5VUQe685MYor1eeAgqIAEFFPyTq0oU7
        xEOQXKUXHA8jN+dq64NloU1IIRXW+e6XhMwpGfY=
X-Google-Smtp-Source: ABdhPJxiSIhP+dmOeR6RuQ/nwToYxfMKeS7WrFWPB32MM6Ziqus4W+CkJ+xq9FVb7rPCH/6dWZdu7rwDBRmVgtlQXxY=
X-Received: by 2002:a1f:324d:: with SMTP id y74mr28349432vky.20.1634065581304;
 Tue, 12 Oct 2021 12:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211012134915.38994-1-jlayton@kernel.org>
In-Reply-To: <20211012134915.38994-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 12 Oct 2021 21:05:49 +0200
Message-ID: <CAOi1vP8L74DQAKHrF9FFz00pvqcktOXLdemhFGmXsROZCtNB=w@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: skip existing superblocks that are blocklisted
 or shut down when mounting
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, stable@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 3:49 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Currently when mounting, we may end up finding an existing superblock
> that corresponds to a blocklisted MDS client. This means that the new
> mount ends up being unusable.
>
> If we've found an existing superblock with a client that is already
> blocklisted, and the client is not configured to recover on its own,
> fail the match. Ditto if the superblock has been forcibly unmounted.
>
> While we're in here, also rename "other" to the more conventional "fsc".
>
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Cc: Niels de Vos <ndevos@redhat.com>
> Cc: "Yan, Zheng" <ukernel@gmail.com>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>
> ceph: when comparing superblocks, skip ones that have been forcibly unmounted
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Hi Jeff,

This looks like a squashing left-over.

> ---
>  fs/ceph/super.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> v3: also handle the case where we have a forcibly unmounted superblock
>     that is detached but still extant
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index f517ad9eeb26..b9ba50c9dc95 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>         struct ceph_fs_client *new = fc->s_fs_info;
>         struct ceph_mount_options *fsopt = new->mount_options;
>         struct ceph_options *opt = new->client->options;
> -       struct ceph_fs_client *other = ceph_sb_to_client(sb);
> +       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>
>         dout("ceph_compare_super %p\n", sb);
>
> -       if (compare_mount_options(fsopt, opt, other)) {
> +       if (compare_mount_options(fsopt, opt, fsc)) {
>                 dout("monitor(s)/mount options don't match\n");
>                 return 0;
>         }
>         if ((opt->flags & CEPH_OPT_FSID) &&
> -           ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
> +           ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
>                 dout("fsid doesn't match\n");
>                 return 0;
>         }
> @@ -1140,6 +1140,17 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
>                 dout("flags differ\n");
>                 return 0;
>         }
> +       /* Exclude any blocklisted superblocks */

Nit: given the dout message that follows, this comment seems useless.

Thanks,

                Ilya
