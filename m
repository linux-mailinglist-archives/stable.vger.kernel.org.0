Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C27383C87
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhEQSl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 14:41:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54262 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbhEQSl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 14:41:28 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621276810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=hSz2gY5PBw/ohaaE/xoXB86FUhBxqR4Jkj21Xx9CCZw=;
        b=yzENOyXq0yf/YzL7rs2JYKg8+TBIqYBdHRqCgPECQup3/NzL5Vv/Gh6338vpPdPXHZC8QI
        LVsLaMcKwedxTsWAalunKRM/mo5dgdmy1a0XE9FoceVSDyWkOYFQaNiLg11CLoerbBbDEb
        kQtz9q56bxlAIGznleq6XmkKDlbLkW+Tu9PLbUuiQDP/TcqpiPPKgQHiGz1GqvQ0ZWVWNb
        P7Pjv2r9u8k1YzUZk0Ar3DZ14x2+bTuysA6lzW+sLYxjaUQUy+J332ZNfkyrVyfgHP5dKQ
        d/ZMlrCVUPnbY7rXQ2mSVxBNhyz5C0VahxT/IQ02Tu7CC6Tzimnpo1spekRj8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621276810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=hSz2gY5PBw/ohaaE/xoXB86FUhBxqR4Jkj21Xx9CCZw=;
        b=A3n+0E4CGWZNLr66xF6rzictHGSTewgQlD+xz3QBFBRXHmouPNH49pYvEF3t83NW3KF0p9
        0YRgZXxJ4kPTNYAg==
To:     Maximilian Luz <luzmaximilian@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>
Cc:     "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
In-Reply-To: <087c418e-53fb-b3a6-0d9b-e738e4c821c7@gmail.com>
Date:   Mon, 17 May 2021 20:40:10 +0200
Message-ID: <87a6otfblh.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Max,

On Sat, May 15 2021 at 00:47, Maximilian Luz wrote:
> I believe the theory was that, while the PIC is advertised in ACPI, it
> might be expected to not be used and only present for some legacy reason
> (therefore untested and buggy). Which I believe led to the question
> whether we shouldn't prefer IOAPIC on systems like that in general. So I
> guess it comes down to how you define "systems like that". By Tomas'
> comment, I guess it should be possible to implement this as "systems
> that should prefer IOAPIC over legacy PIC" quirk.
>
> I guess all modern machines should have an IOAPIC, so it might also be
> preferable to expand that definition, maybe over time and with enough
> testing.

I just double checked and we actually can boot just fine without the
PIC even when it is advertised, but disfunctional.

Can you please add "apic=verbose" to the kernel command line and provide
full dmesg output for a kernel w/o your patch and one with your patch
applied?

Thanks,

        tglx


