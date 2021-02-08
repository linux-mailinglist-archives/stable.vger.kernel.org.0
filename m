Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C81D313E3A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhBHS4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235738AbhBHS4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:56:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8E564E5A;
        Mon,  8 Feb 2021 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612810536;
        bh=6XeN35G9UlVNuxLXpbyh0VdjeHy0JkSCJxqfLwM5g8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSFMHHFRRY4vi9HgDYo24Ms3T355mSmr8K5TIkkyvsqkjY7J6To0cn8QM6x0sPgDg
         ReQ6LDMf0XNq6Oj/QO5//ArCAWMbunbrDYchVMjBzvYmV9a7Wzdgv2BLSDHdnB+y7K
         oYKzDgxK0+FNsWCe3yrpOZZHXZJf10T8WkZObtw7maeDkU0eCHwkabgdL6PcCOEtC1
         420N6fO6HWXP996jp5yOo7sQ5LWNPNzyQnkbN7QORHf9mZJ4sKJh3YQeuK/RnpwZGX
         Y9gaGqQoYTez4wqPbIY3OSGHmaF3dr6snas+9RyTM3fdsPOCZumoDY9OX05udo/rGX
         adGg7xZrGNMTg==
Date:   Mon, 8 Feb 2021 13:55:35 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 4.9 4/4] init/gcov: allow CONFIG_CONSTRUCTORS on
 UML to fix module gcov
Message-ID: <20210208185535.GB4035784@sasha-vm>
References: <20210208180000.2092497-1-sashal@kernel.org>
 <20210208180000.2092497-4-sashal@kernel.org>
 <69e7fbb93740c0116c358a2f40aadb2dbde702fe.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <69e7fbb93740c0116c358a2f40aadb2dbde702fe.camel@sipsolutions.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 07:25:21PM +0100, Johannes Berg wrote:
>On Mon, 2021-02-08 at 18:00 +0000, Sasha Levin wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> [ Upstream commit 55b6f763d8bcb5546997933105d66d3e6b080e6a ]
>>
>> On ARCH=um, loading a module doesn't result in its constructors getting
>> called, which breaks module gcov since the debugfs files are never
>> registered.  On the other hand, in-kernel constructors have already been
>> called by the dynamic linker, so we can't call them again.
>>
>> Get out of this conundrum by allowing CONFIG_CONSTRUCTORS to be
>> selected, but avoiding the in-kernel constructor calls.
>>
>> Also remove the "if !UML" from GCOV selecting CONSTRUCTORS now, since we
>> really do want CONSTRUCTORS, just not kernel binary ones.
>>
>> Link: https://lkml.kernel.org/r/20210120172041.c246a2cac2fb.I1358f584b76f1898373adfed77f4462c8705b736@changeid
>>
>
>
>While I don't really *object* to this getting backported, it's also a
>(development) corner case that somebody wants gcov and modules in
>ARCH=um ... I'd probably not backport this.

I'll drop it then, thanks!

-- 
Thanks,
Sasha
