Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74BC443474
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 18:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhKBRUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 13:20:23 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55782 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhKBRUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 13:20:20 -0400
Received: from zn.tnic (p200300ec2f0f6200599060f0a067c463.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:6200:5990:60f0:a067:c463])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0B5881EC011B;
        Tue,  2 Nov 2021 18:17:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635873464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3k4UAR3waP1O7QGWGVCIvAvoqbPAyUfbTyj8oUzmI68=;
        b=SeyOgVQjj3BQhQf5sHXtuXpKsQ++nRNdi9c43JfJi45//PBZmGZ8tAHWFoXXTFS75b2FpU
        nifTwIFZsxidse9XB6WTzJ0MaQjjwyO8b0Nw3BSrGpJb9FoM8urYmB4pdNQ7nUzDej/dYg
        k/eADB0zWg+TZRUOYZNnV0PKhD0DvbM=
Date:   Tue, 2 Nov 2021 18:17:39 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 01/12] kexec: Allow architecture code to opt-out at
 runtime
Message-ID: <YYFys4KnpTftwJRz@zn.tnic>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-2-joro@8bytes.org>
 <YYARccITlowHABg1@zn.tnic>
 <87pmrjbmy9.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87pmrjbmy9.fsf@disp2133>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 04:11:42PM -0500, Eric W. Biederman wrote:
> I seem to remember the consensus when this was reviewed that it was
> unnecessary and there is already support for doing something like
> this at a more fine grained level so we don't need a new kexec hook.

Well, the executive summary is that you have a guest whose memory *and*
registers are encrypted so the hypervisor cannot have a poke inside and
reset the vCPU like it would normally do. So you need to do that dance
differently, i.e, the patchset.

If you try to kexec such a guest now, it'll init only the BSP, as Joerg
said. So I guess a single-threaded kdump.

And yes, one of the prominent use cases is kdumping from such a guest,
as distros love doing kdump for debugging.

I hope that explains it better.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
