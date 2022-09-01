Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6735A5A92B5
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiIAJGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiIAJFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:05:36 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2534E136088
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 02:04:28 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so956173wmk.3
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 02:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=X7aGePgXUHNEuEmopXNGAMlc5IEtUgLNXvZWJZgL/CA=;
        b=nAU9QFMJKi1KKG4Gn2YBEWYZhtXmj1KHEU/s0NELeTcrYqo72F1YfoTLyWbOczJG3/
         rv4LMvKDJpd1pJWSYAHzfNT4XXJLB7aHtHLvON6E8klCmIalq1dDngQGwDtt8iBpDktr
         4bKJhqAu0Uct4TUbj0wcz/80rmBFIStD1tp2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=X7aGePgXUHNEuEmopXNGAMlc5IEtUgLNXvZWJZgL/CA=;
        b=p9VVtTfDd96keRodK9iF9sc61vW7h1tXcONWw6lktcJARuicfkrmVqxC7xQZUePR/V
         lbMQ2Xtw5yJ3TsQ+6BgENhPotLk3MvcLkuJq1QpF+rL428NfVVF5dbO3y/+yw/GA6QoY
         87fqELshN0+PSW1WOs/RpEGvMYfbHkPJHi2o22oCWB8vaJIkZ+2B+0yCAmLxCwkARNvb
         IdkQDFRydPhipPahrqkp+Hshw8OfxY6AR0gDVlcORVYp/zxHHfbbvN0Eq1N25ycbaipM
         F47i7ZUtUsSF3JSFSlGXeZ7rzljP/ENLCEXShbO6Yl+oxgnpVlTwln8MQFASQ8Z3XyZF
         7RUw==
X-Gm-Message-State: ACgBeo08nVJFfgOVQyolxWSMuv+DG1BoeZidMKNkks7pnZibsGyKsoTx
        sHQfBPKrU+tHFiJb0oDiHzFriuy5gblgvyjx/cyy/Q==
X-Google-Smtp-Source: AA6agR7j2dQ8yjJ769FJhz6swVQHiUcpEemktYTiCsXSftCkdmV4sTgcLVSdMkJ9DKQIEyIJqSvT+iYZOa0PrUpWhkY=
X-Received: by 2002:a05:600c:22cd:b0:3a6:7b62:3778 with SMTP id
 13-20020a05600c22cd00b003a67b623778mr4528379wmg.45.1662023066170; Thu, 01 Sep
 2022 02:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220901054854.2449416-1-amir73il@gmail.com> <20220901054854.2449416-7-amir73il@gmail.com>
In-Reply-To: <20220901054854.2449416-7-amir73il@gmail.com>
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Thu, 1 Sep 2022 10:04:15 +0100
Message-ID: <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in xfs_ifree
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
>
> [backport for 5.10.y]

Hi Amir, hi Dave,

I've got no objections to backporting this change at all. We've been
using the patch on our internal 5.15 tracker branch happily for
several months now.

Would like to highlight though that it's currently not yet merged in
linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
If this gets queued for 5.10 then maybe it also should be for 5.15 ?

Thank you,
FrankH.


>
> The O_TMPFILE creation implementation creates a specific order of
> operations for inode allocation/freeing and unlinked list
> modification. Currently both are serialised by the AGI, so the order
> doesn't strictly matter as long as the are both in the same
> transaction.
>
> However, if we want to move the unlinked list insertions largely out
> from under the AGI lock, then we have to be concerned about the
> order in which we do unlinked list modification operations.
> O_TMPFILE creation tells us this order is inode allocation/free,
> then unlinked list modification.
>
> Change xfs_ifree() to use this same ordering on unlinked list
> removal. This way we always guarantee that when we enter the
> iunlinked list removal code from this path, we already have the AGI
> locked and we don't have to worry about lock nesting AGI reads
> inside unlink list locks because it's already locked and attached to
> the transaction.
>
> We can do this safely as the inode freeing and unlinked list removal
> are done in the same transaction and hence are atomic operations
> with respect to log recovery.
>
> Reported-by: Frank Hofmann <fhofmann@cloudflare.com>
> Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 1f61e085676b..929ed3bc5619 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2669,14 +2669,13 @@ xfs_ifree_cluster(
>  }
>
>  /*
> - * This is called to return an inode to the inode free list.
> - * The inode should already be truncated to 0 length and have
> - * no pages associated with it.  This routine also assumes that
> - * the inode is already a part of the transaction.
> + * This is called to return an inode to the inode free list.  The inode should
> + * already be truncated to 0 length and have no pages associated with it.  This
> + * routine also assumes that the inode is already a part of the transaction.
>   *
> - * The on-disk copy of the inode will have been added to the list
> - * of unlinked inodes in the AGI. We need to remove the inode from
> - * that list atomically with respect to freeing it here.
> + * The on-disk copy of the inode will have been added to the list of unlinked
> + * inodes in the AGI. We need to remove the inode from that list atomically with
> + * respect to freeing it here.
>   */
>  int
>  xfs_ifree(
> @@ -2694,13 +2693,16 @@ xfs_ifree(
>         ASSERT(ip->i_d.di_nblocks == 0);
>
>         /*
> -        * Pull the on-disk inode from the AGI unlinked list.
> +        * Free the inode first so that we guarantee that the AGI lock is going
> +        * to be taken before we remove the inode from the unlinked list. This
> +        * makes the AGI lock -> unlinked list modification order the same as
> +        * used in O_TMPFILE creation.
>          */
> -       error = xfs_iunlink_remove(tp, ip);
> +       error = xfs_difree(tp, ip->i_ino, &xic);
>         if (error)
>                 return error;
>
> -       error = xfs_difree(tp, ip->i_ino, &xic);
> +       error = xfs_iunlink_remove(tp, ip);
>         if (error)
>                 return error;
>
> --
> 2.25.1
>
