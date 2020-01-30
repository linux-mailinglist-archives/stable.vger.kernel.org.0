Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5436714E35F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgA3TvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 14:51:13 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37797 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgA3TvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 14:51:13 -0500
Received: by mail-ed1-f67.google.com with SMTP id cy15so5170514edb.4;
        Thu, 30 Jan 2020 11:51:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ny5vawm1ZMouKeDxshhMVR293h8qWKnN6FtNQJsILb4=;
        b=kZh+JLzy/+gBQVYNkpm2FjZqnjXx8dRvdTABtg1SncnapFb8xPn27HutUBSRbExDOh
         vbcunYNEji9Jcd3znLmWlGYEuk2Cx98pfj5tzdWFqLh7V8xxU+eCI5uhtngUEVzGfYGb
         xluHhSTpUsZ5omVTOYEwVUs0n+Qn8PBs0u7yo6Von2nDpgwcQYI6LKtxM9usAdZjz6c6
         f6K4+LW7bmDTJzFb8trXFkng10UInb03Yrkc6+9qDTFiX1ef6+Y7SGnB4tqVgGorxNha
         A/RdL0Rf4MXVaBlYvyOtFQe6YLih+7n8jCURRYWZIkZGapHJ7kgyZhdyPNEi6qNPNKvP
         6j5g==
X-Gm-Message-State: APjAAAWWbHzgeDqerDk+pShM3GQs3iHXJSs/NDgqNap300BUMvcaumtn
        6Wrlk20RIUjWGGBzgBwJiUQj8BGcOvKzKYceWvg=
X-Google-Smtp-Source: APXvYqwmdihuWIfIpMtcEl+yOF+MTPbo1EVHcr/7fsjX37sNt7zRBu4Tctxr45lo3mz6klL27jRiosvKJ76XPOF2Vgs=
X-Received: by 2002:aa7:d505:: with SMTP id y5mr5551266edq.370.1580413869586;
 Thu, 30 Jan 2020 11:51:09 -0800 (PST)
MIME-Version: 1.0
References: <20191227174055.4923-1-sashal@kernel.org> <20191227174055.4923-16-sashal@kernel.org>
In-Reply-To: <20191227174055.4923-16-sashal@kernel.org>
From:   Len Brown <lenb@kernel.org>
Date:   Thu, 30 Jan 2020 14:50:58 -0500
Message-ID: <CAJvTdKkV4GgnE80PKuUFogR=Q+77-z5YHLhCaCSW=rjaV1owzQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 016/187] x86/intel: Disable HPET on Intel Ice
 Lake platforms
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, feng.tang@intel.com,
        harry.pan@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Can somebody point to an ICL system that is running production-level
firmware that exhibits this issue?

The hardware people are telling me that zero such systems should exist.

(The reported symptom that I've seen is that the TSC vs HPET
comparison fails, and Linux keeps the (bad) HPET and disables the
(good) TSC)

thanks,
-Len

On Fri, Dec 27, 2019 at 12:41 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>
> [ Upstream commit e0748539e3d594dd26f0d27a270f14720b22a406 ]
>
> Like CFL and CFL-H, ICL SoC has skewed HPET timer once it hits PC10.
> So let's disable HPET on ICL.
>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: bp@alien8.de
> Cc: feng.tang@intel.com
> Cc: harry.pan@intel.com
> Cc: hpa@zytor.com
> Link: https://lkml.kernel.org/r/20191129062303.18982-2-kai.heng.feng@canonical.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/kernel/early-quirks.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 606711f5ebf8..2f9ec14be3b1 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -714,6 +714,8 @@ static struct chipset early_qrk[] __initdata = {
>                 PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>         { PCI_VENDOR_ID_INTEL, 0x3ec4,
>                 PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
> +       { PCI_VENDOR_ID_INTEL, 0x8a12,
> +               PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>         { PCI_VENDOR_ID_BROADCOM, 0x4331,
>           PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
>         {}
> --
> 2.20.1
>


-- 
Len Brown, Intel Open Source Technology Center
