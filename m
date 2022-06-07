Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C256B53F5E3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 08:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbiFGGKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 02:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbiFGGKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 02:10:01 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748F8A8695;
        Mon,  6 Jun 2022 23:10:00 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id bj33so6768917vkb.12;
        Mon, 06 Jun 2022 23:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNP+/aiDSZmQj5Q9vK/A8mfM/f+ezUW2eGs0EmxXPaE=;
        b=D+fbDzm5ff/z3r00EXjNHqeHY3ziY7vc5lx0Ve8TZNwfYd+YnVEBRga9famwyCVMh3
         BBrdJ9U0QWnt6etPc0A5WV8V4OqYGd2FwcFfq07NdF6Kz5HriOBecFGH4Wj2PD/Zd/9p
         HxJG9wMIlDgYKJ3h9+0tcsGV2B85WV+WeN+mnofka+5C5ORyL/5/9AXMILIRX0bm946s
         TKeHj71z6fwtUW8DVlvYOyd9FDouUs9WuBPP85KsXKwU/Vi3m4xZY4bdq8YaDNK8cZJN
         W+kX1Cgl9GaTp6hGFwVNHOIvLB4ht0KWbwXuFJmrMLdoG/BpY3OM6B/8knfq9kTpznBn
         o3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNP+/aiDSZmQj5Q9vK/A8mfM/f+ezUW2eGs0EmxXPaE=;
        b=UzZ4bx8Zrb24BDrPJv9pzC+5OwTjDL7+3JwG7gCvL0N49gXI9oeemH+CCFNjUgNrue
         yKozdCl3vopHLwmY5PfzS7B2AANnghSu/OKqYZNUumKqqXM7ghhw9y9yqZKsehaCc6+D
         snEHV5AERtH7wT1ZXvtqMXYfvU3gRd+XyoP9fW6oRxd7fa1ldxRhTBtINGgx9+qvyBcW
         89yR6Dh9grygIIoE3ZijoP+dJ69vngchE6ANyGJK+yg0xOGwMcyMLexudt/w5Y9TpGnC
         ZYYhxfmfjQpRdURzhibuKS+P9a2v9ksEYo8ifsBomQhlcLv3NC9peg45guwvZUYHWgwE
         D7dg==
X-Gm-Message-State: AOAM531g5Qg7aGQU8ZKKPti6Ks7OLErHtuhz7nXgxiU5r37SwnJ1nKWW
        kzNVh/h049rhoi/c/z3OUfbNu+hP2L8c+bBaE0JVpPbcxGHJBrgw
X-Google-Smtp-Source: ABdhPJzEV6nPCU/zsT6+CvbV29dvuQfaXGO4MBfjT7yqIEduNB7WrrYwE5/OIHVDUV+RB1Jr715R1c86Rb5f1TQZWxY=
X-Received: by 2002:a05:6122:509:b0:35d:9478:ac57 with SMTP id
 x9-20020a056122050900b0035d9478ac57mr6990206vko.11.1654582199534; Mon, 06 Jun
 2022 23:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220606143255.685988-1-amir73il@gmail.com> <20220606143255.685988-9-amir73il@gmail.com>
 <20220606213042.GS227878@dread.disaster.area> <CAOQ4uxhCjLoYOd7X-yFQOA24YtychwKz3wUfX79zUwFs2o3ziw@mail.gmail.com>
 <20220607030147.GU227878@dread.disaster.area>
In-Reply-To: <20220607030147.GU227878@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Jun 2022 09:09:47 +0300
Message-ID: <CAOQ4uxgP_knOriJPyU6PS_TYhsMRfAJon2nsJ2FO34SUbY6Ygw@mail.gmail.com>
Subject: Re: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should
 take into account error
To:     Dave Chinner <david@fromorbit.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Dave Chinner <dchinner@redhat.com>,
        Theodore Tso <tytso@mit.edu>
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

On Tue, Jun 7, 2022 at 6:01 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Jun 07, 2022 at 01:33:06AM +0300, Amir Goldstein wrote:
> > On Tue, Jun 7, 2022 at 12:30 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Mon, Jun 06, 2022 at 05:32:55PM +0300, Amir Goldstein wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.
> > > >
> > > > xfs/538 on a 1kB block filesystem failed with this assert:
> > > >
> > > > XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448
> > >
> > > You haven't mentioned that you combined a second upstream
> > > commit into this patch to fix the bug in this commit.....
> > >
> >
> > I am confused.
> >
> > patch [5.10 7/8] xfs: consider shutdown in bmapbt cursor delete assert
> > is the patch that I backported from 5.12 and posted for review.
> > This patch [5.10 8/8] is the patch from 5.19-rc1 that you pointed out
> > that I should take to fix the bug in patch [5.10 7/8].
>
> Sorry, I missed that this was a new patch because the set looked
> the same as the last posting and you said in the summary letter:
>
> "These fixes have been posted to review on xfs list [1]."

Sorry, I forgot to edit this part of the template.

>
> Except this patch *wasn't part of that set*. I mistook it for the
> patch that introduced the assert because I assumed from the above
> statement, the absence of a changelog in cover letter and that you'd
> sent it to Greg meant for inclusion meant *no new patches had been
> added*.
>
> Add to that the fact I rushed through them because I saw that Greg
> has already queued these before anyone had any time to actually
> review the posting. Hence the timing of the release of unreviewed
> patches has been taken completely out of our control, and so I
> rushed through them and misinterpreted what I was seeing.
>
> That's not how the review process is supposed to work. You need to
> wait for people to review the changes and ACK them before then
> asking for them to be merged into the stable trees. You need to have
> changelogs in your summary letters. You need to do all the things
> that you've been complaining bitterly about over the past month that
> upstream developers weren't doing 18 months ago.

Of course I need to do all things.
If I am not doing them it could be because I made a mistake
or misunderstood something.
I am always trying to improve and incorporate feedback on my mistakes.

Regarding changelogs, I do not understand what you mean.
Isn't that a changelog at the bottom of my cover letter?
Do you mean something else?

Regarding explicit ACKs, I wasn't sure what to do.
Ted has asked this on this thread [1].

[1] https://lore.kernel.org/linux-fsdevel/YieG8rZkgnfwygyu@mit.edu/

I asked this in my reply [2] to Darrick's email, but got no reply:

:Should we post to xfs list and wait for explicit ACK/RVB on every patch?
:Should we post to xfs list and if no objections are raised post to stable?

[2] https://lore.kernel.org/linux-xfs/CAOQ4uxjtOJ_=65MXVv0Ry0Z224dBxeLJ44FB_O-Nr9ke1epQ=Q@mail.gmail.com/

Since I had no explicit rules, I used my common sense, which is a recipe
for misunderstandings... :-/

I posted the candidates one week ago, so I thought everyone had the
opportunity to comment.
You gave me comments on patches 1 and 7 so I had assumed that
you had seen the entire series and had no objections to the rest.

I incorporated your feedback and wrote my plans in this email [3]

:Just to make sure we are all on the same page.
:
:I have applied both patches to my test tree:
:1. 1cd738b13ae9 xfs: consider shutdown in bmapbt cursor delete assert
:2. 56486f307100 xfs: assert in xfs_btree_del_cursor should take into
:account error
:
:Patch #2 looks pretty safe and it only affects builds with XFS_WARN/DEBUG,
:so I am not too concerned about a soaking period.
:I plan to send it along with patch #1 to stable after a few more test runs.

Once again, I *assumed* that you saw that because this was part of
an ongoing conversation, not some random email.

4 days later (after more testing) I did what I said I would do
and posted the revised series to stable with feedback incorporated.
This was also detailed in the cover letter to stable.

[3] https://lore.kernel.org/linux-xfs/CAOQ4uxhxLRTUfyhSy9D6nsGdVANrUOgRM8msVPVmFmw0oaky+w@mail.gmail.com/

If this situation repeats itself in the future, I will post v2 to xfs
list first.

>
> And I notice that you've already sent out yet another set of stable
> patches for review despite the paint not even being dry on these
> ones. Not to mention that there's a another set of different 5.15
> stable patches out for review as well.

I will pace myself going forward and collaborate closer with Leah.
I have two years of kernel releases to catch up with, but once we
reach the point of selecting patches from the present releases
Hopefully, some of the reviews for candidates for different LTS
kernels will be shared.

>
> This is not a sustainable process.
>
> Seriously: slow down and stop being so damn aggressive. Let everyone
> catch up and build sustainable processes and timetables. If you keep
> going like this, you are going break people.

I do not want that.

Let me explain my process. As I described in the meta-cover letter [4] for
the multi part series:

:My intention is to post the parts for review on the xfs list on
:a ~weekly basis and forward them to stable only after xfs developers
:have had the chance to review the selection.

[4] https://lore.kernel.org/linux-xfs/20220525111715.2769700-1-amir73il@gmail.com/

To you, it may appear that "paint not even being dry on these ones"
but to me, I perceived part 2 was already out of review and part 3 was already
spinning in xfstests for a week, so I wanted to post those patches
and give as much time for review as needed.

My idea of sustainable was posting ~7 stable candidates per week.
This pace may be a bit higher than normal fixes flow, but I do need
to catch up with 2 years of fixes, so the rate has to be a bit higher
than the normal rate of fixes that go into upstream.

I had to choose something based on no other feedback, but of course
the idea is to take feedback and incorporate it into the process
in order to make it sustainable.

I will do my best to amend the things that were broken in this posting.
I am sure this is not the last time I am going to make mistakes.
I am trying to fix a process that has been broken for years.
I invest a lot of my time and energy in this effort.

My request is that you assume good intentions on my part and if there
are rules that you want me to follow please spell them out, so I won't
end up guessing wrong again.

Thanks,
Amir.
