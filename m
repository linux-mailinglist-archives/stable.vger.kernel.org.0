Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB64941AF
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 21:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244067AbiASUaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 15:30:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:57543 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231146AbiASUaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 15:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642624205; x=1674160205;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nfdzBYBqQaqq5ju/KIZ0OGlrsNPW5+aw7QS4ZNf9KN4=;
  b=d7XAprLJZdWnRnGkdemlM+5sZeXKOav1Z+mowjjLfo1UpjY5+F8o0Vk/
   s3zDftfdUDGNaZyqnk5mK9ajF1jKX1PbgS9UF2v3hkg6f8gmFfAYx2GGZ
   fOphQfRHo7o8YJ8yuOEttmBQINJbybqWanr3O41BSYvFpze24uswurF8w
   C0xeeenXeHpLhiCKfWf62e0A/c4amAm9fFANO+tawOC5EyPWy1mlrw3bW
   AaJsIWss4p4fn99hMnc1QgxB90qeaPXdJ3P6inwF94KvitjLUPxsdB+GP
   YWMyu8tuBK9XCdPFO84r+iKbfa2ur2YFpj0eWaXGDp5hMis5G/mlZBJgX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="232550213"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="232550213"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:30:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="693930438"
Received: from atefehad-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.238.132])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:30:04 -0800
Date:   Wed, 19 Jan 2022 12:30:04 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-pci@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] [PATCH v5 1/5] x86/quirks: Fix stolen detection with
 integrated + discrete GPU
Message-ID: <20220119203004.mnds3vrxtsqkvso3@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <YecI6S9Cx5esqL+H@zn.tnic>
 <20220118200145.GA887728@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220118200145.GA887728@bhelgaas>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 02:01:45PM -0600, Bjorn Helgaas wrote:
>On Tue, Jan 18, 2022 at 07:37:29PM +0100, Borislav Petkov wrote:
>> On Tue, Jan 18, 2022 at 11:58:53AM -0600, Bjorn Helgaas wrote:
>> > I don't really care much one way or the other.  I think the simplest
>> > approach is to remove QFLAG_APPLY_ONCE from intel_graphics_quirks()
>> > and do nothing else, as I suggested here:
>> >
>> >   https://lore.kernel.org/r/20220113000805.GA295089@bhelgaas
>> >
>> > Unfortunately that didn't occur to me until I'd already suggested more
>> > complicated things that no longer seem worthwhile to me.
>> >
>> > The static variable might be ugly, but it does seem to be what
>> > intel_graphics_quirks() wants -- a "do this at most once per system
>> > but we don't know exactly which device" situation.
>>
>> I see.
>>
>> Yeah, keeping it solely inside intel_graphics_quirks() and maybe with a
>> comment ontop, why it is done, is simple. I guess if more quirks need
>> this once-thing people might have to consider a more sensible scheme - I
>> was just objecting to sprinkling those static vars everywhere.
>>
>> But your call. :)
>
>Haha :)  I was hoping not to touch it myself because I think this
>whole stolen memory thing is kind of nasty.  It's not clear to me why
>we need it at all, or why we have to keep all this device-specific
>logic in the kernel, or why it has to be an early quirk as opposed to
>a regular PCI quirk.  We had a thread [1] about it a while ago but I
>don't think anything got resolved.

I was reading that thread again and thinking what we could do to try to
resolve this. I will reply on that thread.

>But to try to make forward progress, I applied patch 1/5 (actually,
>the updated one from [2]) to my pci/misc branch with the updated
>commit log and code comments below.

thanks. I found the wording in the title odd as when I read "first" it
gives me the impression it's saying there could be more, which is not
possible.  Anyway, not a big thing. Thanks for rewording it.

Lucas De Marchi
