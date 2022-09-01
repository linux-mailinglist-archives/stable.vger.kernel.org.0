Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1ED5A95DD
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 13:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiIALnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 07:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiIALnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 07:43:21 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983D51314E2
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 04:43:15 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so1209653wme.1
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 04:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bbJQltWPn0a278ieY2senRHzgqz4m0om06hRCaDVLg4=;
        b=H83xMQLKTiAv1yh7u9VA/5fIuK+BNYHJjOC3SKcH3LOLBUBQKi+ax9Atj9WzORcTmu
         mAua3KEGWQGxeW3NHb8peiLR6YVYGXqbf0lKG2uFQwoCGnechIBYcc8HSB8C0vf6i/bP
         zrsMummDvxB7GYiJKwG7bfeIaujopfH2r9Kao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bbJQltWPn0a278ieY2senRHzgqz4m0om06hRCaDVLg4=;
        b=hI0cTeGXvo3tY+7r6WdrAYBXCXArfUvIBrMgomPRIITxK+n+QUuntLM/I0BcD2Ao5H
         QQ5+Jcrhabntah+C4tU+tUb144S+wBjGMDZJ08vcrTfEMsXKBqChft115uQ0+59PBONi
         qdW8EFAdHsa2HqdORGJNynmupIXZPYBEi6DuHwcQ0WliaWFvtko1G9/kVS35oW0Brxle
         Sqag4q9L3veJBGUauPyA/YCWUYuOmbDkKsGLXDJhexPsRZ6I8DU+fgqLAIdUb3UviIFT
         bJvNV+/clKrUBpgNEVv9/ofRIOcWvu8aI0ZNIplOwesVkoaLF5AhHKZavp1MEv7tm0y0
         mPAQ==
X-Gm-Message-State: ACgBeo28g7Q1xympEN/uZHCH8BHLupKyXkkJ8ZvP74R3Vr2CRdVLvs4s
        /Vg0jr9EPl4uJ+rVF9kCpsu+J+8lvncuqLDDeOSp+w==
X-Google-Smtp-Source: AA6agR4XuvhnjNg3AZqmNIK3SE7luAS7kPckpXPKtF78zyoDJNRkkgzbjqqbN4Q4Ixv7oyVIblA4WM6HughNbgGs+qU=
X-Received: by 2002:a05:600c:22cd:b0:3a6:7b62:3778 with SMTP id
 13-20020a05600c22cd00b003a67b623778mr4992100wmg.45.1662032594129; Thu, 01 Sep
 2022 04:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220901054854.2449416-1-amir73il@gmail.com> <20220901054854.2449416-7-amir73il@gmail.com>
 <CABEBQikqj+Uwae0XMHSbU7FVcrTR7cMb6zgbiRHC0PwFfB7+qw@mail.gmail.com> <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhNV=-nVO_ezP=Lc42+Q+A+wxdiCBqhVQz8qVkBJba1iA@mail.gmail.com>
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Thu, 1 Sep 2022 12:43:03 +0100
Message-ID: <CABEBQin2VTDbYMEz7_afgKv3dnVZF2VcMYOixD8jm6KikHep_Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 6/7] xfs: reorder iunlink remove operation in xfs_ifree
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
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

On Thu, Sep 1, 2022 at 10:30 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Sep 1, 2022 at 12:04 PM Frank Hofmann <fhofmann@cloudflare.com> wrote:
> >
> > On Thu, Sep 1, 2022 at 6:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.
> > >
> > > [backport for 5.10.y]
> >
> > Hi Amir, hi Dave,
> >
> > I've got no objections to backporting this change at all. We've been
> > using the patch on our internal 5.15 tracker branch happily for
> > several months now.
> >
> > Would like to highlight though that it's currently not yet merged in
> > linux-stable 5.15 branch either (it's in 5.19 and mainline alright).
> > If this gets queued for 5.10 then maybe it also should be for 5.15 ?
> >
>
> Hi Frank,
>
> Quoting from my cover letter:
>
> Patches 6-7 in this 5.10.y update have not been applied to 5.15.y yet.
> I pointed Leah's attention to these patches and she said she will
> include them in a following 5.15.y update.
>
> Thanks,
> Amir.

Apologies missing that one ... I've only been directly cc:'ed on 6/7 though.

In any case, for 6/7, whether applied to 5.10.y or 5.15.y,

Acked-by: Frank Hofmann <fhofmann@cloudflare.com>

And yes, I hope to see it show up in both LTS branches.

FrankH.
