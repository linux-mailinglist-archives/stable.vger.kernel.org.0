Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6B34B7047
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiBOO41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 09:56:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiBOO40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 09:56:26 -0500
X-Greylist: delayed 378 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 06:56:16 PST
Received: from mail-4327.protonmail.ch (mail-4327.protonmail.ch [185.70.43.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760339FE5;
        Tue, 15 Feb 2022 06:56:16 -0800 (PST)
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-4321.protonmail.ch (Postfix) with ESMTPS id 4JykWy17Jvz4x6KM;
        Tue, 15 Feb 2022 14:49:50 +0000 (UTC)
Authentication-Results: mail-4321.protonmail.ch;
        dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="BDvn1o1Z"
Date:   Tue, 15 Feb 2022 14:49:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1644936545;
        bh=BNi3yC/9jw1c/szfUfUGT5h9vUtlRUvDAK4sFcLdjmk=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=BDvn1o1ZnCovptmLn11diWMUEAWct4RD312L8UhYymcv2YyALQ0+t4WLvihd2EiZC
         tPc5WJekOp7nZTc3KwH24zmXXoHCubCivqzXXamMSRzo5TgUJkbYT+22j7Nu8u82Ai
         Z99eglNVPxJLUMXHt20FU09SULmsFJkzUZZNMJXnqxMqGItr5a+HEju7xrB+xwjtHH
         /ABhwuILabSjR0rBdRp/niEjUx8Ghyfouiy//TJCKQO2uoNzNSLWxqUpxdmehiglJ+
         ASV2R5Klz+28noHpnpCsQBmCuQic75pIp8Y+1uWN5ADRY5i92MirLhvMCNoKobJ86+
         f0ojLOvQR2VYg==
To:     =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH mips-fixes] MIPS: smp: fill in sibling and core maps earlier
Message-ID: <5324be35-5c49-31c1-3f9a-267a5dae8c84@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>
Date: Mon, 14 Feb 2022 20:00:12 +0100

> On 12/2/22 23:21, Alexander Lobakin wrote:
> > After enabling CONFIG_SCHED_CORE (landed during 5.14 cycle),
> > 2-core 2-thread-per-core interAptiv (CPS-driven) started emitting
> > the following:
> >

--- 8< ---

> >
> > [    0.048433] CPU: 1, smt_mask: 0-1
> >
> > [0] https://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git/comm=
it/?id=3D76ce7cfe35ef
>
> Isn't it worth Cc'ing stable@vger.kernel.org here?

Probably. It doesn't have any Fixes tag (this is a fix, but the bug
is caused not by a particular commit, rather by a combination of
changes and code flows from the past), but it still can be
backported, right.

Thomas, should I queue a v2 with this tag added?

Cc: stable@vger.kernel.org # 5.14+

Or it can be picked up automatically?

>
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >   arch/mips/kernel/smp.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>

Thanks!

Al

