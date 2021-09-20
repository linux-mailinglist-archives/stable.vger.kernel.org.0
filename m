Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31E5411712
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 16:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbhITOch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 10:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237053AbhITOcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 10:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA2C60E76;
        Mon, 20 Sep 2021 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632148269;
        bh=3dmn2ESyInoHV7ZvI5AvHLnNmL2juxEiVTBz45sOKcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tkgRUSSaoa/wVrUelusV2Lh+tn7C4Lsaf1XytpyDtJdH+O0P3CGjFgZdgxPxE6Af7
         QlobpPoxEe7uiIya6pvIR1uUVZiyxfbdIj+UYBlI8ofLMPvhHF1QMFO4/5DAHtKQA1
         Fnu05PIpfN8Tz6fkw1hIr9dkyptKKgi86DM6eNpzua3/ff5zbf/BZ3LZD6UsVyDTZR
         WW5oQEpU2p0ViAewhwtE39IpbK6IGG8OHlZopsy4tuglDGk0ULzuGQmJfqrZXg06Vz
         eBQV50Jr0KYnxnr5N6K96VwTrj75feRVirgvB44H8WoCVWIUlTLtJKJwPckdYv1LwV
         a9Ah66zye7dnw==
Date:   Mon, 20 Sep 2021 10:31:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
Message-ID: <YUibLGZAVgqiyCUq@sashalap>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx>
 <YURQ4ZFDJ8E9MJZM@kroah.com>
 <87sfy38p1o.ffs@tglx>
 <YUSyKQwdpfSTbQ4H@kroah.com>
 <87ee9n80gz.ffs@tglx>
 <YUYJ8WeOzPVwj16y@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YUYJ8WeOzPVwj16y@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 18, 2021 at 05:46:57PM +0200, Greg Kroah-Hartman wrote:
>On Fri, Sep 17, 2021 at 09:29:32PM +0200, Thomas Gleixner wrote:
>> Greg,
>>
>> On Fri, Sep 17 2021 at 17:20, Greg Kroah-Hartman wrote:
>> > On Fri, Sep 17, 2021 at 12:38:43PM +0200, Thomas Gleixner wrote:
>> >> Nah. I try to pay more attention. I'm not against AUTOSEL per se, but
>> >> could we change the rules slightly?
>> >>
>> >> Any change which is selected by AUTOSEL and lacks a Cc: stable@... is
>> >> put on hold until acked by the maintainer unless it is a prerequisite
>> >> for applying a stable tagged fix?
>> >>
>> >> This can be default off and made effective on maintainer request.
>> >>
>> >> Hmm?
>> >
>> > The whole point of the AUTOSEL patches are for the huge numbers of
>> > subsystems where maintainers and developers do not care about the stable
>> > trees at all, and so they do not mark patches to be backported.  So
>> > requireing an opt-in like this would defeat the purpose.
>> >
>> > We do allow the ability to take files/subsystems out of the AUTOSEL
>> > process as there are many maintainers that do do this right and get
>> > annoyed when patches are picked that they feel shouldn't have.  That's
>> > the best thing we can do for stuff like this.
>>
>> I guess I was not able to express myself correctly. What I wanted to say
>> is:
>>
>>   1) Default is AUTOSEL
>>
>>   2) Maintainer can take files/subsystems out of AUTOSEL completely
>>
>>      Exists today
>>
>>   3) Maintainer allows AUTOSEL, but anything picked from files/subsystems
>>      without a stable tag requires an explicit ACK from the maintainer
>>      for the backport.
>>
>>      Is new and I would be the first to opt-in :)
>>
>> My rationale for #3 is that even when being careful about stable tags,
>> it happens that one is missing. Occasionaly AUTOSEL finds one of those
>> in my subsystems which I appreciate.
>>
>> Does that make more sense now?
>
>Ah, yes, that makes much more sense, sorry for the confusion.
>
>Sasha, what do you think?  You are the one that scripts all of this, not
>me :)

I could give it a go. It adds some complexity here but is probably worth
it to avoid issues.

Let me think about the best way to go about it.

-- 
Thanks,
Sasha
