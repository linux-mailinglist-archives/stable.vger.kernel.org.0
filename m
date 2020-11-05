Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC132A8AE0
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 00:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbgKEXoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 18:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKEXoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 18:44:24 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D37C0613CF;
        Thu,  5 Nov 2020 15:44:23 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id n63so2478677qte.4;
        Thu, 05 Nov 2020 15:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sVuBclz6RbxFeixVrFDk7hds/nyx+Jqtd3Wi799FOXk=;
        b=cDRnrACB6qhyOyott6SFEmFabDoLiuFl1tpaN50TvPHswUHt3+MPuJohwfZ41EFnrw
         LsucrypTMbdc4g1ars45fh1+/jqITRsgaDt5QqVzlBHIAT+wL4Je5jnmf2R5ETn5E8H9
         vruyY4XQ/S8SkVqOsjVyqhA30aDVXcXV0SNl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVuBclz6RbxFeixVrFDk7hds/nyx+Jqtd3Wi799FOXk=;
        b=kzqbSD/rTBoXALnjdfTtMmJDMk8CBJpXlpSuIg1cMpCQqiHZnPJaccrDGo90c9nxaW
         k+x2QYLNYuuM5/W2AWHIJ5LGOJs32lVbJ5uF3wt2+jdVYPf2qXQLXASsIpuIWZisZHvN
         Ud7LoK16MXL4d6SpsVzFcn8U1E16uGRYV7Vez/A2hpBVwdVhK60SP50+md1EGd+Q9Dal
         hBtqnDGHY9pSz05qBr7ISaCUN+89DeYZpSJk65GlspLDS2hmsZgpuXKaln24HYRjDqSs
         Jps6Q2gRU6wj6ndvP0rLKhVA2eXp4siFOUdM1QRMCEpk791i3UO3t23D2gKTP8+bKK/p
         8f9Q==
X-Gm-Message-State: AOAM533bwNY/0FBVOsek4J8Zb6XUb9MEXhWcPd1DXHKWzyNE+rDsNUIH
        fkW8PKHxbF91VkBFvdUczAlMzEdxygkXl7xDxgc=
X-Google-Smtp-Source: ABdhPJzMkAsXAUa+nOhKuwacsfqZM5SZmXB8PE7v6p8ZThh7YcBqN1EAFeRO4VOrULqUrC3Iwdn4kG3AtWfac6tiRt8=
X-Received: by 2002:ac8:75c9:: with SMTP id z9mr4663191qtq.363.1604619862999;
 Thu, 05 Nov 2020 15:44:22 -0800 (PST)
MIME-Version: 1.0
References: <20201103203232.656475008@linuxfoundation.org> <20201103203247.174991659@linuxfoundation.org>
 <20201105192305.GA18462@duo.ucw.cz>
In-Reply-To: <20201105192305.GA18462@duo.ucw.cz>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 5 Nov 2020 23:44:11 +0000
Message-ID: <CACPK8XcOqdtGyJ+Fcan=AaHiJTOZFeUW7-j_5kZeQowr-j24Ag@mail.gmail.com>
Subject: Re: [PATCH 4.19 156/191] powerpc: Warn about use of smt_snooze_delay
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Nov 2020 at 19:24, Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> > From: Joel Stanley <joel@jms.id.au>
> >
> > commit a02f6d42357acf6e5de6ffc728e6e77faf3ad217 upstream.
> >
> > It's not done anything for a long time. Save the percpu variable, and
> > emit a warning to remind users to not expect it to do anything.
> >
> > This uses pr_warn_once instead of pr_warn_ratelimit as testing
> > 'ppc64_cpu --smt=off' on a 24 core / 4 SMT system showed the warning
> > to be noisy, as the online/offline loop is slow.
>
> I don't believe this is good idea for stable. It is in 5.9-rc2, and
> likely mainline users will get userspace fixed, but that warning is
> less useful for -stable users.

The warning is about the existing behaviour of the kernel. It does let
the user know that they won't see any difference in behaviour when
tweaking the smt_snooze_delay variable, which was a real issue that
Anton hit.

I agree that the future commit that removes smt_snooze_delay from the
kernel should not be backported.

Cheers,

Joel

>
> (And besides, it does not fix any serious bug).
>
> Best regards,
>                                                                 Pavel
>
> --
> http://www.livejournal.com/~pavelmachek
