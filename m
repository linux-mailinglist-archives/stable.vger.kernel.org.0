Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233133F2B8A
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 13:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhHTLwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 07:52:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49454 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237633AbhHTLwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 07:52:04 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1299821F0F;
        Fri, 20 Aug 2021 11:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629460286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lQX6jTsCnZm0NKaaIyjtENrWZHYlokhpMZqMbbJK9oY=;
        b=PxOAnuTEltysmL4b7KdcszsAgN/Y48Hzk9NpdbkGvNxcs5EUV2Gn9Q7AqKbEDQYE890cVm
        t+1znAVlpxJdZySabgIiIiVKBAeYuPwmsuPQixcGvw+u7TwvonZBmBJ7tkPc9G+AEufQbs
        0Libt0maUztxeUzdocMRrlWeJHosNwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629460286;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lQX6jTsCnZm0NKaaIyjtENrWZHYlokhpMZqMbbJK9oY=;
        b=3WpUwwKY+CKgWY45HtwvGmylJA4P1p6ZuA3BaQ93eB6NHHuOQ3srVPeuksrF3sZT45hJ7U
        J69ext1up+eyjpDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 81B4D13AC1;
        Fri, 20 Aug 2021 11:51:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id y4nkHT2XH2FIfQAAGKfGzw
        (envelope-from <jroedel@suse.de>); Fri, 20 Aug 2021 11:51:25 +0000
Date:   Fri, 20 Aug 2021 13:51:23 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        David Laight <David.Laight@aculab.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Message-ID: <YR+XO+zcwoNytZSj@suse.de>
References: <20210820073429.19457-1-joro@8bytes.org>
 <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
 <YR9tSuLyX8QHV5Pv@8bytes.org>
 <f68a175362984e4abbb0a1da2004c936@AcuMS.aculab.com>
 <YR+Bxgq4aIo1DI8j@8bytes.org>
 <CAMj1kXHj12FQn_488V_9k9k_LE51K=7n3sS9QnN9gkhBgzw-Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHj12FQn_488V_9k9k_LE51K=7n3sS9QnN9gkhBgzw-Kw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 01:31:36PM +0200, Ard Biesheuvel wrote:
> That does raise a question, though. Does changing the IDT interfere
> with the ability of the UEFI boot services to receive and handle the
> timer interrupt? Because before ExitBootServices(), that is owned by
> the firmware, and UEFI heavily relies on it for everything (event
> handling, polling mode block/network drivers, etc)

Yes it would interfer, if the boot code would run with IRQs enabled,
which it does not. But switching the GDT also interfers with that, and
we are doing the same switching with the GDT already.

> If restoring the IDT temporarily just papers over this by creating
> tiny windows where the timer interrupt starts working again, this is
> bad, and we need to figure out another way to address the original
> problem.

As I can see it, there is no time window where an interrupt could happen
(NMIs aside). When returning from EFI IRQs are disabled again (in case
EFI let them enabled) while still on the EFI GDT and IDT. After IRQs are
disabled the kernel restores its own GDT and IDT.

Regards,

	Joerg
