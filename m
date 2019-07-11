Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371D965A77
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 17:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfGKP3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 11:29:06 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45324 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbfGKP3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 11:29:05 -0400
Received: by mail-yw1-f66.google.com with SMTP id m16so4059222ywh.12;
        Thu, 11 Jul 2019 08:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5sCdnmzsl1yenTFWhrojlM/D/t4ITTwRJQe377tVKgo=;
        b=hi9T44Hc/U1WaGxNK3YRIgCTIIMDaPwvl08nParEY8MDt275bPklFMyJJTW43mNamt
         1qo4XRN0biXSUMcH2yqLN0HgB5YbXFc56yN1Pf1NMq32lD3W9NrXaBtmcH72iHw7x+L2
         vXnEIqXq7MfEny31h8UAFF6rQ4BwQeStOx1fQ38NgYtozQ4mDWEAjHBi+XK998rvhPgQ
         5QBNL+gP6hoNbFaLt/tcnUQ47WfNCnoxyNk7RdurbvFgmUsyASqT7WCf2sCofGQ2OfNe
         Tm9isExHWRfS57q5NgooDQDb9TbkkKP/oorSth2cpRexa+BL+FbpiBsxrNUG18SetE5i
         dTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5sCdnmzsl1yenTFWhrojlM/D/t4ITTwRJQe377tVKgo=;
        b=atrf13a6N1/LzltTY4HHmg605+iLLPEThBmn0nR2ZZCGTNLBZPbuCvOvUY4wvJbF4G
         WV/Mm73LB5igiX+kG3I49WVgCDutdZ3y0+SEbROIQPSO3l2iJ2+CCsQvWYBg/lZ17mEt
         7cxlB1nW2WNn/5+tPYJP/c1vcqnKv/uH11za9jX1jn7cjWCw7T8jeKBF62BT41ofb+Qf
         G/6PoEoE9mE2rQeTxneiKquydXu0r+nOihyydxu1sDE1G74It2L2fC3srfQlqb4Erksh
         24sdeSUXeaXV9lxfQLY1R2yc3kGxwerjt8WSK2VHItRG3mYg2eYDsTQkYkF6kvHHnW7C
         9tYw==
X-Gm-Message-State: APjAAAUZPGi4NJG9FZ6fPF8SmB8wV7jmBIWvgIL5qcYGxukcnB/Sh8n2
        Mav+e6kx0BVtzO2IjtoKpRrA43+pQV9YWU9i5eYQGg==
X-Google-Smtp-Source: APXvYqybRjoMmoZeVATYSR5xajAV3WU3UTAp1AnSQg+8j0SLgEeFQbs8LxY7VQh36U8PWceOifdD0jQhCXZdcPRaZcg=
X-Received: by 2002:a81:3c12:: with SMTP id j18mr2694969ywa.294.1562858944848;
 Thu, 11 Jul 2019 08:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190711140012.1671-1-jack@suse.cz> <20190711140012.1671-4-jack@suse.cz>
In-Reply-To: <20190711140012.1671-4-jack@suse.cz>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 11 Jul 2019 18:28:54 +0300
Message-ID: <CAOQ4uxh-xpwgF-wQf1ozaZ3yg8nWuBvSyLr_ZFQpkA=coW1dxA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Boaz Harrosh <boaz@plexistor.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 5:00 PM Jan Kara <jack@suse.cz> wrote:
>
> Hole puching currently evicts pages from page cache and then goes on to
> remove blocks from the inode. This happens under both XFS_IOLOCK_EXCL
> and XFS_MMAPLOCK_EXCL which provides appropriate serialization with
> racing reads or page faults. However there is currently nothing that
> prevents readahead triggered by fadvise() or madvise() from racing with
> the hole punch and instantiating page cache page after hole punching has
> evicted page cache in xfs_flush_unmap_range() but before it has removed
> blocks from the inode. This page cache page will be mapping soon to be
> freed block and that can lead to returning stale data to userspace or
> even filesystem corruption.
>
> Fix the problem by protecting handling of readahead requests by
> XFS_IOLOCK_SHARED similarly as we protect reads.
>
> CC: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
> Reported-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Looks sane. (I'll let xfs developers offer reviewed-by tags)

>  fs/xfs/xfs_file.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 76748255f843..88fe3dbb3ba2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -33,6 +33,7 @@
>  #include <linux/pagevec.h>
>  #include <linux/backing-dev.h>
>  #include <linux/mman.h>
> +#include <linux/fadvise.h>
>
>  static const struct vm_operations_struct xfs_file_vm_ops;
>
> @@ -939,6 +940,24 @@ xfs_file_fallocate(
>         return error;
>  }
>
> +STATIC int
> +xfs_file_fadvise(
> +       struct file *file,
> +       loff_t start,
> +       loff_t end,
> +       int advice)
> +{
> +       struct xfs_inode *ip = XFS_I(file_inode(file));
> +       int ret;
> +
> +       /* Readahead needs protection from hole punching and similar ops */
> +       if (advice == POSIX_FADV_WILLNEED)
> +               xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +       ret = generic_fadvise(file, start, end, advice);
> +       if (advice == POSIX_FADV_WILLNEED)
> +               xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +       return ret;
> +}
>
>  STATIC loff_t
>  xfs_file_remap_range(
> @@ -1235,6 +1254,7 @@ const struct file_operations xfs_file_operations = {
>         .fsync          = xfs_file_fsync,
>         .get_unmapped_area = thp_get_unmapped_area,
>         .fallocate      = xfs_file_fallocate,
> +       .fadvise        = xfs_file_fadvise,
>         .remap_file_range = xfs_file_remap_range,
>  };
>
> --
> 2.16.4
>
