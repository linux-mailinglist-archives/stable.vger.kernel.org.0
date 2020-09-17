Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AACC26DAE4
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 13:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgIQL5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 07:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgIQL5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 07:57:45 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30689C06174A;
        Thu, 17 Sep 2020 04:57:45 -0700 (PDT)
Received: from zn.tnic (p200300ec2f1053009faf0a64ea33345c.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:5300:9faf:a64:ea33:345c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B14D71EC0409;
        Thu, 17 Sep 2020 13:57:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600343861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KnBEYj+XMQPVfN01d6ZhpPkXbMTyDk8FrXgj70Nq8ik=;
        b=hAB04Gr0GFVFRvmoABoDOoMjAMEX7d9BzfUWg8kmrjehlIDmDb/k0BOprboWaBD1kelh02
        yNS3cqD7nv+1MXFhmfT6usY1K5jHusJT3YhDnuWXLyh7ckn1xeY/wg4jyiDD6PfAqGkMWP
        6R8HZNjN+Cj7CwKsAAvERjzWXS7w76Y=
Date:   Thu, 17 Sep 2020 13:57:33 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Bill Wendling <morbo@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
Message-ID: <20200917115733.GH31960@zn.tnic>
References: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
 <441AA771-A859-4145-9425-E9D041580FE4@amacapital.net>
 <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
 <20200916082621.GB2643@zn.tnic>
 <be498e49-b467-e04c-d833-372f7d83cb1f@citrix.com>
 <20200917060432.GA31960@zn.tnic>
 <ec617df229514fbaa9897683ac88dfda@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ec617df229514fbaa9897683ac88dfda@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 10:05:37AM +0000, David Laight wrote:
> The 'red-zone' allows leaf function to use stack memory for locals
> that is below (ie the wrong side of) the stack pointer.

After looking at

"Figure 3.3: Stack Frame with Base Pointer"

in the x86-64 ABI doc, you're probably right:

0(%rbp)
-8(%rbp)
...
0(%rsp)
.. red zone
-128(%rsp)

i.e., rsp-relative addresses with negative offsets are in the red zone.
So it looks like the compiler actually knows very well what's going on
here and allocates room on the stack for that 0x8(%rsp) slot.

Good.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
