Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A402B1EC6
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgKMPcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 10:32:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbgKMPcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 10:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605281534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VOFF0VnDovm6CRAoXctzS0pD8SZ2muFphtRXVw6x5Ds=;
        b=Ise77qQBGK1UhBQEgFk8feD6HSeqZ09aToLWl5p8XVY4WLs/aZDfsTQY5wGW9mgaTr9uqz
        WiG60cXUEhMn4eLtm2ysvX7hnA6ML9UkL1k3avMf2LXCAsKI4aons/1Y4feMk74RxRXfJj
        Ylh4ok0tHaUdr6PCRCh9iJY//nU8/wE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-IOkf4klaPy2muCy0xJEJng-1; Fri, 13 Nov 2020 10:32:12 -0500
X-MC-Unique: IOkf4klaPy2muCy0xJEJng-1
Received: by mail-qt1-f198.google.com with SMTP id y5so5926694qtb.13
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 07:32:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOFF0VnDovm6CRAoXctzS0pD8SZ2muFphtRXVw6x5Ds=;
        b=Yq6E7d4qCLq3bpYy3eFtI9ICS54RwxT3f2pD1TFzpPt7L6giImx8jqfNHZZkZmZGbb
         6v+8dR7FaYIiiO1ZcZOKyqQ6eit5mcbBvlaKWd219M21czvLHCkPV23dYxZBYSy32Yai
         8L5Py3st6XG/qijpI4E9F9MKpB9huiDlTS/JIN5hDsYwfWk+IswRuB312XjnUVfTQcVM
         d7QIMAUmN8D0PmbN+SoGPZiY+tsXPsq2bYeRO9pY2jcLlJgYcsPYX2lmIDyRmAeKiIP5
         2XCsUMGRtq9au8r+uDsI6GO5FKEwdOC/tIW2ln9jih7t5km2cgRYs8/re857Xs+HiRzw
         5vrg==
X-Gm-Message-State: AOAM532qPd+mT53GoFuX27lDmgqCfMz50ewmeXaF7LvAWjYaY0yW61Ge
        fJE1MtI9VFlwLIactAnAKOPVh+IVIilCiQ0JfHkQP8yXAbCD6kVco/aQUTY3zLHL3/HD4COV/dE
        z0f5VoQ0thhjyZj5rUmQiXOg/tZ9+9jEp
X-Received: by 2002:a37:a484:: with SMTP id n126mr2545126qke.277.1605281527603;
        Fri, 13 Nov 2020 07:32:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDW65daIhecY/ogoEAKw07OjscJNUjBUIRqI/nTmJhJ0i5vJBhWRdO2PGyUDkBC7YEfeTK7up9L9MxjS/w6eQ=
X-Received: by 2002:a37:a484:: with SMTP id n126mr2544693qke.277.1605281522284;
 Fri, 13 Nov 2020 07:32:02 -0800 (PST)
MIME-Version: 1.0
References: <20201112063005.692054-1-hsiangkao@redhat.com> <20201113015044.844213-1-hsiangkao@redhat.com>
In-Reply-To: <20201113015044.844213-1-hsiangkao@redhat.com>
From:   Dennis Gilmore <dgilmore@redhat.com>
Date:   Fri, 13 Nov 2020 09:31:50 -0600
Message-ID: <CAJesf3OaHg1zN2137RYn8P5tXij7Z8Lmx6x5jVLh2oqBmR5DLQ@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-By: Dennis Gilmore <dgilmore@redhat.com>

On Thu, Nov 12, 2020 at 7:51 PM Gao Xiang <hsiangkao@redhat.com> wrote:
>
> Currently, commit e9e2eae89ddb dropped a (int) decoration from
> XFS_LITINO(mp), and since sizeof() expression is also involved,
> the result of XFS_LITINO(mp) is simply as the size_t type
> (commonly unsigned long).
>
> Considering the expression in xfs_attr_shortform_bytesfit():
>   offset = (XFS_LITINO(mp) - bytes) >> 3;
> let "bytes" be (int)340, and
>     "XFS_LITINO(mp)" be (unsigned long)336.
>
> on 64-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 3 =
>            (int)(0xfffffffffffffffcUL >> 3) = -1
>
> but on 32-bit platform, the expression is
>   offset = ((unsigned long)336 - (int)340) >> 3 =
>            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> instead.
>
> so offset becomes a large positive number on 32-bit platform, and
> cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.
>
> Therefore, one result is
>   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
>
> assertion failure in xfs_idata_realloc(), which was also the root
> cause of the original bugreport from Dennis, see:
>    https://bugzilla.redhat.com/show_bug.cgi?id=1894177
>
> And it can also be manually triggered with the following commands:
>   $ touch a;
>   $ setfattr -n user.0 -v "`seq 0 80`" a;
>   $ setfattr -n user.1 -v "`seq 0 80`" a
>
> on 32-bit platform.
>
> Fix the case in xfs_attr_shortform_bytesfit() by bailing out
> "XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
> comment together with this bugfix suggested by Darrick. It seems the
> other users of XFS_LITINO(mp) are not impacted.
>
> Reported-by: Dennis Gilmore <dgilmore@redhat.com>
> Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> Cc: <stable@vger.kernel.org> # 5.7+
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since v1:
>  - fix 2 typos ">> 8" to ">> 3" mentioned by Eric;
>  - directly bail out "XFS_LITINO(mp) < bytes" suggested
>    by Eric and Darrick;
>  - fix a misleading comment together suggested by Darrick;
>  - since (int) decorator doesn't need to be added, so update
>    the patch subject as well.
>
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index bb128db220ac..c8d91034850b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -515,7 +515,7 @@ xfs_attr_copy_value(
>   *========================================================================*/
>
>  /*
> - * Query whether the requested number of additional bytes of extended
> + * Query whether the total requested number of attr fork bytes of extended
>   * attribute space will be able to fit inline.
>   *
>   * Returns zero if not, else the di_forkoff fork offset to be used in the
> @@ -535,6 +535,10 @@ xfs_attr_shortform_bytesfit(
>         int                     maxforkoff;
>         int                     offset;
>
> +       /* there is no chance we can fit */
> +       if (bytes > XFS_LITINO(mp))
> +               return 0;
> +
>         /* rounded down */
>         offset = (XFS_LITINO(mp) - bytes) >> 3;
>
> --
> 2.18.4
>


-- 
Dennis Gilmore
Multiple Architecture Portfolio Enablement
T: +1-312-660-3523

