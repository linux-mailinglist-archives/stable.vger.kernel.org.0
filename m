Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8592D4170A8
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 13:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbhIXLLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 07:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244499AbhIXLLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 07:11:18 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87538C061574;
        Fri, 24 Sep 2021 04:09:45 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i4so38860327lfv.4;
        Fri, 24 Sep 2021 04:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y2+HfOHnV0xb6zV4dOGhoGeFOUOY+WWDxbpfAlUhn2I=;
        b=fm2WPVBjJ0vo1CI+4Fm71l/8GvluOEGtLYt9VaS7soR1AWvxbTtxcMz106A7W/OUFW
         9msuULELDYP10jKK1UT4ZbYnvHDFy7W0JuBytxCJ9Cc8ZC74gKtCbDsVM/OLqZF1hXpE
         pf5j2JKnwT8KpLQ6qyP2LcL1yQ0vxjePpzbDGLTbxawpwLLI77lhJ5bQzBYfyEzxt5qu
         +hGpxr/DLZRWTuZqHB3n4Ma3J70PBS92R8vI6a7+cGoNuK4hucJ42ML9xMescxBgZ/Pp
         Sd4BP6YtXCWMalf+mr+erpoMlYrNVLpWs05CyCQmTjE6krYrUw3ZMmni7T67vO42Qi2G
         uDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y2+HfOHnV0xb6zV4dOGhoGeFOUOY+WWDxbpfAlUhn2I=;
        b=XBEcRYfQc3fHXe7rUz8gqlX8JAE6MDKTNartaOmV7Cb6sYalrFDcVUbUgoOEafGgxU
         SG9Vvk+7TSzXzeuMWIHcZ6uNVbtInmXMP2AZXi/ghV61XHqu7nWQDcVxVG6tYN1TR98H
         0MPgMO6HvtOFbf+XVvBpvXi/Iyaa5ys7FtLbUwZF4+ufGNCzDIGK3ic48hPnSshNz7OR
         VZlgPBiccVd0XF5m4OGHWL2GOy0keqamCEKekfu1NVzYS1q/f3CaOTWX4sNHhJhbar4V
         acEgAKZYKpYdC7nz5yakHim6flAbPyG55txTfnXidKyTRzieATryK9ko/87iGObOdN00
         pjjQ==
X-Gm-Message-State: AOAM533djZuDOGnbX49cMi7+mBTQHAzIDZ9XW9w1XxJjYLNgu9EKjL09
        8Xy0UWpWlzr0Gy3gXEQZplHFfiRyuI3Ekr91Uv6nwUtd
X-Google-Smtp-Source: ABdhPJyczi1wcMH6JE93aJAc4Y8+1lMwl194iHWW19om/BU5+/jYkPj1v46FYx5k+sNHe8qnJicXOWTM/luPEAL5iIM=
X-Received: by 2002:a2e:8e89:: with SMTP id z9mr10672076ljk.350.1632481783766;
 Fri, 24 Sep 2021 04:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908030026.2dLZCmkE4%akpm@linux-foundation.org> <20210924103533.GA22717@duo.ucw.cz>
In-Reply-To: <20210924103533.GA22717@duo.ucw.cz>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Fri, 24 Sep 2021 20:09:31 +0900
Message-ID: <CAKFNMon6dUZ1-S8Pi+8qJivXt9GArxVLrcH-KPEjxXU3ZAzS8A@mail.gmail.com>
Subject: Re: [patch 136/147] nilfs2: use refcount_dec_and_lock() to fix
 potential UAF
To:     Pavel Machek <pavel@denx.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Fri, Sep 24, 2021 at 7:35 PM Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > From: Zhen Lei <thunder.leizhen@huawei.com>
> > Subject: nilfs2: use refcount_dec_and_lock() to fix potential UAF
> >
> > When the refcount is decreased to 0, the resource reclamation branch is
> > entered.  Before CPU0 reaches the race point (1), CPU1 may obtain the
> > spinlock and traverse the rbtree to find 'root', see nilfs_lookup_root().
> > Although CPU1 will call refcount_inc() to increase the refcount, it is
> > obviously too late.  CPU0 will release 'root' directly, CPU1 then accesses
> > 'root' and triggers UAF.
> >
> > Use refcount_dec_and_lock() to ensure that both the operations of decrease
> > refcount to 0 and link deletion are lock protected eliminates this risk.
> >
> >      CPU0                      CPU1
> > nilfs_put_root():
> >                           <-------- (1)
> > spin_lock(&nilfs->ns_cptree_lock);
> > rb_erase(&root->rb_node, &nilfs->ns_cptree);
> > spin_unlock(&nilfs->ns_cptree_lock);
> >
> > kfree(root);
> >                           <-------- use-after-free
>
> > There is no reproduction program, and the above is only theoretical
> > analysis.
>
> Ok, so we have a theoretical bug, and fix already on its way to
> stable. But ... is it correct?
>
> > +++ a/fs/nilfs2/the_nilfs.c
> > @@ -792,14 +792,13 @@ nilfs_find_or_create_root(struct the_nil
> >
> >  void nilfs_put_root(struct nilfs_root *root)
> >  {
> > -     if (refcount_dec_and_test(&root->count)) {
> > -             struct the_nilfs *nilfs = root->nilfs;
> > +     struct the_nilfs *nilfs = root->nilfs;
> >
> > -             nilfs_sysfs_delete_snapshot_group(root);
> > -
> > -             spin_lock(&nilfs->ns_cptree_lock);
> > +     if (refcount_dec_and_lock(&root->count, &nilfs->ns_cptree_lock)) {
> >               rb_erase(&root->rb_node, &nilfs->ns_cptree);
> >               spin_unlock(&nilfs->ns_cptree_lock);
> > +
> > +             nilfs_sysfs_delete_snapshot_group(root);
> >               iput(root->ifile);
> >
> >               kfree(root);
>
> spin_lock() is deleted, but spin_unlock() is not affected. This means
> unbalanced locking, right?

It's okay.   spin_lock() is integrated into refcount_dec_and_lock(), which was
originally refcount_dec_and_test().

Thanks,
Ryusuke Konishi

>
> Best regards,
>                                                                 Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
>
