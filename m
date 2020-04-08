Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E92F1A1E0D
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 11:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgDHJcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 05:32:41 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35764 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgDHJcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 05:32:41 -0400
Received: from zn.tnic (p200300EC2F0A9300FDE94558DB0629D0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9300:fde9:4558:db06:29d0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BCABF1EC0C89;
        Wed,  8 Apr 2020 11:32:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1586338358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPiVn5HowtJr85j+TBk0a/GUa/dBFzq/G2s+PBaU0UM=;
        b=i2+/LJpzUTxmAF6wtYN+zAH1EbcY0+wvaJ8uqCEqmQUqo7MiaWnH1wPSPmdVFgmWHgBsq+
        6zfY44nvZjY2KVzGmNAOLoYSH53Ib6Wd05eJvn6ohvs4XFNYDk4Pn9hzxRxOYl+LsYKlIh
        L9x3m87CrvfeT5rmxFSr1Uv2a0HT0HU=
Date:   Wed, 8 Apr 2020 11:32:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200408093235.GB24663@zn.tnic>
References: <877dyqkj3h.fsf@nanos.tec.linutronix.de>
 <F2BD5266-A9E5-41C8-AC64-CC33EB401B37@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F2BD5266-A9E5-41C8-AC64-CC33EB401B37@amacapital.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 09:48:02PM -0700, Andy Lutomirski wrote:
> I’m fine with the flow being different. do_machine_check() could
> have entirely different logic to decide the error in PV.

Nope, do_machine_check() is already as ugly as it gets. I don't want any
more crap in it.

> But I think we should reuse the overall flow: kernel gets #MC with
> RIP pointing to the offending instruction. If there’s an extable
> entry that can handle memory failure, handle it. If it’s a user
> access, handle it. If it’s an unrecoverable error because it was a
> non-extable kernel access, oops or panic.
>
> The actual PV part could be extremely simple: the host just needs to
> tell the guest “this #MC is due to memory failure at this guest
> physical address”. No banks, no DIMM slot, no rendezvous crap
> (LMCE), no other nonsense. It would be nifty if the host also told the
> guest what the guest virtual address was if the host knows it.

It better be a whole different path and a whole different vector. If you
wanna keep it simple and apart from all of the other nonsense, then you
can just as well use a completely different vector.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
