Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6782526DE7C
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgIQOlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbgIQOlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 10:41:01 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9AFC0612F2;
        Thu, 17 Sep 2020 07:41:00 -0700 (PDT)
Received: from zn.tnic (p200300ec2f1053001db76021617d6ec9.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:5300:1db7:6021:617d:6ec9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C42331EC0260;
        Thu, 17 Sep 2020 16:39:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600353567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=kTdpctjr26+hadEPAalxUdZ4IHHCvTX0roS3TMkt6bQ=;
        b=fnDxZUejBlcEL1dJreJ2gTSVjd0tdD7ozJi6uNPbe2/LV10xJTqaOiO1WGzuHHpWUivcPV
        IKKnRdQgbsK5HGvs2ZhPrKT6U7h/I5hkHmOkYIsHo7n6TBB5agBEEkgBGYqFsrYYRkFvOk
        mimTMJp1UL0YcNXTEOOT5K/ct5ozFgM=
Date:   Thu, 17 Sep 2020 16:39:20 +0200
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
Message-ID: <20200917143920.GJ31960@zn.tnic>
References: <CAKwvOdnjHbyamsW71FJ=Cd36YfVppp55ftcE_eSDO_z+KE9zeQ@mail.gmail.com>
 <441AA771-A859-4145-9425-E9D041580FE4@amacapital.net>
 <7233f4cf-5b1d-0fca-0880-f1cf2e6e765b@citrix.com>
 <20200916082621.GB2643@zn.tnic>
 <be498e49-b467-e04c-d833-372f7d83cb1f@citrix.com>
 <20200917060432.GA31960@zn.tnic>
 <ec617df229514fbaa9897683ac88dfda@AcuMS.aculab.com>
 <20200917115733.GH31960@zn.tnic>
 <823af5fadd464c48ade635498d07ba4e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <823af5fadd464c48ade635498d07ba4e@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 02:25:50PM +0000, David Laight wrote:
> I actually wonder if there is any code that really benefits from
> the red-zone.

The kernel has been without a red zone since 2002 at least:

  commit 47f16da277d10ef9494f3e9da2a9113bb22bcd75
  Author: Andi Kleen <ak@muc.de>
  Date:   Tue Feb 12 20:17:35 2002 -0800

      [PATCH] x86_64 merge: arch + asm

      This adds the x86_64 arch and asm directories and a Documentation/x86_64.

  ...
  +CFLAGS += $(shell if $(CC) -mno-red-zone -S -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-mno-red-zone"; fi )


Also, from the ABI doc:

"A.2.2 Stack Layout

The Linux kernel may align the end of the input argument area to a
8, instead of 16, byte boundary. It does not honor the red zone (see
section 3.2.2) and therefore this area is not allowed to be used by
kernel code. Kernel code should be compiled by GCC with the option
-mno-red-zone."

so forget the red zone.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
