Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED89355AEF
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbhDFSB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 14:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236643AbhDFSB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 14:01:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC282613D4;
        Tue,  6 Apr 2021 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617732109;
        bh=wcmJmM32XVNM7FM06Y3fkyzjESD0AfDNqmejJzodirk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fDGdNFrZiBxgLjN8FYEVewZdlthRjl5VmDMn9/HqVYkoQg8M/FzeBMOQnXmpi+alj
         4NkK0WgOCCkSNBD4ygedZJqhwVdMoqphPjRrp2xe4uQFc/XKdO6LZo+LOQLlVOAxVG
         +Oqi9Apd6pRs5uy3mvKsk08yft4IdKDnGBumePpv8QtnQWPfMVtrZoOTRWnZvy50VD
         AqY8UMgGbvT64zMmdz3rWu0uQ3UQyGcFqjnSsboSbuOlj7yNWfoIzJd0e/yUTAkJVX
         xORFe/0qoINHGreKqSnwxSncmdWUgL4IyvsO+c0muAbwMM2IB9RiitK6glRj7QJ/GG
         U2winEWJOcdCQ==
Date:   Tue, 6 Apr 2021 14:01:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 5.10 096/126] KVM: x86/mmu: Use atomic ops to set SPTEs
 in TDP MMU map
Message-ID: <YGyiDC2iP4CmWgUJ@sashalap>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085034.229578703@linuxfoundation.org>
 <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com>
 <YGxm+WISdIqfwqXD@sashalap>
 <fd2030f3-55ba-6088-733b-ac6a551e2170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fd2030f3-55ba-6088-733b-ac6a551e2170@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 05:48:50PM +0200, Paolo Bonzini wrote:
>On 06/04/21 15:49, Sasha Levin wrote:
>>Yup. Is there anything wrong with those patches?
>
>The big issue, and the one that you ignoredz every time we discuss 
>this topic, is that this particular subset of 17 has AFAIK never been 
>tested by anyone.

Few of the CI systems that run on stable(-rc) releases run
kvm-unit-tests, which passed. So yes, this was tested.

>There's plenty of locking changes in here, one patch that you didn't 
>backport has this in its commit message:
>
>   This isn't technically a bug fix in the current code [...] but that
>   is all very, very subtle, and will break at the slightest sneeze,
>
>meaning that the locking in 5.10 and 5.11 was also less robust to 
>changes elsewhere in the code.
>
>Let's also talk about the process and the timing.  I got the "failed 
>to apply" automated message last Friday and I was going to work on the 
>backport today since yesterday was a holiday here.  I was *never* CCed 

There are a few more "FAILED:" mails that need attention that are older
than this one, I hope they're also in the queue.

>on a post of this backport for maintainers to review; you guys 

You're looking at it, this is the -rc cycle for stable kernels.

>*literally* took random subsets of patches from a feature that is new 
>and in active development, and hoped that they worked on a past 
>release.

Right, I looked at what needed to be backported, took it back to 5.4,
and ran kvm-unit-tests on it.

What other hoops should we jump through so we won't need to "hope"
anymore?

>I could be happy because you just provided me with a perfect example 
>of why to use my employer's franken-kernel instead of upstream stable 
>kernels... ;) but this is not how a world-class operating system is 
>developed.  Who cares if a VM breaks or even if my laptop panics; but 
>I'd seriously fear for my data if you applied the same attitude to XFS 
>or ext4fs.
>
>For now, please drop all 17 patches from 5.10 and 5.11.  I'll send a 
>tested backport as soon as possible.

Sure, I'll drop them. Please let us know when a backport is available.

-- 
Thanks,
Sasha
