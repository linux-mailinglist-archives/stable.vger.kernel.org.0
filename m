Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD0C18509C
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 22:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgCMVFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 17:05:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39632 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMVFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 17:05:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id f10so12094118ljn.6
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 14:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUPEQrVc4mJ1aSnmipjhkIByffePioYZKnVf6NpDpI8=;
        b=P5Ogmpy5V9lQ4uYTKrOVyTysqzyVjTYn17sl4IG9cpSDCLxd2q/T5I0Va9Uja83wUW
         /MmXs3Tmx3dQu0l9QUSehMBgPcfy7vrVDVlK5W83eQSrP+hwclc6Blxdhu0mEgTLkEg8
         /1WjSoWo5rrOlQi2wO6aqRUKk6e6xomcI1vRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUPEQrVc4mJ1aSnmipjhkIByffePioYZKnVf6NpDpI8=;
        b=S09uGfZCbldaogkZB9KbyP2qZiv7SuGpwvNi1DoBZWfAl58Pex5I3tjrNyjpVHt14r
         VWOmw+zOaU3hAHBYs8KqYE3ZcKAvjR0G2CDf7aExcTeMGIRi0Ygo+W+MY2rQkq9rz8bU
         HOWKqve2/NDf65ycqSgQOMKd0LPsAu0Iit7Lqa67HSoh81FD4jkUDrBRPU4Nw3nNRZJb
         k7hXg+Nym9Q7LO3JfX4CxhYpkwxhVkntO76BwMlHy63g6e1Xf7cqs32iEAmtfACj+see
         eJ0sBdnRpaNb4AjwJaIs7B2v4kCAUxIj1hCJg28UvYquB7lfDgSIFgsVshIms1R17aLW
         eXiQ==
X-Gm-Message-State: ANhLgQ08az83s1sgxfdFCUxjvKuVgw8GTtUVRjMB7bgYdsDKpIXCytQ5
        h3UEvol/csNYQZekeKNNBX4570uo9vA=
X-Google-Smtp-Source: ADFU+vu5E7rvJSPLVKVruq+1wp7Uw3HEyO4zjtkBtwPmKHlpeGyKMwDG7b9CpBfviO9mOnH1L+SYiA==
X-Received: by 2002:a2e:99ca:: with SMTP id l10mr9226360ljj.13.1584133544876;
        Fri, 13 Mar 2020 14:05:44 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id n12sm7788403lji.77.2020.03.13.14.05.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 14:05:44 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id b13so9011660lfb.12
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 14:05:43 -0700 (PDT)
X-Received: by 2002:ac2:5203:: with SMTP id a3mr9579124lfl.152.1584133543357;
 Fri, 13 Mar 2020 14:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200313202443.2539-1-oss@malat.biz>
In-Reply-To: <20200313202443.2539-1-oss@malat.biz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 13 Mar 2020 14:05:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgbhYWxprGr1puAabZZFp4O3myBv-W9dJCVYt8r=dxZNQ@mail.gmail.com>
Message-ID: <CAHk-=wgbhYWxprGr1puAabZZFp4O3myBv-W9dJCVYt8r=dxZNQ@mail.gmail.com>
Subject: Re: [PATCH] NFS: Remove superfluous kmap in nfs_readdir_xdr_to_array
To:     Petr Malat <oss@malat.biz>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Security Officers <security@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Adding more people.

The old stable trees seem to have rather different code.

[ Goes off and looks at the stable trees ]

Petr seems entirely correct - the stable tree backport appears broken.

Because looking at that commit 67a56e9743171 in the stable tree, it
doesn't seem to match commit 4b310319c6a8 ("NFS: Fix memory leaks and
corruption in readdir") in mainline.

That stable backport looks bogus. It added that

        array = kmap(page);

line from somewhere else, probably because the stable tree didn't have
the line at all, and it was there in the context.

Because while mainline has that line to initialize array with kmap(),
in those stable trees, we have

        array = nfs_readdir_get_array(page);

and as Petr says, the kmap has been done there already, and it will be
kunmap'ed by nfs_readdir_release_array().

And looking closer, this same bug seems to have happened twice: it
also exists in 0b0223f9c3a8.

But somebody else should double-check me - somebody who actually knows the code.

As to how I found the other case, do this in the stable git repo with
all the stable tags:

    git log -p --no-merges --all \
        --grep="NFS: Fix memory leaks and corruption in readdir"

to see all the copies of that commit backport.

Add a

    -S'kmap(page)'

to that line to see the cases that added that line. Or to just get the commits:

    git log --oneline --no-merges --all \
        --grep="NFS: Fix memory leaks and corruption in readdir" \
        -S'kmap(page)'

and the result is

    67a56e974317 NFS: Fix memory leaks and corruption in readdir
    0b0223f9c3a8 NFS: Fix memory leaks and corruption in readdir

Those two seem to be the 4.4 and 4.9 backports:

    git name-rev 67a56e974317 0b0223f9c3a8

gives:

    67a56e974317 tags/v4.9.214~38
    0b0223f9c3a8 tags/v4.4.214~31

and I guess that makes sense - they are the really old ones.

             Linus

On Fri, Mar 13, 2020 at 1:25 PM Petr Malat <oss@malat.biz> wrote:
>
> Array is mapped by nfs_readdir_get_array(), the further kmap is a result
> of a bad merge and should be removed.
>
> This resource leakage can be exploited for DoS by receptively reading
> a content of a directory on NFS (e.g. by running ls).
>
> Fixes: 67a56e9743171 ("NFS: Fix memory leaks and corruption in readdir")
> Signed-off-by: Petr Malat <oss@malat.biz>
> ---
>  fs/nfs/dir.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index c2665d920cf8..2517fcd423b6 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -678,8 +678,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
>                 goto out_label_free;
>         }
>
> -       array = kmap(page);
> -
>         status = nfs_readdir_alloc_pages(pages, array_size);
>         if (status < 0)
>                 goto out_release_array;
> --
> 2.20.1
>
