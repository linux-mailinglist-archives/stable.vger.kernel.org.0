Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B869E443C0
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392293AbfFMQcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:32:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:44398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730862AbfFMIU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:20:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8C92AD5C;
        Thu, 13 Jun 2019 08:20:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 255091E4328; Thu, 13 Jun 2019 10:20:53 +0200 (CEST)
Date:   Thu, 13 Jun 2019 10:20:53 +0200
From:   Jan Kara <jack@suse.cz>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
Message-ID: <20190613082053.GD26505@quack2.suse.cz>
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
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 12-06-19 12:36:53, Srivatsa S. Bhat wrote:
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

Well, you could still tune the performance difference by changing
slice_idle and group_idle tunables for CFQ (in
/sys/block/<device>/queue/iosched/).  Changing these to lower values will
reduce the throughput loss when switching between cgroups at the cost of
lower accuracy of enforcing configured IO proportions among cgroups.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
