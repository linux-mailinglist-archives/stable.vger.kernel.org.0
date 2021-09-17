Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFED940FFD9
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 21:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhIQTa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 15:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343584AbhIQTa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 15:30:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22C0C061574;
        Fri, 17 Sep 2021 12:29:34 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631906973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZJyonWjUJqp33h5nUgUsFw+D5tDs8cR6dvgzEeDcL8A=;
        b=RKPsuqMQecuWhWbWS0nseNBvi3nfvJ6orZIaLFbV9JMftA/RQGbp9Y5D7TxazENjyuCUrD
        +5bNvwis2vYKNVPwCgHJfgDJykf5f2GzSDEy+BZIz0s2bC5DhMg3/Osrna323YWfEl51fq
        2l94kSeP/aKzJE0maWDk0TQSpy+H67xBGkynB+RmlYOFtDkHygzBvtrnjTFfMo9FHXXKy5
        cpz57nyLnw/eLhcYoh5noy0i9IGGgNWAbiabhFXykdJSuv9sNIsYRbgPIFGEG6viHpkjT1
        DQJHChTvNCNyNbsEp5ahh1l+jc6TceyvVIlkFb1ji4wBtwPL6kQOBtR1WeCl6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631906973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZJyonWjUJqp33h5nUgUsFw+D5tDs8cR6dvgzEeDcL8A=;
        b=T/p89ji9mfa/f6OBteH0r5U1TKp7p4cPaHOUqxVU/JhamWd4Vb44QnICgTv1Rwgk8EmkvZ
        ljKF/+aGf434rMDw==
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
In-Reply-To: <YUSyKQwdpfSTbQ4H@kroah.com>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx> <YURQ4ZFDJ8E9MJZM@kroah.com> <87sfy38p1o.ffs@tglx>
 <YUSyKQwdpfSTbQ4H@kroah.com>
Date:   Fri, 17 Sep 2021 21:29:32 +0200
Message-ID: <87ee9n80gz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

On Fri, Sep 17 2021 at 17:20, Greg Kroah-Hartman wrote:
> On Fri, Sep 17, 2021 at 12:38:43PM +0200, Thomas Gleixner wrote:
>> Nah. I try to pay more attention. I'm not against AUTOSEL per se, but
>> could we change the rules slightly?
>> 
>> Any change which is selected by AUTOSEL and lacks a Cc: stable@... is
>> put on hold until acked by the maintainer unless it is a prerequisite
>> for applying a stable tagged fix?
>> 
>> This can be default off and made effective on maintainer request.
>> 
>> Hmm?
>
> The whole point of the AUTOSEL patches are for the huge numbers of
> subsystems where maintainers and developers do not care about the stable
> trees at all, and so they do not mark patches to be backported.  So
> requireing an opt-in like this would defeat the purpose.
>
> We do allow the ability to take files/subsystems out of the AUTOSEL
> process as there are many maintainers that do do this right and get
> annoyed when patches are picked that they feel shouldn't have.  That's
> the best thing we can do for stuff like this.

I guess I was not able to express myself correctly. What I wanted to say
is:

  1) Default is AUTOSEL

  2) Maintainer can take files/subsystems out of AUTOSEL completely

     Exists today

  3) Maintainer allows AUTOSEL, but anything picked from files/subsystems
     without a stable tag requires an explicit ACK from the maintainer
     for the backport.

     Is new and I would be the first to opt-in :)

My rationale for #3 is that even when being careful about stable tags,
it happens that one is missing. Occasionaly AUTOSEL finds one of those
in my subsystems which I appreciate.

Does that make more sense now?

Thanks,

        tglx
