Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19C537546
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfFFNdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:33:17 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33402 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfFFNdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 09:33:17 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so214017iop.0
        for <stable@vger.kernel.org>; Thu, 06 Jun 2019 06:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LICG7LyYRegHk0gizJ6+YVphD3sD9b2EcqyptANH5VA=;
        b=Bm3HuTgbxiIuolrksAP1v2xaxhmqw5HyJBzy6tZ5ISlQGhaD5dlCKhPSqCZAmfCdBT
         Y3nhADXbKk2+RNsEYDvIw8JHYnKW8wY/EXIbUl5V9RO3w3r3k/0ArS+dbbFYuwSAxvIz
         8HjmC2BA8210Snce8YOVqRxcOQNcsMq6XpGv/pguY/U51uc+qVcEy6kAp7ohCG5rlVFM
         fny/iJ1HtG+VwHAsCJ3V4wC2cztSOCEheL3HbrVmTyPsLb9l2UK25I7iPVyj7MJX6AEq
         KxMAUtB7jkBAED+6JmJoaoHAzO3diul0+1ie7BCl95lIIzSJOiE+aUh+yMaC7nxNmZ07
         7bBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LICG7LyYRegHk0gizJ6+YVphD3sD9b2EcqyptANH5VA=;
        b=BaS/iXRUttQY0POGNs7R/yruL5FZHrX+qdBKswX23rUJTDAzzWVoHJ25rhz1a1+5D3
         +HLZNAqLJ6w1X4Ew3KnZd+PN3aRZliV3VJV5Hbtoqc4UDEj7bSxKq+ig9XMSl3W7za1U
         1Qs5DKEZpkq7xaUrRVsn15wySDcRokW5D7Ru/I7IeqYz9MHaDBPQNt2MQc0/ptovx+w/
         kyQw33Vqp+4OtIsCho0anoHCTSJZvEnVKWEy5XorVmG3BUrkeEd9QbGvnqF/CiIa8E1s
         IviguylqgizWadXdioDpPbeATsdjGHvNmnvHJ0wrjmYr9tb1TiyBG8fLgOa41OavuOtN
         4M7Q==
X-Gm-Message-State: APjAAAXRl41LC7FT83sGC4E2ePcG630/tFHgYgBpBWnAj12zxUe6DESM
        n2VAZ10cbdVfsqUB/MtpKhTmcedaXil/+bh31H2gLA==
X-Google-Smtp-Source: APXvYqwg/wQ503rZeaJrQAOciNpTBMRROOthsgSwvYIMNByaFY9/2AK5WES9V4+EyRwvZU1NOn2o9P4VzHHhmEi6OxY=
X-Received: by 2002:a5d:968e:: with SMTP id m14mr200099ion.49.1559827996395;
 Thu, 06 Jun 2019 06:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190606102513.16321-1-ard.biesheuvel@linaro.org> <20190606132251.GK29739@sasha-vm>
In-Reply-To: <20190606132251.GK29739@sasha-vm>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 6 Jun 2019 15:33:04 +0200
Message-ID: <CAKv+Gu-5ePLME942n9Dy139Tv-d=spfNrD_XcRkURpZdkukAag@mail.gmail.com>
Subject: Re: [PATCH for-4.9-stable] efi/libstub: Unify command line param parsing
To:     Sasha Levin <sashal@kernel.org>
Cc:     Rolf Eike Beer <eb@emlix.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jun 2019 at 15:22, Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, Jun 06, 2019 at 12:25:13PM +0200, Ard Biesheuvel wrote:
> >Commit 60f38de7a8d4e816100ceafd1b382df52527bd50 upstream.
> >
> >Merge the parsing of the command line carried out in arm-stub.c with
> >the handling in efi_parse_options(). Note that this also fixes the
> >missing handling of CONFIG_CMDLINE_FORCE=y, in which case the builtin
> >command line should supersede the one passed by the firmware.
> >
> >Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >Cc: Linus Torvalds <torvalds@linux-foundation.org>
> >Cc: Matt Fleming <matt@codeblueprint.co.uk>
> >Cc: Peter Zijlstra <peterz@infradead.org>
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Cc: bhe@redhat.com
> >Cc: bhsharma@redhat.com
> >Cc: bp@alien8.de
> >Cc: eugene@hp.com
> >Cc: evgeny.kalugin@intel.com
> >Cc: jhugo@codeaurora.org
> >Cc: leif.lindholm@linaro.org
> >Cc: linux-efi@vger.kernel.org
> >Cc: mark.rutland@arm.com
> >Cc: roy.franz@cavium.com
> >Cc: rruigrok@codeaurora.org
> >Link: http://lkml.kernel.org/r/20170404160910.28115-1-ard.biesheuvel@linaro.org
> >Signed-off-by: Ingo Molnar <mingo@kernel.org>
> >[ardb: fix up merge conflicts with 4.9.180]
> >Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >---
> >This fixes the GCC build issue reported by Eike.
> >
> >Note that testing of arm64 stable kernels should cover CONFIG_RANDOMIZE_BASE,
> >since it has a profound impact on how the kernel binary gets put together.
>
> Should this fix be applied to 4.9 as well?
>
> I see it in 4.14+
>

I don't understand this question. The fix is proposed for v4.9 because
it fixes a build error with GCC that was caused by a backport of one
of the clang enablement patches.
