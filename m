Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD66559B66F
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 23:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiHUVlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 17:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiHUVlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 17:41:16 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983661EAC0;
        Sun, 21 Aug 2022 14:41:15 -0700 (PDT)
Received: from zn.tnic (p200300ea971b9882329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:9882:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37F911EC02AD;
        Sun, 21 Aug 2022 23:41:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1661118069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KIcMde7mEwkhghZiqNjJmux9e20lzrNLzuoUxjrdEyk=;
        b=fRJjagWVesGdFFoceT6Hc3D7jkvR02MBb5zWtq1w8zsMTxMbd6ZkjyTeAq4arHakBVOn1T
        KHITZZ/q5/4f5Fgkn4htYS/3zm+nTTaVmtGAzqPuPiH+mRCPbc5oOmbZfLlivPD2JBF7nK
        ijtRrQXVmQbuujcURhRd5hUUvnLDGBY=
Date:   Sun, 21 Aug 2022 23:41:04 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/10] x86/mtrr: fix MTRR fixup on APs
Message-ID: <YwKmcFuKlq3/MzVi@zn.tnic>
References: <20220820092533.29420-1-jgross@suse.com>
 <20220820092533.29420-2-jgross@suse.com>
 <YwIkV7mYAC4Ebbwb@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwIkV7mYAC4Ebbwb@zn.tnic>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 02:25:59PM +0200, Borislav Petkov wrote:
> > Fix that by using percpu variables for saving the MSR contents.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> > ---
> > I thought adding a "Fixes:" tag for the kernel's initial git commit
> > would maybe be entertaining, but without being really helpful.
> > The percpu variables were preferred over on-stack ones in order to
> > avoid more code churn in followup patches decoupling PAT from MTRR
> > support.
> 
> So if that thing has been broken for so long and no one noticed, we
> could just as well not backport to stable at all...

Yeah, you can't do that.

The whole day today I kept thinking that something's wrong with this
here. As in, why hasn't it been reported until now.

You say above:

"... for all cpus is racy in case the MSR contents differ across cpus."

But they don't differ:

"7.7.5 MTRRs in Multi-Processing Environments

In multi-processing environments, the MTRRs located in all processors
must characterize memory in the same way. Generally, this means that
identical values are written to the MTRRs used by the processors. This
also means that values CR0.CD and the PAT must be consistent across
processors. Failure to do so may result in coherency violations or loss
of atomicity. Processor implementations do not check the MTRR settings
in other processors to ensure consistency. It is the responsibility of
system software to initialize and maintain MTRR consistency across all
processors."

And you can't have different fixed MTRR type on each CPU - that would
lead to all kinds of nasty bugs.

And here's from a big fat box:

$ rdmsr -a 0x2ff | uniq -c
    256 c00

All 256 CPUs have the def type set to the same thing.

Now, if all CPUs go write that same deftype_lo variable in the
rendezvous handler, the only issue that could happen is if a read
sees a partial write. BUT, AFAIK, x86 doesn't tear 32-bit writes so I
*think* all CPUs see the same value being corrected by using mtrr_state
previously saved on the BSP.

As I said, we should've seen this exploding left and right otherwise...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
