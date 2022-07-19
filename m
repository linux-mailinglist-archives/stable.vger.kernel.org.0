Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E68E57A581
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbiGSRh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbiGSRh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:37:56 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B945A2FF;
        Tue, 19 Jul 2022 10:37:54 -0700 (PDT)
Received: from zn.tnic (p200300ea97297609329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:7609:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 530761EC0138;
        Tue, 19 Jul 2022 19:37:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658252267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=y5ZMCnUTWGMS2A57L3TimBKZx2dG3nsMUVXGZqiweuI=;
        b=DV+KzSpsmUJXA4gV2e71Kx9Wuq+g9wu2jW9T+QmkWpKnTcgcguGh61gc0eOtjBphP7fEX+
        7uOhwtmI+/jz7Mqjln4xuwG+oFy3ZSbWyI37nJRNMyYtnqSIpiFk4NMfM6ecjSA971IfQQ
        hatuNYgEJOwJ5jRpEwoyTWtfDr8Wt4c=
Date:   Tue, 19 Jul 2022 19:37:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Message-ID: <Ytbr52VKK6aQT259@zn.tnic>
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
 <YtWKK2ZLib1R7itI@zn.tnic>
 <CAHk-=wiWQOsxqE+tvZi_MjzGaqfG6Xo5AhbYXtiLWcKVVvbycQ@mail.gmail.com>
 <YtWqit2B3UYIWht1@zn.tnic>
 <CAMj1kXE128e76KWgRgHLM+WWHOzx_BJsWMw_2QgzbYTm3p9d-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXE128e76KWgRgHLM+WWHOzx_BJsWMw_2QgzbYTm3p9d-A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 05:22:28PM +0200, Ard Biesheuvel wrote:
> The code in question is a little trampoline that executes from the EFI
> mixed mode 1:1 mapping of the kernel text, and never via the kernel
> mapping, so we should just move it into .rodata instead (and fix up
> the mixed mode virtual address map logic accordingly). I don't think
> mapping the kernel text and rodata into the 1;1 EFI map is needed at
> all, tbh, and the only thing we ever access via that mapping is that
> little trampoline.
> 
> Something like

I'm obviously always for simplifications like that. I'm guessing this
should be tested for a full next release before it goes to Linus?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
