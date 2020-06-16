Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB6E1FA9C4
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 09:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgFPHLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 03:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgFPHLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 03:11:12 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967A7C05BD43;
        Tue, 16 Jun 2020 00:11:12 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u13so922798iol.10;
        Tue, 16 Jun 2020 00:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i30R2gb7VFC5GY598W1328mU3EuYEUbcEkxEVTPlhpA=;
        b=sZ5eQQc9TzLRPIAhw+1+gfHKY7bGsqZvGGs58V1tT7vPShwA154iW82D2YO+uj4tTL
         Q/C6frLxEL2g/6KA+ouZjsMukCjJF4NH5k/LQjzRBnaiDaKqpYuGLcA220ERHpP0jEyS
         A9cqzhuhm9LA75XctUeLbllKvsLgg+zs6zphWTZMSXLGp+obkLaau8KtBBXUP3NXGGRt
         eAAfwuQXblxxiynDY57oeTQBPA+htOKmfzTZweUsM/pLcUhjRcpFoTN/0wop+9bnRlT+
         ekrgwx7nAeH3BMuh28eeBthuz8Uqmunc6GX2tHaSGmJgkmBuXVsXMKFeJXSsM6A2j7Xr
         +A/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i30R2gb7VFC5GY598W1328mU3EuYEUbcEkxEVTPlhpA=;
        b=Y+f/VgxrMAE/i4KnNO0zJ8N+fS6rYn5vaugAWsayOg95i9sy6nP9H/Le1bWhjEwFxi
         8v8Fj7Hp5vSrVoSszZaeENOCGcteUqtjDAF+ncjPgfCERmMEVR4oltbKcEPAJShwdKZw
         38lCYce8/O5DNAANnDbPrqABgJpDbnmx7mhujx5B9ITlBh6r5f+7ZfRYWuVTJBlJ5s3B
         24W83kzy1B8yLhYqNhi+NYd4JjQ6zHsPDYo/o0no1Ag9e6kLKx0cemRaly5RiDI2XBJF
         4R6fKcSEfFrjFB71cvaberVTLg0VGyIsISHTtJ/HbWPLrJb4D+uAHLrSYSb2g1zrgGz/
         JuVA==
X-Gm-Message-State: AOAM530LKHR1B4J4N4wsYaGiabn9jGjtpokrb2JGeosh/0Elz/m3+YFs
        0u3UB4KufLE1fMnN/yHaS11hJL83agZ5E0EHMa8=
X-Google-Smtp-Source: ABdhPJwGXwjzhSKRv5i9B49EcefFNKYf+uc0kikCPGbkVhSBHbN5b+/3wNIG1Oh0IEs7qJlRglgRKq9t0cRgGToY7JM=
X-Received: by 2002:a02:270d:: with SMTP id g13mr23601950jaa.93.1592291471826;
 Tue, 16 Jun 2020 00:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200615155645.32939-1-her0gyugyu@gmail.com> <20200616065756.20140-1-her0gyugyu@gmail.com>
In-Reply-To: <20200616065756.20140-1-her0gyugyu@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 16 Jun 2020 10:11:00 +0300
Message-ID: <CAOQ4uxh47beMet1QO+uT6TdYHJVBJDpOr4G+_0stUMYtURymuQ@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: inode reference leak in ovl_is_inuse true case.
To:     youngjun <her0gyugyu@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 9:58 AM youngjun <her0gyugyu@gmail.com> wrote:
>
> When "ovl_is_inuse" true case, trap inode reference not put.
> plus adding the comment explaining sequence of
> ovl_is_inuse after ovl_setup_trap.
>
> Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers..")
> Cc: <stable@vger.kernel.org> # v4.19+
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: youngjun <her0gyugyu@gmail.com>
> > ---
> >  fs/overlayfs/super.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 91476bc422f9..0396793dadb8 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1029,6 +1029,12 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
> >         NULL
> >  };
> >
> > +/*
> > + * Check if lower root conflicts with this overlay layers before checking
> > + * if it is in-use as upperdir/workdir of "another" mount, because we do
> > + * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
> > + * in-use by our upperdir/workdir.
> > + */
>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>
> ---
>  fs/overlayfs/super.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 91476bc422f9..3097142b1e23 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1493,14 +1493,22 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
>                 if (err < 0)
>                         goto out;
>
> +               /*
> +                * Check if lower root conflicts with this overlay layers before checking
> +                * if it is in-use as upperdir/workdir of "another" mount, because we do
> +                * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
> +                * in-use by our upperdir/workdir.
> +                */
>                 err = ovl_setup_trap(sb, stack[i].dentry, &trap, "lowerdir");
>                 if (err)
>                         goto out;
>
>                 if (ovl_is_inuse(stack[i].dentry)) {
>                         err = ovl_report_in_use(ofs, "lowerdir");
> -                       if (err)
> +                       if (err) {
> +                               iput(trap);
>                                 goto out;
> +                       }
>                 }
>
>                 mnt = clone_private_mount(&stack[i]);
> --
> 2.17.1
>
> Great thanks Amir. guidance to me really helpful.
> As you comment, I modified my patch.
>
> 1) I revised three patch so version is 3.

Thanks good, but you should not reply to v2, you should post
a clean new patch, with revised commit message and change.

> 2) I misunderstood your comment(adding annotation) firstly.
> But, I clearly know at now and modified it.
> the annotation before "ovl_setup_trap" is clearly understood as I see.
>
> And I have some questions.
>
> 1) As I understand, The CC you said valid is 'linux-unionfs'?

Yes.
And as I understand there is no need actually CC the patch to
stable <stable@vger.kernel.org>, the text in commit message
is enough for their tools to pickup the patch  whenever it
gets merged.

> 2) The comment "Please add these lines to the bottom of commit message..."
>    Is it needed manually when I revised patch?

Yes, these lines are supposed to be there in the final merged commit.
Maintainers can add them, but it's nice to make life easier for busy
maintainers and add those line when you re-post the patch,
so the maintainer doesn't need to look it back in emails.

Thanks,
Amir.
