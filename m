Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A51D1C092C
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 23:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgD3V0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 17:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3V0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 17:26:07 -0400
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E07621973;
        Thu, 30 Apr 2020 21:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588281966;
        bh=/84uoMk6xtc0fw3gx35sjXWR9jNo9Z9IE9/R9jq5lMw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VRmNr5RBTPhRd60+StAQHWJmGef8T+NugRaofsy+un1Eln/Qcs4JM1XC2p/sLYn+o
         lKmlV2leZcE2oZyhkd5seo9kAxRc6X7RP4T9YeUSEXrx4cYwRvBtcUmD1oyAKT7RNt
         e9jB4IWz1aZpMZLwp3uZYt44ttGWAH7coF9Iuads=
Received: by mail-il1-f172.google.com with SMTP id u189so2818978ilc.4;
        Thu, 30 Apr 2020 14:26:06 -0700 (PDT)
X-Gm-Message-State: AGi0PuYB9ujUa7cYimLfDm1Dpcq3u7GDbIq3gyQMcIOCJ4jn63DBFera
        hG9qEdQOuLzf+m7UkvFig/KrDYqCuaO2I+VrJUI=
X-Google-Smtp-Source: APiQypJyZqcbA2fElVFv1VmD7vn4/0o5hM15ftpa/GSsTlIBinowD3KMADxV8uJ/0nFzxtWYwFn1Um0TP4jV5ka4d54=
X-Received: by 2002:a92:aa0f:: with SMTP id j15mr404629ili.211.1588281964921;
 Thu, 30 Apr 2020 14:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200429190119.43595-1-arnd@arndb.de> <20200430211516.gkwaefjrzj2dypmr@cantor>
 <CAK8P3a1xk9b9Ntsf302EUP2Sp+yWe5UEsbf973=xmYRkiN1KuQ@mail.gmail.com>
In-Reply-To: <CAK8P3a1xk9b9Ntsf302EUP2Sp+yWe5UEsbf973=xmYRkiN1KuQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 30 Apr 2020 23:25:53 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHc0uzzTKp7oj23_=X9ek2KNrKMq1gL09X7cTnjhV=nXQ@mail.gmail.com>
Message-ID: <CAMj1kXHc0uzzTKp7oj23_=X9ek2KNrKMq1gL09X7cTnjhV=nXQ@mail.gmail.com>
Subject: Re: [PATCH] efi/tpm: fix section mismatch warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dave Young <dyoung@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Peter Jones <pjones@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Talbert <swt@techie.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Apr 2020 at 23:21, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Apr 30, 2020 at 11:15 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
> >
> > On Wed Apr 29 20, Arnd Bergmann wrote:
> > >Building with gcc-10 causes a harmless warning about a section mismatch:
> > >
> > >WARNING: modpost: vmlinux.o(.text.unlikely+0x5e191): Section mismatch in reference from the function tpm2_calc_event_log_size() to the function .init.text:early_memunmap()
> > >The function tpm2_calc_event_log_size() references
> > >the function __init early_memunmap().
> > >This is often because tpm2_calc_event_log_size lacks a __init
> > >annotation or the annotation of early_memunmap is wrong.
> > >
> > >Add the missing annotation.
> > >
> > >Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing")
> > >Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > Minor thing, but should the Fixes be c46f3405692d ("tpm: Reserve the TPM final events table")? Or what am I missing
> > about e658c82be556 that causes this? Just trying to understand what I did. :)
>
> You are right, I misread the git history. Can you fix it up when applying the
> patch, or should I resend it?
>

I can fix it up, no worries.
