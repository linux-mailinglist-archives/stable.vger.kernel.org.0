Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A166A08C7
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 13:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjBWMpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 07:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbjBWMpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 07:45:06 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D0F199E1;
        Thu, 23 Feb 2023 04:45:04 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFC881EC06D8;
        Thu, 23 Feb 2023 13:45:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677156303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uBXtEygduuVXSSy+78MnNbkRrkX7wpGw6EZNum6TMUY=;
        b=AC+1Q4NPrx8mIbgOCWkhSXIDlDW3j9I038W0cfelKe+WYSPhnV9xnafU/R/N2a9mTo/6Ds
        Q7FrAgfcxRBOzQ4djCVcaFAzWzROB5RlNRUmkNt2hWdqllA/+xXnxU5LLJiHpDtur19qZg
        3oOXwplENb5PhN0oRX4Ir/O9K9QXzBw=
Date:   Thu, 23 Feb 2023 13:44:58 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/dfyh1U/qDR1Ymw@zn.tnic>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <Y/YJisQdorH1aAKV@zn.tnic>
 <CACYkzJ4cSA5xFScgS=WTc6tPis-vUCtYkh3LyEr8EkXoDCm-uA@mail.gmail.com>
 <Y/ZVaBKwbWUbF7u+@zn.tnic>
 <CACYkzJ4WigzaOCR4V9=e60ka=NNncWRB-j78DLRuzdSOZXvwrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACYkzJ4WigzaOCR4V9=e60ka=NNncWRB-j78DLRuzdSOZXvwrA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 11:41:59AM -0800, KP Singh wrote:
> Sure, I think the docs do already cover it,

I mean *our docs*. The stuff you're adding in your patch 2.

> but I sort of disagree with your statement around the commit message.
> I feel the more context you can add in the commit message, the better
> it is.

That's ofc wrong. And you'll find that out when you do git archeology
and you come across a huuuge wall of text explaining the world and some
more.

No, commit messages should be to the point with a structure similar to
something like this:

1. Prepare the context for the explanation briefly.

2. Explain the problem at hand.

3. "It happens because of <...>"

4. "Fix it by doing X"

5. "(Potentially do Y)."

concentrating on *why* the fix is being done.

> When I am looking at the change log, it would be helpful to have the
> information that I mentioned in the Q&A. Small things like, "eIBRS
> needs the IBRS bit set which also enables cross-thread protections" is
> a very important context for this patch IMHO. Without this one is just
> left head scratching and scrambling to read lengthy docs and processor
> manuals.

Yes, that's why you say in the commit message: "For more details, see
Documentation/admin-guide/hw-vuln/spectre.rst." where:

1. you can explain in a lot more detail

2. put it in place where people can find it *easily*

> This sort of loosely implies that the IBRS bit also enables
> cross-thread protections. Can you atleast add this one explicitly?
> 
> "Setting the IBRS bit also enables cross thread protections"

Ok.

> Not at the stage when the kernel decides to drop the STIBP protection
> when eIBRS is enabled.

We can't dump every possible interaction between the mitigations. It is
a huge mess already. But I'm open to looking at improvements of the
situation *and* documenting stuff as we go.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
