Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAE5445A6
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392618AbfFMQp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbfFMGCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 02:02:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2075220896;
        Thu, 13 Jun 2019 06:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560405726;
        bh=TXtG/kXxwoMwfJBQteqaS2UMIYCH5nRvTGbOqKyX0sI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ty+bxaddMpURmOU3MOKTA0CE15kFYaX1d8Sgb2tvh2k8dT0S99hDihB3yk78N0LvD
         yoy5OS4vp5RZT8LV8W4gFaNu+e3uUB7uWy99g429klyYh4Wf3DQDlKx05waunqBA3G
         QwaSMR5S7z7gfHIBsthY0RR5J/QmUbCKMQrQvMBc=
Date:   Thu, 13 Jun 2019 08:02:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>,
        linux-fsdevel@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        linux-ext4@vger.kernel.org, cgroups@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, amakhalov@vmware.com,
        anishs@vmware.com, srivatsab@vmware.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Message-ID: <20190613060203.GA25205@kroah.com>
References: <a04368ba-f1d5-8f2c-1279-a685a137d024@csail.mit.edu>
 <E270AD92-943E-4529-8158-AB480D6D9DF8@linaro.org>
 <5b71028c-72f0-73dd-0cd5-f28ff298a0a3@csail.mit.edu>
 <FFA44D26-75FF-4A8E-A331-495349BE5FFC@linaro.org>
 <0d6e3c02-1952-2177-02d7-10ebeb133940@csail.mit.edu>
 <7B74A790-BD98-412B-ADAB-3B513FB1944E@linaro.org>
 <6a6f4aa4-fc95-f132-55b2-224ff52bd2d8@csail.mit.edu>
 <7c5e9d11-4a3d-7df4-c1e6-7c95919522ab@csail.mit.edu>
 <20190612130446.GD14578@quack2.suse.cz>
 <dd32ed59-a543-fc76-9a9a-2462f0119270@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd32ed59-a543-fc76-9a9a-2462f0119270@csail.mit.edu>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 12:36:53PM -0700, Srivatsa S. Bhat wrote:
> 
> [ Adding Greg to CC ]
> 
> On 6/12/19 6:04 AM, Jan Kara wrote:
> > On Tue 11-06-19 15:34:48, Srivatsa S. Bhat wrote:
> >> On 6/2/19 12:04 AM, Srivatsa S. Bhat wrote:
> >>> On 5/30/19 3:45 AM, Paolo Valente wrote:
> >>>>
> >> [...]
> >>>> At any rate, since you pointed out that you are interested in
> >>>> out-of-the-box performance, let me complete the context: in case
> >>>> low_latency is left set, one gets, in return for this 12% loss,
> >>>> a) at least 1000% higher responsiveness, e.g., 1000% lower start-up
> >>>> times of applications under load [1];
> >>>> b) 500-1000% higher throughput in multi-client server workloads, as I
> >>>> already pointed out [2].
> >>>>
> >>>
> >>> I'm very happy that you could solve the problem without having to
> >>> compromise on any of the performance characteristics/features of BFQ!
> >>>
> >>>
> >>>> I'm going to prepare complete patches.  In addition, if ok for you,
> >>>> I'll report these results on the bug you created.  Then I guess we can
> >>>> close it.
> >>>>
> >>>
> >>> Sounds great!
> >>>
> >>
> >> Hi Paolo,
> >>
> >> Hope you are doing great!
> >>
> >> I was wondering if you got a chance to post these patches to LKML for
> >> review and inclusion... (No hurry, of course!)
> >>
> >> Also, since your fixes address the performance issues in BFQ, do you
> >> have any thoughts on whether they can be adapted to CFQ as well, to
> >> benefit the older stable kernels that still support CFQ?
> > 
> > Since CFQ doesn't exist in current upstream kernel anymore, I seriously
> > doubt you'll be able to get any performance improvements for it in the
> > stable kernels...
> > 
> 
> I suspected as much, but that seems unfortunate though. The latest LTS
> kernel is based on 4.19, which still supports CFQ. It would have been
> great to have a process to address significant issues on older
> kernels too.
> 
> Greg, do you have any thoughts on this? The context is that both CFQ
> and BFQ I/O schedulers have issues that cause I/O throughput to suffer
> upto 10x - 30x on certain workloads and system configurations, as
> reported in [1].
> 
> In this thread, Paolo posted patches to fix BFQ performance on
> mainline. However CFQ suffers from the same performance collapse, but
> CFQ was removed from the kernel in v5.0. So obviously the usual stable
> backporting path won't work here for several reasons:
> 
>   1. There won't be a mainline commit to backport from, as CFQ no
>      longer exists in mainline.
> 
>   2. This is not a security/stability fix, and is likely to involve
>      invasive changes.
> 
> I was wondering if there was a way to address the performance issues
> in CFQ in the older stable kernels (including the latest LTS 4.19),
> despite the above constraints, since the performance drop is much too
> significant. I guess not, but thought I'd ask :-)

If someone cares about something like this, then I strongly just
recommend they move to the latest kernel version.  There should not be
anything stoping them from doing that, right?  Nothing "forces" anyone
to be on the 4.19.y release, especially when it really starts to show
its age.

Don't ever treat the LTS releases as "the only thing someone can run, so
we must backport huge things to it!"  Just use 5.1, and then move to 5.2
when it is out and so on.  That's always the preferred way, you always
get better support, faster kernels, newer features, better hardware
support, and most importantly, more bugfixes.

I wrote a whole essay on this thing, but no one ever seems to read it...

thanks,

greg k-h
