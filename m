Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AF942C6AE
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhJMQsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhJMQsf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 12:48:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA9E760E54;
        Wed, 13 Oct 2021 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634143592;
        bh=gZxxSZNJVcGCly4XUFrQovq9UG2RxCIqbq1MKEQS/DU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O8z+AEdyWQ6c+sX1kouv5fa84k9VD/agQAO02nF8IUy8VyqZP+619NH/GUhVr9GDQ
         w0/ECZ7foV62zyo40t7ZDAgGpP5JgaaC2KMP68dtGYFwLqMOFk/+/NG92Y64F9N29q
         nWBiqWDgNaxD3BR0vE7hT1+oDbMWWrlZrxljB8lQ=
Date:   Wed, 13 Oct 2021 18:46:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jane Malalane <jane.malalane@citrix.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YWcNZdyULbJG5xVA@kroah.com>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013142230.10129-1-jane.malalane@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 03:22:30PM +0100, Jane Malalane wrote:
> Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
> makes it unsafe to migrate in a virtualised environment as the
> properties across the migration pool might differ.
> 
> To be specific, the case which goes wrong is:
> 
> 1. Zen1 (or earlier) and Zen2 (or later) in a migration pool
> 2. Linux boots on Zen2, probes and finds the absence of X86_BUG_NULL_SEL
> 3. Linux is then migrated to Zen1
> 
> Linux is now running on a X86_BUG_NULL_SEL-impacted CPU while believing
> that the bug is fixed.
> 
> The only way to address the problem is to fully trust the "no longer
> affected" CPUID bit when virtualised, because in the above case it would
> be clear deliberately to indicate the fact "you might migrate to
> somewhere which has this behaviour".
> 
> Zen3 adds the NullSelectorClearsBase bit to indicate that loading
> a NULL segment selector zeroes the base and limit fields, as well as
> just attributes. Zen2 also has this behaviour but doesn't have the
> NSCB bit.
> 
> Signed-off-by: Jane Malalane <jane.malalane@citrix.com>
> ---
> CC: <x86@kernel.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Pu Wen <puwen@hygon.cn>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <seanjc@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Andrew Cooper <andrew.cooper3@citrix.com>
> CC: Yazen Ghannam <Yazen.Ghannam@amd.com>
> CC: Brijesh Singh <brijesh.singh@amd.com>
> CC: Huang Rui <ray.huang@amd.com>
> CC: Andy Lutomirski <luto@kernel.org>
> CC: Kim Phillips <kim.phillips@amd.com>
> CC: <stable@vger.kernel.org>

These need to go above the --- line, otherwise they are cut off when
the patch is applied and you will loose the cc: stable@ tag.

thanks,

greg k-h
