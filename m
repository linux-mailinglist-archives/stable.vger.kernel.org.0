Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A71364DC7
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 00:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhDSWoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 18:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhDSWoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 18:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 105936135F;
        Mon, 19 Apr 2021 22:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618872214;
        bh=CqHZjPLE80okJQ486afd8bucyyQF8IksEf+78iGykKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iHPa2MFg6ZF/YRuxhRjkQF7sPHHL91Cjfs2JA9KD62WYZ4ptd6PkS5uUkjAtWKcJy
         mp3bq0n7rT7WBq92hnGpF9d3vfrZeuT/DawIPpfhJkZKRurRSIiM8nVk6NSPx92AM+
         Ek8selLvx8qfoT+OQNXfvcQoc66fPyS58T68M7B5bINOe2EdrLDL0FKC1elQleJiHn
         Jn+1Qk82WWEMn0TAbNytxWsKR/j9kCM/qzf4E3pHe/ONddCAxnw8wiyikjUbUBRLvv
         sEXs4fLmdKf6Woe9z6p9uyOQhLSLDzt5OAfYP1PVJVrF2d9B+skZrkuyHbyj1VVV7I
         p0GEyuAbO52KA==
Date:   Mon, 19 Apr 2021 18:43:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Patch "KVM: VMX: Convert vcpu_vmx.exit_reason to a union" has
 been added to the 5.10-stable tree
Message-ID: <YH4HlIEvoqHWFtz+@sashalap>
References: <20210419002733.D5675610CB@mail.kernel.org>
 <YH38CpPjGSsSRUgt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YH38CpPjGSsSRUgt@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 09:54:18PM +0000, Sean Christopherson wrote:
>+Paolo
>
>On Sun, Apr 18, 2021, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     KVM: VMX: Convert vcpu_vmx.exit_reason to a union
>>
>> to the 5.10-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      kvm-vmx-convert-vcpu_vmx.exit_reason-to-a-union.patch
>> and it can be found in the queue-5.10 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>I'm not sure we want this going into stable kernels, even for 5.10 and 5.11.
>I assume it got pulled in to resolve a conflict with commit 04c4f2ee3f68 ("KVM:
>VMX: Don't use vcpu->run->internal.ndata as an array index"), but that's should

Right.

>be trivial to resolve since it's just a collision with surrounding code.

That's probably right too.

>Maybe we'll end up with a more painful conflict in the future that would be best
>solved by grabbing this refactoring, but I don't think we're there yet.

This is the tricky part: when we start having these conflicts it's
usually too late to refactor, no one cares, and backports just don't
happen.

I'd actually point to the file shuffling (commits like a821bab2d1ee
("KVM: VMX: Move VMX specific files to a "vmx" subdirectory")) you did a
few years ago in arch/x86/kvm/ as an example to why we can't wait: those
changes made a lot of sense upstream, but for stable kernels it meant
that patches were now trying to touch the wrong files and would often
fail or do the wrong thing.

On hindsight, we probably should have moved files around in stable trees
as well to match what upstream had, but at this point it's too late to
go back and fix that, and we're stuck manually editing paths for the
lifetime of most of the LTS trees.

-- 
Thanks,
Sasha
