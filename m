Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E871B16D4
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 22:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgDTUXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 16:23:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:47233 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDTUXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 16:23:35 -0400
IronPort-SDR: vlQ6p71zo0Bt3ERSVm9sWXDE92Ia/VM+onRrdWRMOcAD9MV1arrMGWQeFTUPOaKWkQ6RIGnFbB
 LjF8+KubFQUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 13:23:34 -0700
IronPort-SDR: dwbx/a0msG2TP6vaKuk6gKGzkILRzrBv45iy3zonm01WA2AXycd2VV41ZeD6i223Je/0lLuoIA
 PjXGlNLibkjw==
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="456502146"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.68])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 13:23:34 -0700
Date:   Mon, 20 Apr 2020 13:23:32 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: Re: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
Message-ID: <20200420202332.GA30160@agluck-desk2.amr.corp.intel.com>
References: <67FF611B-D10E-4BAF-92EE-684C83C9107E@amacapital.net>
 <CAHk-=wjePyyiNZo0oufYSn0s46qMYHoFyyNKhLOm5MXnKtfLcg@mail.gmail.com>
 <CAPcyv4jQ3s_ZVRvw6jAmm3vcebc-Ucf7FHYP3_nTybwdfQeG8Q@mail.gmail.com>
 <CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com>
 <CAPcyv4hrfZsg48Gw_s7xTLLhjLTk_U+PV0MsLnG+xh3652xFCQ@mail.gmail.com>
 <CAHk-=wgcc=5kiph7o+aBZoWBCbu=9nQDQtD41DvuRRrqixohUA@mail.gmail.com>
 <CAPcyv4iTaBNPMwqUwas+J4rxd867QL7JnQBYB8NKnYaTA-R_Tw@mail.gmail.com>
 <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgOUOveRe8=iFWw0S1LSDEjSfQ-4bM64eiXdGj4n7Omng@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 01:07:09PM -0700, Linus Torvalds wrote:
> On Mon, Apr 20, 2020 at 12:29 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> >  I didn't consider asynchronous to be
> > better because that means there is a gap between when the data
> > corruption is detected and when it might escape the system that some
> > external agent could trust the result and start acting on before the
> > asynchronous signal is delivered.
> 
> The thing is, absolutely nobody cares whether you start acting on the
> wrong data or not.

I think they do. If the result of the wrong data has already
been sent out the network before you process the signal, then you
will need far smarter application software than has ever been written
to hunt it down and stop the spread of the bogus result.

Stopping dead on the instruction before it consumes the data
means you can "recover" by killing just one process, or just one
VMM guest.

I'm in total agreement the machine check (especially broadcast)
was a bad choice for how to "stop on a dime". But I can't see
how you could possibly decide what to do if you let thousands
of instructions retire based on a bad data value before you even
know that it happened.

-Tony
