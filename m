Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D3D3FF9B9
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 07:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhICFBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 01:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhICFBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 01:01:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E98C6056C;
        Fri,  3 Sep 2021 05:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630645212;
        bh=fbMZl8VBOcbMURISC4vnJ6+SwDyWl+Ghz6xF4QwL0ok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+Js2GuiNpgDbIa3uyd5qDH2tXYsWDbamaWkQLwTTSFRg/6s0CqtU1vBZNYNGYI3V
         JjsnfNRGldxAVCWAEGjw5lgWCKwKmdXT7LMui1djr6VivllaN3qzKQSdO7k/JOj5kA
         1klg/0TG9WWnu7cMhkCExmSG8iDWWsSPZP6+OWJ8=
Date:   Fri, 3 Sep 2021 07:00:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com,
        Alexey Gladkov <legion@kernel.org>
Subject: Re: [PATCH 5.10 036/103] ucounts: Increase ucounts reference counter
 before the security hook
Message-ID: <YTGr2ZkgfTCIGVpr@kroah.com>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122301.773759848@linuxfoundation.org>
 <87v93k4bl6.fsf@disp2133>
 <YS+s+XL0xXKGwh9a@kroah.com>
 <875yvk1a31.fsf@disp2133>
 <YTDLyU2mdeoe5cVt@sashalap>
 <875yvizwb9.fsf@disp2133>
 <YTGrQ2D1/tQR1pCh@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTGrQ2D1/tQR1pCh@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 06:57:39AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 02, 2021 at 01:06:34PM -0500, Eric W. Biederman wrote:
> > Sasha Levin <sashal@kernel.org> writes:
> > 
> > > On Wed, Sep 01, 2021 at 12:26:10PM -0500, Eric W. Biederman wrote:
> > >>Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > >>
> > >>> On Wed, Sep 01, 2021 at 09:25:25AM -0500, Eric W. Biederman wrote:
> > >>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > >>>>
> > >>>> > From: Alexey Gladkov <legion@kernel.org>
> > >>>> >
> > >>>> > [ Upstream commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb ]
> > >>>> >
> > >>>> > We need to increment the ucounts reference counter befor security_prepare_creds()
> > >>>> > because this function may fail and abort_creds() will try to decrement
> > >>>> > this reference.
> > >>>>
> > >>>> Has the conversion of the rlimits to ucounts been backported?
> > >>>>
> > >>>> Semantically the code is an improvement but I don't know of any cases
> > >>>> where it makes enough of a real-world difference to make it worth
> > >>>> backporting the code.
> > >>>>
> > >>>> Certainly the ucount/rlimit conversions do not meet the historical
> > >>>> criteria for backports.  AKA simple obviously correct patches.
> > >>>>
> > >>>> The fact we have been applying fixes for the entire v5.14 stabilization
> > >>>> period is a testament to the code not quite being obviously correct.
> > >>>>
> > >>>> Without backports the code only affects v5.14 so I have not been
> > >>>> including a Cc stable on any of the commits.
> > >>>>
> > >>>> So color me very puzzled about what is going on here.
> > >>>
> > >>> Sasha picked this for some reason, but if you think it should be
> > >>> dropped, we can easily do so.
> > >>
> > >>My question is what is the reason Sasha picked this up?
> > >>
> > >>If this patch even applies to v5.10 the earlier patches have been
> > >>backported.  So we can't just drop this patch.  Either the earlier
> > >>backports need to be reverted, or we need to make certain all of the
> > >>patches are backported.
> > >>
> > >>I really am trying to understand what is going on and why.
> > >
> > > I'll happily explain. The commit message is telling us that:
> > >
> > > 1. There is an issue uncovered by syzbot which this patch fixes:
> > >
> > > 	"Reported-by: syzbot"
> > >
> > > 2. The issue was introduced in 905ae01c4ae2 ("Add a reference to ucounts
> > > for each cred"):
> > >
> > > 	"Fixes: 905ae01c4ae2"
> > >
> > > Since 905ae01c4ae2 exist in 5.10, and this patch seemed to fix an issue,
> > > I've queued it up.
> > 
> > Which begs the question as Alex mentioned how did 905ae01c4ae2 get into
> > 5.10, as it was merged to Linus's tree in the merge window for 5.14.
> > 
> > > In general, if we're missing backports, backported something only
> > > partially and should revert it, or anything else that might cause an
> > > issue, we'd be more than happy to work with you to fix it up.
> > >
> > > All the patches we queue up get multiple rounds of emails and reviews,
> > > if there is a better way to solicit reviews so that we won't up in a
> > > place where you haven't noticed something going in earlier we'd be more
> > > than happy to improve that process too.
> > 
> > I have the bad feeling that 905ae01c4ae2 was backported because it was a
> > prerequisite to something with a Fixes tag.
> > 
> > Fixes tags especially in this instance don't mean code needs to go to
> > stable Fixes tags mean that a bug was fixed.  Since I thought the code
> > only existed in Linus's tree, I haven't been adding Cc stable or even
> > thinking about earlier kernels with respect to this code.
> > 
> > I honestly can't keep up with the level of review needed for patches
> > targeting Linus's tree.  So I occasionally glance at patches destined
> > for the stable tree.
> > 
> > Most of the time it is something being backported without a stable tag,
> > but with a fixes tag, that is unnecessary but generally harmless so I
> > ignore it.
> > 
> > In this instance it looks like a whole new feature that has had a rocky
> > history and a lot of time to stablize is somehow backported to 5.10 and
> > 5.13.  I think all of the known issues are addressed but I won't know
> > if all of the issues syzkaller can find are found for another couple of
> > weeks.
> > 
> > Because this code was not obviously correct, because this code did not
> > have a stable tag, because I am not even certain it is stable yet,
> > I am asking do you know how this code that feels to me like feature work
> > wound up being backported?  AKA why is 905ae01c4ae2 in 5.10 and 5.13.
> 
> Looks like Sasha added it to the tree last week and it went out in the
> last set of releases.  Sasha, why was this added?  Let me see if it was
> a requirement of some other patch...

Sorry, no, that was this patch, let me get my coffee before I dig into
this...
