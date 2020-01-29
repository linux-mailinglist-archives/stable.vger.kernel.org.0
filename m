Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C1D14D10A
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 20:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgA2TMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 14:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgA2TMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 14:12:05 -0500
Received: from localhost (unknown [155.52.187.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DF6205F4;
        Wed, 29 Jan 2020 19:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580325124;
        bh=ZznyVoYeo/nOfJUiB0+J9gkC+ikPfyQGiotvsICxSPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oV+Jug30rmSiFU85nWkPUIYxzQ+8qnaR0/FLP1fB1ooLq87uZR1vfXKUnbR0ZG9P+
         UzNIN/LnvIHoROapa8zHt6wM88fcpUPc/02uilPpxeOm+zF7w9w41Q12rpszvLW6us
         OZ3BldRQhO+7ZQC+0cnVjYwmuk6fXlWHnBCpltTE=
Date:   Wed, 29 Jan 2020 14:12:03 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Voegtle <tv@lio96.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Steve French <smfrench@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        David Laight <David.Laight@aculab.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 4.9 183/271] signal: Allow cifs and drbd to receive their
 terminating signals
Message-ID: <20200129191203.GA2896@sasha-vm>
References: <20200128135852.449088278@linuxfoundation.org>
 <20200128135906.176803329@linuxfoundation.org>
 <alpine.LSU.2.21.2001291201030.14408@er-systems.de>
 <20200129113643.GB5277@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200129113643.GB5277@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 12:36:43PM +0100, Greg Kroah-Hartman wrote:
>On Wed, Jan 29, 2020 at 12:10:47PM +0100, Thomas Voegtle wrote:
>> On Tue, 28 Jan 2020, Greg Kroah-Hartman wrote:
>>
>> > From: Eric W. Biederman <ebiederm@xmission.com>
>> >
>> > [ Upstream commit 33da8e7c814f77310250bb54a9db36a44c5de784 ]
>> >
>> > My recent to change to only use force_sig for a synchronous events
>> > wound up breaking signal reception cifs and drbd.  I had overlooked
>> > the fact that by default kthreads start out with all signals set to
>> > SIG_IGN.  So a change I thought was safe turned out to have made it
>> > impossible for those kernel thread to catch their signals.
>> >
>> > Reverting the work on force_sig is a bad idea because what the code
>> > was doing was very much a misuse of force_sig.  As the way force_sig
>> > ultimately allowed the signal to happen was to change the signal
>> > handler to SIG_DFL.  Which after the first signal will allow userspace
>> > to send signals to these kernel threads.  At least for
>> > wake_ack_receiver in drbd that does not appear actively wrong.
>> >
>> > So correct this problem by adding allow_kernel_signal that will allow
>> > signals whose siginfo reports they were sent by the kernel through,
>> > but will not allow userspace generated signals, and update cifs and
>> > drbd to call allow_kernel_signal in an appropriate place so that their
>> > thread can receive this signal.
>> >
>> > Fixing things this way ensures that userspace won't be able to send
>> > signals and cause problems, that it is clear which signals the
>> > threads are expecting to receive, and it guarantees that nothing
>> > else in the system will be affected.
>> >
>> > This change was partly inspired by similar cifs and drbd patches that
>> > added allow_signal.
>> >
>> > Reported-by: ronnie sahlberg <ronniesahlberg@gmail.com>
>> > Reported-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
>> > Tested-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
>> > Cc: Steve French <smfrench@gmail.com>
>> > Cc: Philipp Reisner <philipp.reisner@linbit.com>
>> > Cc: David Laight <David.Laight@ACULAB.COM>
>> > Fixes: 247bc9470b1e ("cifs: fix rmmod regression in cifs.ko caused by force_sig changes")
>> > Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")
>>
>> These two commits come with that release, but...
>>
>> > Fixes: fee109901f39 ("signal/drbd: Use send_sig not force_sig")
>> > Fixes: 3cf5d076fb4d ("signal: Remove task parameter from force_sig")
>>
>> ...these two commits not and were never added to 4.9.y.
>>
>> Are these both really not needed?
>
>I don't think so, do you feel otherwise?

Both of those commits read as a cleanup to me. I've actually slightly
modified to patch to not need those commits (they were less than trivial
to backport as is).

-- 
Thanks,
Sasha
