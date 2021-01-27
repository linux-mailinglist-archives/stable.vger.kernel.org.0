Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4CF305946
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbhA0LKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:10:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:54362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236279AbhA0LHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 06:07:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611745604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9BfLkLQdjj0OzAFEJF9f+Qg7XTvKtRcmUILuOWbVks=;
        b=XWeu3n0ouxXotBVDY+RrYIDAM0D9Br1XmKQMPLmZ357oGh/Xf09PGtWno/x2MIcK1E8jrX
        +IF477QpMFmqj2/nI5PecGCefx5RwIrvZGokdUXxB0wJW/okEwQ5s5D9TKa7Ru6gmP6p2K
        U6T139FTZwpYfKAyRrKXiTa2do1ih1A=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31CE4AD26;
        Wed, 27 Jan 2021 11:06:44 +0000 (UTC)
Subject: Re: [PATCH v2] x86/xen: avoid warning in Xen pv guest with
 CONFIG_AMD_MEM_ENCRYPT enabled
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
References: <20210127093822.18570-1-jgross@suse.com>
 <fb2305a4-4741-c641-9639-5b17b63f2baf@citrix.com>
 <2dc49fae-bf35-7c7d-2d86-338665db27ca@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <a83aa5b1-87b7-bed3-e462-6bd5f854757c@suse.com>
Date:   Wed, 27 Jan 2021 12:06:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2dc49fae-bf35-7c7d-2d86-338665db27ca@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.01.2021 11:26, Jürgen Groß wrote:
> On 27.01.21 10:43, Andrew Cooper wrote:
>> On 27/01/2021 09:38, Juergen Gross wrote:
>>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
>>> index 4409306364dc..ca5ac10fcbf7 100644
>>> --- a/arch/x86/xen/enlighten_pv.c
>>> +++ b/arch/x86/xen/enlighten_pv.c
>>> @@ -583,6 +583,12 @@ DEFINE_IDTENTRY_RAW(xenpv_exc_debug)
>>>   		exc_debug(regs);
>>>   }
>>>   
>>> +DEFINE_IDTENTRY_RAW(exc_xen_unknown_trap)
>>> +{
>>> +	/* This should never happen and there is no way to handle it. */
>>> +	panic("Unknown trap in Xen PV mode.");
>>
>> Looks much better.  How about including regs->entry_vector here, just to
>> short circuit the inevitable swearing which will accompany encountering
>> this panic() ?
> 
> You are aware the regs parameter is struct pt_regs *, not the Xen
> struct cpu_user_regs *?
> 
> So I have no idea how I should get this information without creating
> a per-vector handler.

Maybe log _RET_IP_ then (ideally decoded to a symbol), to give at
least some hint as to where this was coming from?

Jan
