Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78D9413B53
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhIUU3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhIUU3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:29:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDCCC061574;
        Tue, 21 Sep 2021 13:27:46 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632256064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUZoMfwEcfPfeLuGk2EFaP58Bnu+SHtciLXgKuOk21Q=;
        b=JRAsG3P2GwfdINWMv4KcitfGWdpHMW/RioiI7K5/scm6W3Vcm1l0rzkNsGw/42Eh8xMhCA
        one7Bv1o0Dta06VF6LXAe8YUX6dlxDBG2F7YEzLR/WJhdxuaLQfghcnpGMHNk5lu9nGVYk
        o6bOyG9FlAwXwGWQUDswHSXN6j1okgVaoVAibqwu3KEgkhvYEslplwV7VPBVnnG4YytUYM
        FpOrY7g7pNyR67a/eNQ7KXsd5+4Fd+mEldezq69Z8YanJ33vLYkj52qChnBqtVM0v2ROLu
        1fMXZ8HzZLTyLOqsyS2D4Rowbk2Vc1Sfkgqj3QDdTfaDfReeec1pYqpbgjNA0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632256064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUZoMfwEcfPfeLuGk2EFaP58Bnu+SHtciLXgKuOk21Q=;
        b=pzl2WCj1z5sHljOygoGKUl9QwW7hVFcX2kl/hNhzAsCMgG5D85Qx9rgZvligzs5D9IbFiK
        RtiMlKL1zOdwcGAQ==
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
In-Reply-To: <YUowhlVfLiLWE8K/@sashalap>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx> <YURQ4ZFDJ8E9MJZM@kroah.com> <87sfy38p1o.ffs@tglx>
 <YUSyKQwdpfSTbQ4H@kroah.com> <87ee9n80gz.ffs@tglx>
 <YUYJ8WeOzPVwj16y@kroah.com> <YUibLGZAVgqiyCUq@sashalap>
 <YUowhlVfLiLWE8K/@sashalap>
Date:   Tue, 21 Sep 2021 22:27:44 +0200
Message-ID: <87sfxx65dr.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21 2021 at 15:20, Sasha Levin wrote:
> On Mon, Sep 20, 2021 at 10:31:08AM -0400, Sasha Levin wrote:
>>On Sat, Sep 18, 2021 at 05:46:57PM +0200, Greg Kroah-Hartman wrote:
>>>On Fri, Sep 17, 2021 at 09:29:32PM +0200, Thomas Gleixner wrote:
>>>>
>>>>I guess I was not able to express myself correctly. What I wanted to say
>>>>is:
>>>>
>>>>  1) Default is AUTOSEL
>>>>
>>>>  2) Maintainer can take files/subsystems out of AUTOSEL completely
>>>>
>>>>     Exists today
>>>>
>>>>  3) Maintainer allows AUTOSEL, but anything picked from files/subsystems
>>>>     without a stable tag requires an explicit ACK from the maintainer
>>>>     for the backport.
>>>>
>>>>     Is new and I would be the first to opt-in :)
>>>>
>>>>My rationale for #3 is that even when being careful about stable tags,
>>>>it happens that one is missing. Occasionaly AUTOSEL finds one of those
>>>>in my subsystems which I appreciate.
>>>>
>>>>Does that make more sense now?
>>>
>>>Ah, yes, that makes much more sense, sorry for the confusion.
>>>
>>>Sasha, what do you think?  You are the one that scripts all of this, not
>>>me :)
>>
>>I could give it a go. It adds some complexity here but is probably worth
>>it to avoid issues.
>>
>>Let me think about the best way to go about it.
>
> So I'm thinking of yet another patch series that would go out, but
> instead of AUTOSEL it'll be tagged with "MANUALSEL". It would work the
> exact same way as AUTOSEL, without the final step of queueing up the
> commits into the stable trees.
>
> Thomas, do you want to give it a go? Want to describe how I filter for
> commits you'd be taking care of? In the past I'd grep a combo of paths
> and committers (i.e. net/ && davem@), but you have your hands in too
> many things :)

Indeed. :(

So pretty much all what matches in MAINTAINERS entries where my name
happened to end up for some reasons. That would be a good start.

Might be a bit overbroad as it also includes x86/kvm, x86/xen, x86/pci
which I'm not that involved with, but to make it simple for you, I just
volunteered the relevant maintainers (CCed) to participate in that
experiment. :)

Thanks,

        tglx






