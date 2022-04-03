Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CF04F0B82
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 19:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359618AbiDCRQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 13:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359604AbiDCRQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 13:16:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4470713DD7;
        Sun,  3 Apr 2022 10:14:36 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649006074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qeX5ZeUnYTOArgEzqA+VxeAnatsMOvwz4R2yQNo81VE=;
        b=zrAVVRGgr3aLJGVv3hyhk7jnTYXWEIm5dkZ1fNM/Bl0C5OsG7ffPPegKCPzQIIZvCWz7Kd
        yjpFVF6N02aEtM3sE0c2vEVQrYRQCW8xt2d4DHW11kJx2Hjoc6RIYk1zasv1JD3iTjpQhQ
        my7nUQz9l3iRI0fcio+vWu6jBcj9QwgnNIemcV0flUUBNbK6FWYXjaJgobwKbquOTrFSIf
        2Y9TdDwmaYLvZfYYXqRhl6WMeqpYYdeZr4rDsqi7FgpHWaO8TbKjxFF4wcxqKYH9K+p7x4
        sRRBRIkiVAKQH8rkYw2fafSDCdMvXaBKGBVQMU3Jz3p1TM1TQj2jEv+UXJI18Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649006074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qeX5ZeUnYTOArgEzqA+VxeAnatsMOvwz4R2yQNo81VE=;
        b=OHeTqdUkuo3lHP2BLD7waUl18HFf0uDFgPug2zkqP+lUEQiUeA60vBhtipqIHO+7vOONC3
        ofaPs7DvC1IHkbBg==
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jiri Hladky <hladky.jiri@googlemail.com>
Subject: Re: [PATCH v6 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
In-Reply-To: <87zgl2ksu3.ffs@tglx>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
 <20220329104705.65256-2-ammarfaizi2@gnuweeb.org> <87zgl2ksu3.ffs@tglx>
Date:   Sun, 03 Apr 2022 19:14:34 +0200
Message-ID: <87tubaks1x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 03 2022 at 18:57, Thomas Gleixner wrote:
> On Tue, Mar 29 2022 at 17:47, Ammar Faizi wrote:
>> The asm constraint does not reflect that the asm statement can modify
>> the value of @loops. But the asm statement in delay_loop() does modify
>> the @loops.
>>
>> Specifiying the wrong constraint may lead to undefined behavior, it may
>> clobber random stuff (e.g. local variable, important temporary value in
>> regs, etc.). This is especially dangerous when the compiler decides to
>> inline the function and since it doesn't know that the value gets
>> modified, it might decide to use it from a register directly without
>> reloading it.

Ignore me, I misread this part of the explanation.

Thanks,

        tglx
