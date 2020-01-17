Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C551814090B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 12:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgAQLgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 06:36:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:55076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgAQLgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 06:36:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D1675AE2C;
        Fri, 17 Jan 2020 11:36:46 +0000 (UTC)
Subject: Re: [PATCH] xen/balloon: Support xend-based toolstack take two
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        stable@vger.kernel.org
References: <20200116170004.14373-1-jgross@suse.com>
 <c29c92e3-eb20-7e0a-0174-ef72398b0998@suse.com>
 <dc509037-a7d6-caa5-8000-28aeb20b638e@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <4ddd12ae-94f7-0b16-346a-46e096d9ae6e@suse.com>
Date:   Fri, 17 Jan 2020 12:36:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <dc509037-a7d6-caa5-8000-28aeb20b638e@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.01.2020 12:31, Jürgen Groß wrote:
> On 17.01.20 12:01, Jan Beulich wrote:
>> On 16.01.2020 18:00, Juergen Gross wrote:
>>> Commit 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
>>> tried to fix a regression with running on rather ancient Xen versions.
>>> Unfortunately the fix was based on the assumption that xend would
>>> just use another Xenstore node, but in reality only some downstream
>>> versions of xend are doing that. The upstream xend does not write
>>> that Xenstore node at all, so the problem must be fixed in another
>>> way.
>>>
>>> The easiest way to achieve that is to fall back to the behavior before
>>> commit 5266b8e4445c ("xen: fix booting ballooned down hvm guest")
>>> in case the static memory maximum can't be read.
>>
>> I could use some help here: Prior to said commit there was
>>
>> 	target_diff = new_target - balloon_stats.target_pages;
>>
>>
>> Which is, afaict, ...
>>
>>> --- a/drivers/xen/xen-balloon.c
>>> +++ b/drivers/xen/xen-balloon.c
>>> @@ -94,7 +94,7 @@ static void watch_target(struct xenbus_watch *watch,
>>>   				  "%llu", &static_max) == 1))
>>>   			static_max >>= PAGE_SHIFT - 10;
>>>   		else
>>> -			static_max = new_target;
>>> +			static_max = balloon_stats.current_pages;
>>>   
>>>   		target_diff = (xen_pv_domain() || xen_initial_domain()) ? 0
>>>   				: static_max - balloon_stats.target_pages;
>>
>> ... what the code does before your change. Afaict there was
>> never a use of balloon_stats.current_pages in this function.
> 
> That is a little bit indirect, yes. In the end I want static_max to
> be either the maximum reported by Xen, or if not available, the current
> assumed memory size, which can be found in balloon_stats.current_pages.
> 
> The main idea is to avoid a negative target_diff which would result in
> not ballooning down.

All understood. Yet the change is then not a restore of prior behavior
(just in a limited case), but a change to behavior that we never there
before. I.e. it was indeed my assumption that the code was right, but
the description was misleading.

Jan
