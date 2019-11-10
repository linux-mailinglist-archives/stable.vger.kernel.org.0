Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604BFF69EF
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 16:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKJP5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 10:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbfKJP5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 10:57:07 -0500
Received: from localhost (unknown [73.61.17.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 693E42077C;
        Sun, 10 Nov 2019 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573401425;
        bh=7PYw9STwXOGUfy5HvFUTGTdM4guCM6cGoVDiFcC/t1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pFHEu2u1qmOImc7R8TT94KsjtNA9EObF9e3nCftwk5/iZUmZlDFnkFgAl/Isu0h0+
         0YOqeJKehsUJu07xn8VsdNVRf29GxsLqOkqnFU3otFoVZFqX4uidiXjwoxrs2MhM6T
         mqvEbU1E4wAg+XDXBYDCOC2T2QzvdA+Sd/6uM4gg=
Date:   Sun, 10 Nov 2019 10:56:55 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 133/191] efi: honour memory reservations
 passed via a linux specific config table
Message-ID: <20191110155655.GO4787@sasha-vm>
References: <20191110024013.29782-1-sashal@kernel.org>
 <20191110024013.29782-133-sashal@kernel.org>
 <CAKv+Gu-PawCS_Wq3Hm+gm_f=6-ihXarkQqP9prkj4CLt=pAnvg@mail.gmail.com>
 <20191110132726.GN4787@sasha-vm>
 <CAKv+Gu_Pg-j6C0iRqa8wSr+=vk3rMQ=KHFykZGNGWMfcYfAjtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Pg-j6C0iRqa8wSr+=vk3rMQ=KHFykZGNGWMfcYfAjtg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 10, 2019 at 02:16:57PM +0000, Ard Biesheuvel wrote:
>On Sun, 10 Nov 2019 at 13:27, Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Sun, Nov 10, 2019 at 08:33:47AM +0100, Ard Biesheuvel wrote:
>> >On Sun, 10 Nov 2019 at 03:44, Sasha Levin <sashal@kernel.org> wrote:
>> >>
>> >> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> >>
>> >> [ Upstream commit 71e0940d52e107748b270213a01d3b1546657d74 ]
>> >>
>> >> In order to allow the OS to reserve memory persistently across a
>> >> kexec, introduce a Linux-specific UEFI configuration table that
>> >> points to the head of a linked list in memory, allowing each kernel
>> >> to add list items describing memory regions that the next kernel
>> >> should treat as reserved.
>> >>
>> >> This is useful, e.g., for GICv3 based ARM systems that cannot disable
>> >> DMA access to the LPI tables, forcing them to reuse the same memory
>> >> region again after a kexec reboot.
>> >>
>> >> Tested-by: Jeremy Linton <jeremy.linton@arm.com>
>> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> >
>> >NAK
>> >
>> >This doesn't belong in -stable, and I'd be interested in understanding
>> >how this got autoselected, and how I can prevent this from happening
>> >again in the future.
>>
>> It was selected because it's part of a fix for a real issue reported by
>> users:
>>
>
>For my understanding, are you saying your AI is reading launchpad bug
>reports etc? Because it is marked AUTOSEL.

Not quite. This review set was me feeding all the patches Ubuntu has on
top of stable trees into AUTOSEL, and sending out the output for review.
I doesn't look into launchpad bug reports on it's own, but in my
experience one can find a bug report for mostly everything AUTOSEL
considers to be a bug.

>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1806766
>>
>
>That pages mentions
>
>"""
>2 upstream patch series are required to fix this:
> https://<email address hidden>/msg10328.html
>Which provides an EFI facility consumed by:
> https://lkml.org/lkml/2018/9/21/1066
>There were also some follow-on fixes to deal with ARM-specific
>problems associated with this usage:
> https://www.spinics.net/lists/arm-kernel/msg685751.html
>"""
>
>and without the other patches, we only add bugs and don't fix any.
>
>> Besides ubuntu, it is also carried by:
>>
>> SUSE: https://www.suse.com/support/update/announcement/2019/suse-su-20191530-1/
>> CentOS: https://koji.mbox.centos.org/koji/buildinfo?buildID=4558
>>
>> As a way to resolve the reported bug.
>>
>
>Backporting a feature/fix like this requires careful consideration of
>the patches involved, and doing actual testing on hardware.
>
>> Any reason this *shouldn't* be in stable?
>
>Yes. By itself, it causes crashes at early boot and does not actually
>solve the problem.

Sure, let's work on gathering all the needed patches then and testing it
out.

>> I'm aware that there might be
>> dependencies that are not obvious to me, but the solution here is to
>> take those dependencies as well rather than ignore the process
>> completely.
>>
>
>This is not a bugfix. kexec/kdump never worked correctly on the
>hardware involved, and backporting a feature like that goes way beyond
>what I am willing to accept for stable backports affecting the EFI
>subsystem.

I'm a bit confused. The bug report starts with:

	[Impact]
	kdump support isn't usable on HiSilicon D05 systems. This
	previously worked in bionic.

So it seems like it did use to work, but not anymore?

Either way, I understand that you want to keep the stable tree
conservative, but keep in mind that the flip side of not taking fixes
that users ask for means that distros end up having to carry them
anyway, which means that they don't get the review and testing they
need.

We can argue all we want around whether it's a fix or not, but if most
distros carry it then I think our argument is moot.

-- 
Thanks,
Sasha
