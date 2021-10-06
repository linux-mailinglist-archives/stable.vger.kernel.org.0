Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897FB424026
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 16:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbhJFOck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 10:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239027AbhJFOcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 10:32:39 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07DAC061749;
        Wed,  6 Oct 2021 07:30:47 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d3600bd612f435519a27c.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:3600:bd61:2f43:5519:a27c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 372F81EC04D1;
        Wed,  6 Oct 2021 16:30:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633530646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QdZGYuaftd42DJ0MByjjUkZipesKts6SrAr4jrdiwrs=;
        b=WifRgTqRqzFdq+cy7RfumA/wTAZ8QGin7R5dF4Ya2A4ZqgrxzQEK5bXemgbnpms/7YoU/g
        Mv5mkrApW3/2G9OdPe3lR1HSUeNLHaDSvo2/Djo555iObx/plrSjqoNwv9jgUa3YDZila1
        Gw755md8Fo2ksxa5Jy0xJg2x73Oo+OU=
Date:   Wed, 6 Oct 2021 16:30:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Jane Malalane <jane.malalane@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YV2zFlaLvZzNPkjh@zn.tnic>
References: <20211001133349.9825-1-jane.malalane@citrix.com>
 <YVcZCgOVkCPz1kwO@zn.tnic>
 <c2d96a84-64d2-b4b4-261d-e98612552ba0@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c2d96a84-64d2-b4b4-261d-e98612552ba0@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 03:15:51PM +0100, Andrew Cooper wrote:
> The case which goes wrong is this:
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
> somewhere which really is affected".

Yap, makes sense.

Thanks for taking the time - that's what I was looking for.

Please add to the commit message of the next version.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
