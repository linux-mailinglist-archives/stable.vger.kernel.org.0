Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837991C063E
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 21:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgD3TXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 15:23:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:33371 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgD3TXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 15:23:01 -0400
IronPort-SDR: LoaaIktz2lRW3Hn7VVfUExgC2h1F1UWWwYb0gIoewBD6zPuCENUSn/iS6SYU+TyQj7e1EagXlv
 0Kt02CZp70PQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 12:23:00 -0700
IronPort-SDR: mmOO9TeGehW6ZKsO2AabJSyPfx1On12iSR7UbQV26uvMH5iIZWkP61nrPG6nfcG9OdZdtKTjq6
 DEfOJCg3MGgg==
X-IronPort-AV: E=Sophos;i="5.73,336,1583222400"; 
   d="scan'208";a="459685832"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 12:22:59 -0700
Date:   Thu, 30 Apr 2020 12:22:58 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Message-ID: <20200430192258.GA24749@agluck-desk2.amr.corp.intel.com>
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
 <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
 <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 11:42:20AM -0700, Andy Lutomirski wrote:
> I suppose there could be a consistent naming like this:
> 
> copy_from_user()
> copy_to_user()
> 
> copy_from_unchecked_kernel_address() [what probe_kernel_read() is]
> copy_to_unchecked_kernel_address() [what probe_kernel_write() is]
> 
> copy_from_fallible() [from a kernel address that can fail to a kernel
> address that can't fail]
> copy_to_fallible() [the opposite, but hopefully identical to memcpy() on x86]
> 
> copy_from_fallible_to_user()
> copy_from_user_to_fallible()
> 
> These names are fairly verbose and could probably be improved.

How about

	try_copy_catch(void *dst, void *src, size_t count, int *fault)

returns number of bytes not-copied (like copy_to_user etc).

if return is not zero, "fault" tells you what type of fault
cause the early stop (#PF, #MC).

-Tony
