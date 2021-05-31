Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22833957CC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 11:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhEaJFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 05:05:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53088 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhEaJF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 05:05:29 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622451828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z9e/f4bDNgaATxYVpaaV4Wz5yNP0G+25N1mbuULuoWA=;
        b=okTAxqOAHwDcc9GtWAsIuQ4q769KKHkbZ5D6X3nAhiQlY1XDO3l8qE/1Rtok4nGaybMWs+
        kqUg4x1q0wAMxNoiStJRe7xfqWN0glVYvByy/hlbtmo17zg+h9Wu37Fe43zab4HH/aoE0N
        vswg+pFKAf4YKVLqUOADNxKBcaxlClq3mHLuLEWjEw66JYOjSjAs3PozPd8wAOZNtHqpD7
        bFHDw2ODXvaJDuf2OzEuG4hUJGjf6eOwFjDwhXkNiVqbDJXLriBvNU9bajzpSwABB2edmG
        gpmZ35UaKlyb08NAUWrg8ybq/LfyJn/hmO/IP0+MXyEpdyF1OgSQ33KXPZzlRQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622451828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z9e/f4bDNgaATxYVpaaV4Wz5yNP0G+25N1mbuULuoWA=;
        b=TFlP/EPXVXWTJefMATDunzM4ltUkRws/nbkB9rB728SNqojmEBqYgaFHmmxhbvdsewEJpg
        XIISm8OJfkHh10DA==
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
Subject: Re: [RFC v2 1/2] x86/fpu: Fix state corruption in __fpu__restore_sig()
In-Reply-To: <27deedb9-1e80-fe62-e072-1cc4904f20d5@kernel.org>
References: <cover.1622351443.git.luto@kernel.org> <b69df1e42d1235996682178013f61d4120b3b361.1622351443.git.luto@kernel.org> <87a6ob6ft2.ffs@nanos.tec.linutronix.de> <27deedb9-1e80-fe62-e072-1cc4904f20d5@kernel.org>
Date:   Mon, 31 May 2021 11:03:48 +0200
Message-ID: <875yyz5l6z.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 30 2021 at 16:41, Andy Lutomirski wrote:
> On 5/30/21 3:02 PM, Thomas Gleixner wrote:
>>>  /*
>>> - * Clear the FPU state back to init state.
>>> - *
>>> - * Called by sys_execve(), by the signal handler code and by various
>>> - * error paths.
>>> + * Reset current's user FPU states to the init states.  The caller promises
>>> + * that current's supervisor states (in memory or CPU regs as appropriate)
>>> + * as well as the XSAVE header in memory are intact.
>
> ^^^ The caller promises this

Yes, I misread this, but it's more than non-obvious.

> This patch fixes your reproducer and my (to-be-sent) reproducer.  I
> tested it on a machine that physically has the XRSTORS instruction but I
> disabled it using virt.  Are you still seeing failures with this patch
> applied?  I can try to test on a different CPU.

Seems I applied the patch, built it and then failed to actually boot
that kernel. I retested with brain awake and it indeed works.

Sorry for the rant!

Thanks,

        tglx
