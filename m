Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491D7492C4D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 18:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243879AbiARR0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 12:26:53 -0500
Received: from mail.skyhub.de ([5.9.137.197]:44346 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238539AbiARR0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 12:26:53 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 347CD1EC018C;
        Tue, 18 Jan 2022 18:26:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1642526806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CWaM8oIp7o2Aaev/wro+HXQnt9heh/Qc8Sja6PGiC6I=;
        b=Oj2BAifzOwJW2z2oqt8iF5j5YA6Q9zR7oT0UASVq0337uvHudzyu1rba49S7MNCbs3ZE3S
        ah04gGzTqruJ3yc2e/3P+q2BWRYIePZWkaRGtNiH3NhfU7zVeVrShzvFmKrRStPq8/DkLP
        dpQdJ/QpipwyQvGl6KkTvL2GuK0Wa8A=
Date:   Tue, 18 Jan 2022 18:26:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5 1/5] x86/quirks: Fix stolen detection with integrated
 + discrete GPU
Message-ID: <Yeb4WKOFNDNbx6tH@zn.tnic>
References: <20220114002843.2083382-1-lucas.demarchi@intel.com>
 <YeaLIs9t0jhovC28@zn.tnic>
 <20220118163656.fzzkwubgoe5gz36k@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220118163656.fzzkwubgoe5gz36k@ldmartin-desk2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 08:36:56AM -0800, Lucas De Marchi wrote:
> I had the impression the subject/title should be imperative, with it
> more relaxed in the body. It seems we have one more difference among
> subsystems and I will adapt on next submissions to x86.

We have written it down properly, in case it explains it better:

"The tip tree maintainers set value on following these rules, especially
on the request to write changelogs in imperative mood and not
impersonating code or the execution of it. This is not just a whim of
the maintainers. Changelogs written in abstract words are more precise
and tend to be less confusing than those written in the form of novels."

from Documentation/process/maintainer-tip.rst

> > So I wonder: why can't you simply pass in a static struct chipset *
> > pointer into the early_qrk[i].f function and in there you can set
> > QFLAG_APPLIED or so, so that you can mark that the quirk is applied by
> > using the nice, per-quirk flags someone has already added instead of
> > this ugly static variable?
> 
> It seems you prefer v1. See 20211218061313.100571-1-lucas.demarchi@intel.com

I do?

I don't see there:

	early_qrk[i].f(&early_qrk[i], num, slot, func)

so that the ->f callback can set the flags. Or at least the flags passed
in.

If it is not clear what I mean, pls say so and I'll try to produce an
example diff ontop.

> Although in the review Bjorn suggested just splitting the commit, it was
> also mentioned that the PCI subsystem has no such logic in its
> equivalent pci_do_fixups(): a quirk/fixup needing that should instead
> use a static local.

Why?

There's perfectly nice ->flags there for exactly stuff like that. static
vars are ugly and should be avoided if possible.

> What is special about patch 3?

Nothing special. It is just ugly.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
