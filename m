Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC7117972
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 14:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfEHM2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 08:28:31 -0400
Received: from webmail.newmedia-net.de ([185.84.6.166]:52836 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfEHM2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 08:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=IrtOUQ0KzNSaFmEWTYr//AVD9YJKIqSsEkTVPy9gmdo=;
        b=TLavmPmWFIUv/BvB0sJ30rbFZE9SdzoGBQV3wiktmQgm6sw96ECC5TidOyjA4TT7LtrIZ8eyfwvucoMBQZ4H8j+yk1ERSQpdBjPGgFI7w3UjJGc7kliAQ4zmvELGYZURQPZtzWPPUNlVXdACmyYDL9v7Zuvvf1yD3Z47fw4R6Jg=;
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
To:     David Laight <David.Laight@ACULAB.COM>,
        'Jiri Kosina' <jikos@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
 <nycvar.YFH.7.76.1905040849370.17054@cbobk.fhfr.pm>
 <957b01f742ed47d1ac9e0ea1277d155b@AcuMS.aculab.com>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <e95eb45e-8bc6-ec81-fbd2-913f22c4224a@newmedia-net.de>
Date:   Wed, 8 May 2019 14:28:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <957b01f742ed47d1ac9e0ea1277d155b@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [212.111.244.1] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1hOLgY-00006q-2S; Wed, 08 May 2019 14:28:34 +0200
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Am 07.05.2019 um 12:31 schrieb David Laight:
> ...
>> So I don't really see a problem with Andy's patch. If we want to annoy
>> external non-GPL modules as much as possible, sure, that's for a separate
>> discussion though (and I am sure many people would agree to that).
>> Proposal to get rid of EXPORT_SYMBOL in favor of EXPORT_SYMBOL_GPL would
>> be a good start I guess :)
> As a writer on an external non-GPL module I'd point out:
> 1 - Even if we wanted to 'upstream' our code it is very specific
>      and wouldn't really be wanted/accepted.
>      Even if accepted it would always be excluded from builds.
> 2 - It would take man-years to make it meet the kernel code guidelines
>      and to make it portable (from x86).
>      It also contains conditionals because it gets build for windows.
>      I don't like a lot of it.
> 3 - Almost all the calls to kernel functions are through a 'wrapper'
>      file that is compiled on the target system.
>      About the only functions that are directly called are ones like memcpy().
> 4 - It wouldn't be that hard, and would still be GPLv2 if we built
>      two loadable modules, one GPL and one non-GPL and put all our
>      wrapper functions in the GPL one.
>      We'd still need a small wrapper for the non-GPL module, but while
>      Non-GPL modules are supported at all it wouldn't be much work.
> 5 - The continual tweaks for new kernel versions keep us in a job!
>
> Some of the _GPL exports are a PITA:
> - we can't reference count network namespaces (without creating a socket).
> - we can't reference count 'pid' structures making sending signals tricky.
> - I thing the PCIe error handling functions that we ought to be using
>    are GPL.
>
> At the moment we've not needed the fpu :-)
>
> 	David
unfortunatly some does like ZFS which is opensource, but just licensed 
under the wrong copyleft license which cannot be changed that easy.
but its a big loss for the community if such projects get blocked or 
limited by a singe linux developer. but thats just my own oppinion (even 
if not intentionally targeted here of course).
not every project on his planet is a nvidia driver blob. whats most 
important for me is not if its GPL or not. most important is that its 
opensource and copyleft.
so the question is if it isnt possible to create a EXPORT_SYMBOL variant 
which includes acceptable license models, but still restricts 
unacceptable licenses

Sebastian

