Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34C3FEE47
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 15:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhIBNFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 09:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234054AbhIBNFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 09:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C1BA6103A;
        Thu,  2 Sep 2021 13:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630587850;
        bh=lAur5pEMYxaqCJf0nTMHvSdCTSt3rlwHW8WbUrhzaDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IDdU7WC2b+uj4hbkE0V8+o84zEMvEwKRTgcHwVZZHNnFxXvoYqRJd56g29ZeelnCS
         a5xW1rS5KmqtC/0eqURxzs9XQexutyrb1ywE6v+atHdEzpH4QIvC5AeujxOadUvGAt
         pJZj62BkGe+ulku78tshX6dOvmqO80bZrATDkb5oig1wFF9m7tbNpJznkDPIWRkkJP
         DGxAq1HW+k2ki4RCGZ36MP9uir3HV2tYheDNu3OzoumvQISeGjeHIgE9NYw5bcugsh
         NDn+YLvgPkUoC3VgnIWJMc1ShxXWSHbOPrvCrijASR7pBEc5/fuVllf8KOGBfnuMf/
         J0OdpeLpWEjMA==
Date:   Thu, 2 Sep 2021 09:04:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com,
        Alexey Gladkov <legion@kernel.org>
Subject: Re: [PATCH 5.10 036/103] ucounts: Increase ucounts reference counter
 before the security hook
Message-ID: <YTDLyU2mdeoe5cVt@sashalap>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122301.773759848@linuxfoundation.org>
 <87v93k4bl6.fsf@disp2133>
 <YS+s+XL0xXKGwh9a@kroah.com>
 <875yvk1a31.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <875yvk1a31.fsf@disp2133>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 12:26:10PM -0500, Eric W. Biederman wrote:
>Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
>> On Wed, Sep 01, 2021 at 09:25:25AM -0500, Eric W. Biederman wrote:
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>>
>>> > From: Alexey Gladkov <legion@kernel.org>
>>> >
>>> > [ Upstream commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb ]
>>> >
>>> > We need to increment the ucounts reference counter befor security_prepare_creds()
>>> > because this function may fail and abort_creds() will try to decrement
>>> > this reference.
>>>
>>> Has the conversion of the rlimits to ucounts been backported?
>>>
>>> Semantically the code is an improvement but I don't know of any cases
>>> where it makes enough of a real-world difference to make it worth
>>> backporting the code.
>>>
>>> Certainly the ucount/rlimit conversions do not meet the historical
>>> criteria for backports.  AKA simple obviously correct patches.
>>>
>>> The fact we have been applying fixes for the entire v5.14 stabilization
>>> period is a testament to the code not quite being obviously correct.
>>>
>>> Without backports the code only affects v5.14 so I have not been
>>> including a Cc stable on any of the commits.
>>>
>>> So color me very puzzled about what is going on here.
>>
>> Sasha picked this for some reason, but if you think it should be
>> dropped, we can easily do so.
>
>My question is what is the reason Sasha picked this up?
>
>If this patch even applies to v5.10 the earlier patches have been
>backported.  So we can't just drop this patch.  Either the earlier
>backports need to be reverted, or we need to make certain all of the
>patches are backported.
>
>I really am trying to understand what is going on and why.

I'll happily explain. The commit message is telling us that:

1. There is an issue uncovered by syzbot which this patch fixes:

	"Reported-by: syzbot"

2. The issue was introduced in 905ae01c4ae2 ("Add a reference to ucounts
for each cred"):

	"Fixes: 905ae01c4ae2"

Since 905ae01c4ae2 exist in 5.10, and this patch seemed to fix an issue,
I've queued it up.

In general, if we're missing backports, backported something only
partially and should revert it, or anything else that might cause an
issue, we'd be more than happy to work with you to fix it up.

All the patches we queue up get multiple rounds of emails and reviews,
if there is a better way to solicit reviews so that we won't up in a
place where you haven't noticed something going in earlier we'd be more
than happy to improve that process too.

-- 
Thanks,
Sasha
