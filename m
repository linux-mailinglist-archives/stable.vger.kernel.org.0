Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A83537553
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiE3HJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 03:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiE3HJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 03:09:24 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBE169B43
        for <stable@vger.kernel.org>; Mon, 30 May 2022 00:09:17 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id r82so7648408ybc.13
        for <stable@vger.kernel.org>; Mon, 30 May 2022 00:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jww0J4oPGMUYRvhfGts833A8mLP641a6hSl8oJ1qUcs=;
        b=ABChcYJYfb3PvHlpo7305eF3DUDHI2i4Zmtzt6SuvdHbgRd5goM0L2hEzAmjhBvb/9
         GkMgIKwTvmt3/pHAVz2yPqmZ6Ns6+2Nfiticl5KMGN9C29c/NLn4GSE0wSn+huEU4uF+
         Ij6gdx45XzJhwQfnk1EEIDfIbLWNd3dORFfQmO5Nh3g9xHC1Orz2AbRVnS7QWlS2+vun
         K9jVEGl1IECfzURNz1HZBqj8gX4ryXNJA39KLCZdGj9dNpoyxW3aWWBSthy6Me8n+wkQ
         SKH9qnzS7w5fPn8XGZBt0uvAExoJSBM2A+szQc/ZanaT4XhsRjpErVoMkInYglI3b7d4
         BtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jww0J4oPGMUYRvhfGts833A8mLP641a6hSl8oJ1qUcs=;
        b=jOptqmvj8ZWgYLl/ieaAsDqsIqJ9q1OdTraEOkA0OKg7CCg0E06MITlgJoLDlSGegO
         puqiA/eafvTXxoDHhtEHlL6ihvaH0B+95bna/toH7iKvrHJHGXQdh4gDlj+wsM2pVjBu
         vascKJdseIbQniO2Z0AsftOU7F0Fli+vPvNLoqfW+kHF8vNlNVCfqgiBJH//5zhoTK5w
         cPwtPnGegNyivm2sEWl6pS4y1EzlaFtLvxIeU5JtQ1h2uGpel0kk+ESWctBaOZcIi9fh
         RDkEReTkOIyO7iE3YD8gr+NQm8Y5fZIVj/nphLqKnDxrm/YmtDUL5re/pmvH/zHKmsPz
         PUSg==
X-Gm-Message-State: AOAM532+gC+T234PyriYkqZXHWkLV7zCbdIDcZQK1tpwsXXfQxBQGfnu
        HZzc/zZkp7yCnnCE9+yGmmKemG+GEWQsgzBzoom/3w==
X-Google-Smtp-Source: ABdhPJxYHL7g2oEnoKpPxjrJ2ol8xxaxgeuoFB+805LFBauxb9YgatoZECAadZvhb/SFstbxsts621Xia0yPU0xlDzI=
X-Received: by 2002:a05:6902:282:b0:64d:e139:c9b8 with SMTP id
 v2-20020a056902028200b0064de139c9b8mr53535766ybh.6.1653894556570; Mon, 30 May
 2022 00:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220530053326.41682-1-songmuchun@bytedance.com> <0563a019-09e3-a176-d4c1-c240f3cf62d0@redhat.com>
In-Reply-To: <0563a019-09e3-a176-d4c1-c240f3cf62d0@redhat.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Mon, 30 May 2022 15:08:40 +0800
Message-ID: <CAMZfGtUMfNjOGJ3j4tgha6SxFymNGDo3CW5NO73ZsMby42BPjg@mail.gmail.com>
Subject: Re: [PATCH] mm: memory_hotplug: fix memory error handling
To:     David Hildenbrand <david@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        cheloha@linux.vnet.ibm.com, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 2:56 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 30.05.22 07:33, Muchun Song wrote:
> > The device_unregister() is supposed to be used to unregister devices if
> > device_register() has succeed.  And device_unregister() will put device.
> > The caller should not do it again, otherwise, the first call of
> > put_device() will drop the last reference count, then the next call
> > of device_unregister() will UAF on device.
> >
> > Fixes: 4fb6eabf1037 ("drivers/base/memory.c: cache memory blocks in xarray to accelerate lookup")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  drivers/base/memory.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > index 7222ff9b5e05..084d67fd55cc 100644
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -636,10 +636,9 @@ static int __add_memory_block(struct memory_block *memory)
> >       }
> >       ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
> >                             GFP_KERNEL));
> > -     if (ret) {
> > -             put_device(&memory->dev);
> > +     if (ret)
> >               device_unregister(&memory->dev);
> > -     }
> > +
> >       return ret;
> >  }
> >
>
> See
>
> https://lkml.kernel.org/r/d44c63d78affe844f020dc02ad6af29abc448fc4.1650611702.git.christophe.jaillet@wanadoo.fr
>

I see. Good job by Christophe. Thanks David.
