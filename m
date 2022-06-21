Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B343552993
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 05:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiFUDEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 23:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiFUDEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 23:04:41 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B721901C;
        Mon, 20 Jun 2022 20:04:40 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id k25so4678020vso.6;
        Mon, 20 Jun 2022 20:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y4HSHOm4GvMPxpFx9Z2OJ5u0aoMzu21CDyRyrLm6eO8=;
        b=fgqCIiHg4hvPdwKPP2Yy4vbtqtPlEkCODR2Ube6Yi1hlzjyBvOmyh0bmmTU10ADGYL
         Trf5ig1BpcXM/bW3kCIO3dBxh5cc21bnabxTYydyEL6t2DOWNZ8/fIbievtFW08BlB/X
         J+BrQO5ofJ/JKXl2EvhCjZKNOxD1ahz7Nnj15XcR1DwM4Sqy/46zQdd25SxPlJt9QQNr
         FPKtnxswoBoBEsyruePtBO9OMQ2o0GKWApW5H/VA6FivnjzMXWGNUZOLOnZjxxxhhw+l
         xPFTnajLiuVXCs8lvDYms5CRpZAPB4uF4F21BsHaPfXSG0p50BUZiQPkw2E65qlQMM7u
         P2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y4HSHOm4GvMPxpFx9Z2OJ5u0aoMzu21CDyRyrLm6eO8=;
        b=enO289c08wIuF+KcGOTzcWYbE8GvBpiEM/a04d4/jimK+4yDY3DDSBGOxmxdlna/so
         1nQOO1YVlNR6CDOne956X6TaBFsRQSeW6AovkEmRKvSJzpHcPuK9vmo+9qAd70cczHj5
         0EM6GCOtR9nMx3IZQCUOASJQAh7LX4IDp0xqLCyJYISpTayIUYf+3fKIrjaEdkq68uaZ
         UM2nCwyI66KKUoM+XNBZYH2ADcRUNdW5V0U+Hhb+8xGbNpKTYqwbewLBv99f3qVGODdX
         v7va2EqYk8ewez+hiUNgPPNuMC8oP8RF9r2PLHa5swTjCfaMgDzFpPc3iGQAOkz++Oka
         XjDA==
X-Gm-Message-State: AJIora+08ovzT2vUzYCd2wtX3fAC9TtOibs/s4xEUvTko12uofmIuO+2
        PH8WGRR3+2FDLpSMSO1NR/cs8Yg9Lutgln3GrFo=
X-Google-Smtp-Source: AGRyM1sPlPwt7M2okqk+wWTGnNDh+vmhb0NtJuPnnEB2dDPUapM60180Exy3WDpni5B906lFrVJr3SSoW+2HN4rM3mw=
X-Received: by 2002:a67:fa01:0:b0:354:3136:c62e with SMTP id
 i1-20020a67fa01000000b003543136c62emr3190360vsq.2.1655780678729; Mon, 20 Jun
 2022 20:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220511190213.831646-1-amir73il@gmail.com> <20220511190213.831646-3-amir73il@gmail.com>
 <CAOQ4uxj6wdsoVf7pyJWhoJ9mcNWf0eU_ARsXf6rH_nwpG1DJDg@mail.gmail.com> <YrDZ2YOeHkneW8+9@kroah.com>
In-Reply-To: <YrDZ2YOeHkneW8+9@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 21 Jun 2022 06:04:33 +0300
Message-ID: <CAOQ4uxiBHzFExCZowFNggn+woOz8vfwK=PZvAnVVBYHvjG-udQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] fsnotify: consistent behavior for parent not
 watching children
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 11:34 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 20, 2022 at 05:16:16PM +0300, Amir Goldstein wrote:
> > On Wed, May 11, 2022 at 10:02 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > The logic for handling events on child in groups that have a mark on
> > > the parent inode, but without FS_EVENT_ON_CHILD flag in the mask is
> > > duplicated in several places and inconsistent.
> > >
> > > Move the logic into the preparation of mark type iterator, so that the
> > > parent mark type will be excluded from all mark type iterations in that
> > > case.
> > >
> > > This results in several subtle changes of behavior, hopefully all
> > > desired changes of behavior, for example:
> > >
> > > - Group A has a mount mark with FS_MODIFY in mask
> > > - Group A has a mark with ignore mask that does not survive FS_MODIFY
> > >   and does not watch children on directory D.
> > > - Group B has a mark with FS_MODIFY in mask that does watch children
> > >   on directory D.
> > > - FS_MODIFY event on file D/foo should not clear the ignore mask of
> > >   group A, but before this change it does
> > >
> > > And if group A ignore mask was set to survive FS_MODIFY:
> > > - FS_MODIFY event on file D/foo should be reported to group A on account
> > >   of the mount mark, but before this change it is wrongly ignored
> > >
> > > Fixes: 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
> > > Reported-by: Jan Kara <jack@suse.com>
> > > Link: https://lore.kernel.org/linux-fsdevel/20220314113337.j7slrb5srxukztje@quack3.lan/
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> >
> > Greg,
> >
> > FYI, this needs the previous commit to apply to 5.18.y:
>
> What is "this" here?  What git id?

Sorry, this commit:

> > e730558adffb fsnotify: consistent behavior for parent not watching children

Needs this previous commit:

> > 14362a254179 fsnotify: introduce mark type iterator

> > They won't apply to earlier versions and this is a fix for a very minor bug
> > that existed forever, so no need to bother.
>
> So what exactly needs to be applied in what order and to what trees?
>

To apply to 5.18.y.

Don't bother trying to apply either to earlier trees.

Thanks,
Amir.
