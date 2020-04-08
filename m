Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373311A1E75
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgDHKB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 06:01:56 -0400
Received: from mail.skyhub.de ([5.9.137.197]:40042 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDHKB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 06:01:56 -0400
Received: from zn.tnic (p200300EC2F0A9300FDE94558DB0629D0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9300:fde9:4558:db06:29d0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F1EBC1EC0A02;
        Wed,  8 Apr 2020 12:01:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1586340115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vNYTeV2b64ZBxmOavtdQ8bkFeF6KZzWWTytnRjR7vL8=;
        b=l0/4LVJWPuFrF7GMaqLg9UPQuF3QuNtio4dgEZosgiwzYEeOHCmk8sIaC3BBFrmBns2qac
        VH1oyLhjdpkJVZbcd49C5lhyP673vvZjLT/JBLfQCejHbh8S095gXtx9k516KWG++Kk7kI
        Lo79YX7Rnim0kCCtTbyzXiFaEX4cEYw=
Date:   Wed, 8 Apr 2020 12:01:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200408100151.GD24663@zn.tnic>
References: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
 <20200407224903.GC64635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200407224903.GC64635@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 06:49:03PM -0400, Vivek Goyal wrote:
> > 2. Access to bad memory results in #MC.  Sure, #MC is a turd, but it’s an *architectural* turd. By all means, have a nice simple PV mechanism to tell the #MC code exactly what went wrong, but keep the overall flow the same as in the native case.
> > 
> 
> Should we differentiate between two error cases. In this case memory is
> not bad. Just that page being asked for can't be faulted in anymore. And
> another error case is real memory failure. So for the first case it
> could be injected into guest using #PF or #VE or something paravirt
> specific and real hardware failures take #MC path (if they are not
> already doing so).

For handling memory failures with guests there's this whole thing
described Documentation/vm/hwpoison.rst and KVM has support for that.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
