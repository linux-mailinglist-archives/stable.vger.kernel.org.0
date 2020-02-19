Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137D1163F06
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 09:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgBSI3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 03:29:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:37240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgBSI3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 03:29:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 15EADAD46;
        Wed, 19 Feb 2020 08:29:42 +0000 (UTC)
Subject: Re: [PATCH] x86/ioperm: add new paravirt function update_io_bitmap
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "VMware, Inc." <pv-drivers@vmware.com>, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20200218154712.25490-1-jgross@suse.com>
 <87mu9fr4ky.fsf@nanos.tec.linutronix.de>
 <b0f33786-79b1-f8ee-24ae-ce9f9f4791af@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <e1617641-2106-cd81-628f-569b1a8cf1f7@suse.com>
Date:   Wed, 19 Feb 2020 09:29:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <b0f33786-79b1-f8ee-24ae-ce9f9f4791af@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.02.2020 06:35, Jürgen Groß wrote:
> On 18.02.20 22:03, Thomas Gleixner wrote:
>> Juergen Gross <jgross@suse.com> writes:
>>> Commit 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control
>>> ioperm() as well") reworked the iopl syscall to use I/O bitmaps.
>>>
>>> Unfortunately this broke Xen PV domains using that syscall as there
>>> is currently no I/O bitmap support in PV domains.
>>>
>>> Add I/O bitmap support via a new paravirt function update_io_bitmap
>>> which Xen PV domains can use to update their I/O bitmaps via a
>>> hypercall.
>>>
>>> Fixes: 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control ioperm() as well")
>>> Reported-by: Jan Beulich <jbeulich@suse.com>
>>> Cc: <stable@vger.kernel.org> # 5.5
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>> Reviewed-by: Jan Beulich <jbeulich@suse.com>
>>> Tested-by: Jan Beulich <jbeulich@suse.com>
>>
>> Duh, sorry about that and thanks for fixing it.
>>
>> BTW, why isn't stuff like this not catched during next or at least
>> before the final release? Is nothing running CI on upstream with all
>> that XEN muck active?
> 
> This problem showed up by not being able to start the X server (probably
> not the freshest one) in dom0 on a moderate aged AMD system.

Not the freshest one, yes, but also on a system where KMS would not
be available (my success rate with KMS is rather low overall, and
with newer Linux I see rather more systems to stop working than ones
to become working, but I simply don't have the time to investigate).

Jan
