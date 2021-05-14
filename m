Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D6380EFB
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 19:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhENReI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 13:34:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38202 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhENReH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 13:34:07 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621013574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3RJZ0XX14xM21R7lZUKkaNX6VVRciDvkJ2L8b2qH9qQ=;
        b=NM7jyIp9oak0LJEU6gjUrH7Bzvy+CrfWo6sfuI1FGJTf27TJi6MWwZ8GTvCWdMqYs46b+M
        FWaqQYJI3W8VZwxK9JcmHNT4709BESFWaRwgOA7JdZMJ7KXmzDmDP3h6npegW4y1Nj2hZJ
        kRaSC0L0G3TzSIqaVOSz/MHiErs3DGPggnRoaMCJW+NjQXLw8ggiQaHNonk5gnM48dDTHI
        2PC1e9KqDilKYbiUWxioKQNAqWnujXEoHGJnzhGgsK3YfB5zXzlINtm9NyLR5k5GO6MC59
        oeaV0iNNFG516GtAXqkaZ2UoXZ1anY7xhqdhOEfOLn5V0zx5pHzvYb0k6XrTog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621013574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3RJZ0XX14xM21R7lZUKkaNX6VVRciDvkJ2L8b2qH9qQ=;
        b=NSRaJBxwjaaI6RAdX71Q+v4ctm/IH03z0eVZxmn5WwOfWwHCt8TRdNoM9mxGX/JNHlyC6h
        uXOw5YSYqjl8P3Dg==
To:     Maximilian Luz <luzmaximilian@gmail.com>,
        Sachi King <nakato@nakato.io>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
In-Reply-To: <5c08541a-2615-f075-a189-0462f1005007@gmail.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com> <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com> <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com> <3034083.sOBWI1P7ec@yuki> <5c08541a-2615-f075-a189-0462f1005007@gmail.com>
Date:   Fri, 14 May 2021 19:32:54 +0200
Message-ID: <87im3l43w9.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14 2021 at 13:58, Maximilian Luz wrote:
> On 5/14/21 9:41 PM, Sachi King wrote:
> I'd assume that _some_ sort of interrupt setup is done by the BIOS/UEFI.
> The UEFI on those devices is fairly well-featured, with touch support
> via SPI and all. Furthermore, keyboard (also supported in the device's
> UEFI) is handled via a custom UART protocol. Unless they rely on polling
> for all of that, I believe they'd have to set up some interrupts.

Polling would be truly surprising.

> Although, as you mention later on, that could also be handled via the
> IOAPIC and the PIC is actually not supposed to be used. Maybe some
> legacy component that never got tested and just broke with some new
> hardware/firmware revision without anyone noticing? And since Linux
> still seems to rely on that, we might be the first to notice.

That's a valid assumption. As I said, we can make IOAPIC work even w/o
PIC. I'll have a look how much PIC assumptions are still around.

Thanks,

        tglx
