Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0664C29F
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 22:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbfFSU6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 16:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfFSU6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 16:58:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C603C21537;
        Wed, 19 Jun 2019 20:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560977894;
        bh=aYg/sTVU65HHiixNvY6+FyAH1oDzCKShkVfE8+f7/U4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZRtFMO63Vr7KPDW9JiHCkNGlt80pn2y5A01fDkEofS64Jc2r+/ButcKf8xxwk9org
         IVWrQy8BX1If/XJkoqiUfWSQ/uNhWenJSjmnq+EsLbPGvGJwileSMMt23aNaUvFQhP
         AX6P3VK+1+XP6BZ/tplDYNKQn9jjy7oTMIyNifwI=
Date:   Wed, 19 Jun 2019 16:58:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 17/49] efi/x86/Add missing error handling to
 old_memmap 1:1 mapping code
Message-ID: <20190619205812.GE2226@sasha-vm>
References: <20190608114232.8731-1-sashal@kernel.org>
 <20190608114232.8731-17-sashal@kernel.org>
 <CAKv+Gu9ZJ42=NJWDX4+DgkMWaSEakNw-yYiUtsUE48D-V6=7-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9ZJ42=NJWDX4+DgkMWaSEakNw-yYiUtsUE48D-V6=7-w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 08:14:29PM +0200, Ard Biesheuvel wrote:
>On Sat, 8 Jun 2019 at 13:43, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Gen Zhang <blackgod016574@gmail.com>
>>
>> [ Upstream commit 4e78921ba4dd0aca1cc89168f45039add4183f8e ]
>>
>> The old_memmap flow in efi_call_phys_prolog() performs numerous memory
>> allocations, and either does not check for failure at all, or it does
>> but fails to propagate it back to the caller, which may end up calling
>> into the firmware with an incomplete 1:1 mapping.
>>
>> So let's fix this by returning NULL from efi_call_phys_prolog() on
>> memory allocation failures only, and by handling this condition in the
>> caller. Also, clean up any half baked sets of page tables that we may
>> have created before returning with a NULL return value.
>>
>> Note that any failure at this level will trigger a panic() two levels
>> up, so none of this makes a huge difference, but it is a nice cleanup
>> nonetheless.
>>
>> [ardb: update commit log, add efi_call_phys_epilog() call on error path]
>>
>> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Rob Bradford <robert.bradford@intel.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: linux-efi@vger.kernel.org
>> Link: http://lkml.kernel.org/r/20190525112559.7917-2-ard.biesheuvel@linaro.org
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This was already discussed in the thread that proposed this patch for
>stable: please don't queue this right now, the patches are more likely
>to harm than hurt, and they certainly don't fix a security
>vulnerability, as has been claimed.

I've dropped this, thank you.

--
Thanks,
Sasha
