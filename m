Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321AF14D320
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 23:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgA2Wfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 17:35:41 -0500
Received: from er-systems.de ([148.251.68.21]:53170 "EHLO er-systems.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgA2Wfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 17:35:41 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id 35E6ED6006D;
        Wed, 29 Jan 2020 23:35:38 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on er-systems.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id 14F3ED6006C;
        Wed, 29 Jan 2020 23:35:38 +0100 (CET)
Date:   Wed, 29 Jan 2020 23:35:35 +0100 (CET)
From:   Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To:     "Eric W. Biederman" <ebiederm@xmission.com>
cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Voegtle <tv@lio96.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?ISO-8859-15?Q?Christoph_B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Steve French <smfrench@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH 4.9 183/271] signal: Allow cifs and drbd to receive their
 terminating signals
In-Reply-To: <87o8um0xnp.fsf@x220.int.ebiederm.org>
Message-ID: <alpine.LSU.2.21.2001292333180.22716@er-systems.de>
References: <20200128135852.449088278@linuxfoundation.org> <20200128135906.176803329@linuxfoundation.org> <alpine.LSU.2.21.2001291201030.14408@er-systems.de> <20200129113643.GB5277@kroah.com> <20200129191203.GA2896@sasha-vm>
 <87o8um0xnp.fsf@x220.int.ebiederm.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-74181308-926108817-1580337338=:22716"
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.102.1/25710/Wed Jan 29 12:38:38 2020 signatures .
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---74181308-926108817-1580337338=:22716
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 29 Jan 2020, Eric W. Biederman wrote:

> Sasha Levin <sashal@kernel.org> writes:
>
>> On Wed, Jan 29, 2020 at 12:36:43PM +0100, Greg Kroah-Hartman wrote:
>>> On Wed, Jan 29, 2020 at 12:10:47PM +0100, Thomas Voegtle wrote:
>>>> On Tue, 28 Jan 2020, Greg Kroah-Hartman wrote:
>>>>
>>>>> From: Eric W. Biederman <ebiederm@xmission.com>
>>>>>
>>>>> [ Upstream commit 33da8e7c814f77310250bb54a9db36a44c5de784 ]
>>>>>
>>>>> My recent to change to only use force_sig for a synchronous events
>>>>> wound up breaking signal reception cifs and drbd.  I had overlooked
>>>>> the fact that by default kthreads start out with all signals set to
>>>>> SIG_IGN.  So a change I thought was safe turned out to have made it
>>>>> impossible for those kernel thread to catch their signals.
>>>>>
>>>>> Reverting the work on force_sig is a bad idea because what the code
>>>>> was doing was very much a misuse of force_sig.  As the way force_sig
>>>>> ultimately allowed the signal to happen was to change the signal
>>>>> handler to SIG_DFL.  Which after the first signal will allow userspace
>>>>> to send signals to these kernel threads.  At least for
>>>>> wake_ack_receiver in drbd that does not appear actively wrong.
>>>>>
>>>>> So correct this problem by adding allow_kernel_signal that will allow
>>>>> signals whose siginfo reports they were sent by the kernel through,
>>>>> but will not allow userspace generated signals, and update cifs and
>>>>> drbd to call allow_kernel_signal in an appropriate place so that their
>>>>> thread can receive this signal.
>>>>>
>>>>> Fixing things this way ensures that userspace won't be able to send
>>>>> signals and cause problems, that it is clear which signals the
>>>>> threads are expecting to receive, and it guarantees that nothing
>>>>> else in the system will be affected.
>>>>>
>>>>> This change was partly inspired by similar cifs and drbd patches that
>>>>> added allow_signal.
>>>>>
>>>>> Reported-by: ronnie sahlberg <ronniesahlberg@gmail.com>
>>>>> Reported-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
>>>>> Tested-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
>>>>> Cc: Steve French <smfrench@gmail.com>
>>>>> Cc: Philipp Reisner <philipp.reisner@linbit.com>
>>>>> Cc: David Laight <David.Laight@ACULAB.COM>
>>>>> Fixes: 247bc9470b1e ("cifs: fix rmmod regression in cifs.ko caused by force_sig changes")
>>>>> Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")
>>>>
>>>> These two commits come with that release, but...
>>>>
>>>>> Fixes: fee109901f39 ("signal/drbd: Use send_sig not force_sig")
>>>>> Fixes: 3cf5d076fb4d ("signal: Remove task parameter from force_sig")
>>>>
>>>> ...these two commits not and were never added to 4.9.y.
>>>>
>>>> Are these both really not needed?
>>>
>>> I don't think so, do you feel otherwise?
>>
>> Both of those commits read as a cleanup to me. I've actually slightly
>> modified to patch to not need those commits (they were less than trivial
>> to backport as is).
>
> All of these changes were cleanup.  Which is why I didn't tag any of
> them for stable.
>
> Not to say that there weren't real problems using force_sig instead
> of send_sig.  force_sig does nothing to ensure the task it is sending
> signals to won't, and hasn't gone away.  Which is why it is a bad
> idea to use force_sig on anything but current.  As I recall drbd used
> force_sig on a kernel_thread which didn't go away.
>
> When fixing the force_sig vs send_sig confusion I didn't realize that
> some places were using force_sig because they had not enabled receiving
> the signals they depended on.  Which is where allow_kernel_signal comes
> from.  But while using force_sig allow_kernel_signal is not necessary.
>
> Eric


Thanks for clarification.


       Thomas

---74181308-926108817-1580337338=:22716--

