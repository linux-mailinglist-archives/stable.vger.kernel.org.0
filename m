Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5413F2B40
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 13:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhHTLc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 07:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237382AbhHTLc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 07:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71ABD610CC;
        Fri, 20 Aug 2021 11:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629459108;
        bh=KQXkS9mXnPZ+2hdBi04FLv6M0CuQq8GXP59msSXono0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lpyvJeyAhrYPFiN9a/qVPoEMLPuQOxMgpHSuB8t1hOgSqRsyY6Tm9alMOMCMQxd3X
         nLOPqx9WowKNRhamGBcFQZf9zJFzFUS9eHBKNdei/Py7k4qen+pNhj2/rmRbHqHslp
         8DJh4vDGfz4lhQDl1OcOHxla69u74UKngfAsohCXparbuSJ/g0Mfyb84pk6UrnkjLA
         3XN0ojtv5qRKZkf8ADbm4530ztpIlQQUdgtSLm26mFUbcJ9xnMetmzP4+FZWbG+lz1
         uqHeWWNpBxhbnHxTJZq6nHlJVOQRe1LSfsupGR8GtlUJkyOZqXJ0kBY/mCoLuEIQoi
         q6TzX+cIgHNIQ==
Received: by mail-ot1-f54.google.com with SMTP id w22-20020a056830411600b0048bcf4c6bd9so12740327ott.8;
        Fri, 20 Aug 2021 04:31:48 -0700 (PDT)
X-Gm-Message-State: AOAM53236kv4A4+QcJROj1ww1llUKXMUzD2j2UbHydIiQHLZcj9Jmymk
        SEHo6v52mcpIAM0etZYp1foXh9ZmKXa3EdC9zHA=
X-Google-Smtp-Source: ABdhPJyPhYRA3r15yMZqhHXUxWdV3Z1lg00AZooAEARRBgDfws9xnfjE4jkzS14ez0v9lVyI0/K1he0InW26AZcPer4=
X-Received: by 2002:a9d:5c2:: with SMTP id 60mr15903635otd.77.1629459107634;
 Fri, 20 Aug 2021 04:31:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210820073429.19457-1-joro@8bytes.org> <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
 <YR9tSuLyX8QHV5Pv@8bytes.org> <f68a175362984e4abbb0a1da2004c936@AcuMS.aculab.com>
 <YR+Bxgq4aIo1DI8j@8bytes.org>
In-Reply-To: <YR+Bxgq4aIo1DI8j@8bytes.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 20 Aug 2021 13:31:36 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHj12FQn_488V_9k9k_LE51K=7n3sS9QnN9gkhBgzw-Kw@mail.gmail.com>
Message-ID: <CAMj1kXHj12FQn_488V_9k9k_LE51K=7n3sS9QnN9gkhBgzw-Kw@mail.gmail.com>
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before ExitBootServices()
To:     Joerg Roedel <joro@8bytes.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Aug 2021 at 12:19, Joerg Roedel <joro@8bytes.org> wrote:
>
> On Fri, Aug 20, 2021 at 09:02:46AM +0000, David Laight wrote:
> > So allocate and initialise the Linux IDT - so entries can be added.
> > But don't execute 'lidt' until later on.
>
> The IDT is needed in this path to handle #VC exceptions caused by CPUID
> instructions. So loading the IDT later is not an option.
>

That does raise a question, though. Does changing the IDT interfere
with the ability of the UEFI boot services to receive and handle the
timer interrupt? Because before ExitBootServices(), that is owned by
the firmware, and UEFI heavily relies on it for everything (event
handling, polling mode block/network drivers, etc)

If restoring the IDT temporarily just papers over this by creating
tiny windows where the timer interrupt starts working again, this is
bad, and we need to figure out another way to address the original
problem.
