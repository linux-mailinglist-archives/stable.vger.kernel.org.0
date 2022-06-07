Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3653F54F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 06:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbiFGE4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 00:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbiFGE4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 00:56:19 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCF8D4122;
        Mon,  6 Jun 2022 21:56:18 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id q186so7110457vkh.8;
        Mon, 06 Jun 2022 21:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhWlXfl5Re+maVi7dCfRsMXwTSTdIFVk4uVyvF1WRDI=;
        b=Tdq+Qj9nXsx16tEGZLBrmkW9RrjTi6X6KORDm/9+CVyQi0gbRdKfxqoYQY/4ksjUVQ
         gE3zo4Jlfipt1VnDFXB4Gcn3OJ5eTdhpzRB9/4ri/BfpMRSbGGmbEudMufijbRxfPvJU
         IhmOV1ibKERM/Ep3X0J9ibVK7gxYPa9fFshPla/45tMrQRBiQ6jznDFWGcOGrNag0P/2
         WMaz7JEfcB9rjk9mEr7HxwgTUCh67c75fRLCJpnybVGnyW1ApO5m9oEFF1SvoArjNu0t
         Z5UTVynEhwin/MUR3AZE3t4f3vw/yPS0vVAC8gDr+gqYjC+o5tvefkbyKqWmhD9ACmVb
         vkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhWlXfl5Re+maVi7dCfRsMXwTSTdIFVk4uVyvF1WRDI=;
        b=EK4KbhHLcapgkp0tWhz9MU51ge0YOD4rBlUsrj8fXtUuw2wOiX1D5UOWrse1nYsaTS
         iqvP83z76+MxQzK2CLAFJvODiSwp31CEj5N0IdGVk7AUAK4z3vXhdcWm87iSFnHRuRR5
         3kKDNv72lO5EO25FOxB1JTOfPPU6kn2otJmVim2uTFw8xvunQG4kbwJjxZcCKqc4D2wv
         bsh9a1H7SgTlJCs/Mws0F4V4EPs3Fc7lTKKrTbu0xegFpp4q7MOBhWpIKqBcxMPyVXE7
         2FS3jR3UDcPcf7hCSvvbv/qJ+gGE415MTQKqHP0U+7qVsyZkVOG6WBmkE2bWbcrdp7es
         MmSQ==
X-Gm-Message-State: AOAM532aYpKpYn8WtPX2GBx+0LVcFvonMBA6OMYAOEVJVwc5yhVVETT4
        dkHA9rW/E8IFVjBs2hHLeZeUNv+RR+u4bqvrM9w=
X-Google-Smtp-Source: ABdhPJyUIX89kOf0vNVQQVZlCJ7e7pEmTvdqXybdpOeoemcYAxtdFo+5eU7gH42tREqyzGY/TQgubDl5oN56AjrSgOw=
X-Received: by 2002:a05:6122:509:b0:35d:9478:ac57 with SMTP id
 x9-20020a056122050900b0035d9478ac57mr6918081vko.11.1654577777561; Mon, 06 Jun
 2022 21:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220606143255.685988-1-amir73il@gmail.com> <20220606143255.685988-9-amir73il@gmail.com>
 <20220606213042.GS227878@dread.disaster.area> <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
 <20220607030147.GU227878@dread.disaster.area> <Yp7YXqn4BIZrebq7@kroah.com>
In-Reply-To: <Yp7YXqn4BIZrebq7@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Jun 2022 07:56:05 +0300
Message-ID: <CAOQ4uxj2BgvgLz9wR=rcrrAY1CYxeg=zPLA35LYQC=1HEsLXTA@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should
 take into account error
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>
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

On Tue, Jun 7, 2022 at 7:47 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 07, 2022 at 01:01:47PM +1000, Dave Chinner wrote:
> > On Tue, Jun 07, 2022 at 01:33:06AM +0300, Amir Goldstein wrote:
> > > On Tue, Jun 7, 2022 at 12:30 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Mon, Jun 06, 2022 at 05:32:55PM +0300, Amir Goldstein wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > >
> > > > > commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.
> > > > >
> > > > > xfs/538 on a 1kB block filesystem failed with this assert:
> > > > >
> > > > > XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448
> > > >
> > > > You haven't mentioned that you combined a second upstream
> > > > commit into this patch to fix the bug in this commit.....
> > > >
> > >
> > > I am confused.
> > >
> > > patch [5.10 7/8] xfs: consider shutdown in bmapbt cursor delete assert
> > > is the patch that I backported from 5.12 and posted for review.
> > > This patch [5.10 8/8] is the patch from 5.19-rc1 that you pointed out
> > > that I should take to fix the bug in patch [5.10 7/8].
> >
> > Sorry, I missed that this was a new patch because the set looked
> > the same as the last posting and you said in the summary letter:
> >
> > "These fixes have been posted to review on xfs list [1]."
> >
> > Except this patch *wasn't part of that set*. I mistook it for the
> > patch that introduced the assert because I assumed from the above
> > statement, the absence of a changelog in cover letter and that you'd
> > sent it to Greg meant for inclusion meant *no new patches had been
> > added*.
> >
> > Add to that the fact I rushed through them because I saw that Greg
> > has already queued these before anyone had any time to actually
> > review the posting. Hence the timing of the release of unreviewed
> > patches has been taken completely out of our control, and so I
> > rushed through them and misinterpreted what I was seeing.
> >
> > That's not how the review process is supposed to work. You need to
> > wait for people to review the changes and ACK them before then
> > asking for them to be merged into the stable trees. You need to have
> > changelogs in your summary letters. You need to do all the things
> > that you've been complaining bitterly about over the past month that
> > upstream developers weren't doing 18 months ago.
>
> I thought these had already been reviewed, which is why I took them.
>
> And there still are days before these go anywhere, just adding them to
> the stable queue doesn't mean they are "set in stone".
>
> Heck, even if they do get merged into a stable release, 'git revert' is
> our friend here, and we can easily revert anything that is found to be
> wrong.
>
> > And I notice that you've already sent out yet another set of stable
> > patches for review despite the paint not even being dry on these
> > ones. Not to mention that there's a another set of different 5.15
> > stable patches out for review as well.
> >
> > This is not a sustainable process.
> >
> > Seriously: slow down and stop being so damn aggressive. Let everyone
> > catch up and build sustainable processes and timetables. If you keep
> > going like this, you are going break people.
>
> What am I supposed to do here, not take patches you all send me?  Wait
> X number of days?
>
> totally confused,

I think the above was addressing me.
I should be managing the review and grace period of xfs stable candidates
for 5.10 and should adapt my rhythm to the xfs developers requests.

When I send patches to stable, they are supposed to be good to go,
so you should not worry about that.

The patches in this posting are according to xfs developers suggestion
as elaborated in the cover letter, but there was a breakage in my process
that caused this alarm.

I am going to fix it going forward.

Thanks,
Amir.
