Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEE44E8D56
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 06:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiC1EbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 00:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiC1EbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 00:31:18 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1465E220CA;
        Sun, 27 Mar 2022 21:29:39 -0700 (PDT)
Received: from [192.168.12.80] (unknown [182.2.37.32])
        by gnuweeb.org (Postfix) with ESMTPSA id 2B6987E2FD;
        Mon, 28 Mar 2022 04:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648441777;
        bh=I508hysutfNMCifaxyR6DAcvMvWBy7ffokyw5LkHEbQ=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=i4aBD/vBkS9hGSbyZbsAPighyljpA9grWq/RBP7Lxn+TFzfa7DIfYil3id70aQHxH
         BMadMCOP3PaPdU0y4uC901hWgcGkUpdbj3RKc1hSM1raWw31LzonaUPuH+z466Yl32
         MiKsE02G0omxnCEoLnIqDociQ34rswVdjrjfqHFlVTMp3bkBBJ1qwZL3vM5XJ2d3ki
         pJNxkJBDVEZawQirC840yc+blRrvhihRq/pnMR4RWHKDwh1r3dsmOp9Yzii+u8wb0H
         tE0zf8ancL4iwGjsfuZaM1mdvPLiuf3aKaQQ7K7GMoXFIg5k1L1T5YduV4p+3PuQGX
         2amwBaeWKF4Wg==
Message-ID: <6f020f3a-da63-09a5-95f4-167429ff3727@gnuweeb.org>
Date:   Mon, 28 Mar 2022 11:29:26 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org,
        David Laight <David.Laight@aculab.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <20220310015306.445359-2-ammarfaizi2@gnuweeb.org> <YkDZY8n1k5SJw9st@zn.tnic>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v5 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
In-Reply-To: <YkDZY8n1k5SJw9st@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/22 4:38 AM, Borislav Petkov wrote:
> On Thu, Mar 10, 2022 at 08:53:05AM +0700, Ammar Faizi wrote:
>> The asm constraint does not reflect that the asm statement can modify
>> the value of @loops. But the asm statement in delay_loop() does modify
>> the @loops.
>>
>> Specifiying the wrong constraint may lead to undefined behavior, it may
>> clobber random stuff (e.g. local variable, important temporary value in
>> regs, etc.).
> 
> This is especially dangerous when the compiler decides to inline the
> function and since it doesn't know that the value gets modified, it
> might decide to use it from a register directly without reloading it.
> 
> Add that to the commit message pls.

Will add that in the v6.

>> Cc: stable@vger.kernel.org # v2.6.27+
> 
> I don't see the need for the stable Cc. Or do you have a case where
> a corruption really does happen?

I don't find any visible issue on this. But that's undefined behavior,
different compiler may yield different result (e.g. there is no guarantee
newer compilers will produce the appropriate result due to UB). So it's not
something we should rely on.

============
Side note for inline:
Even if it is not inlined, it's still dangerous, because if the compiler is
able to see that the function to be called doesn't clobber some call-clobbered
regs, the compiler can assume the call-clobbered regs are not clobbered and it
reuses the value without reloading.

See the example from Alviro here:

   https://lore.kernel.org/lkml/CAOG64qPgTv5tQNknuG9d-=oL2EPQQ1ys7xu2FoBpNLyzv1qYzA@mail.gmail.com/

-- 
Ammar Faizi
