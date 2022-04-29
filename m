Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5257514A35
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 15:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359666AbiD2NHn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 29 Apr 2022 09:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238686AbiD2NHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 09:07:42 -0400
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA62BCAB85;
        Fri, 29 Apr 2022 06:04:19 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id g28so14318516ybj.10;
        Fri, 29 Apr 2022 06:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ycd1bPuiSrNE0SR6b+uO4l9ZEm/fD3tp9CiU84zTTmU=;
        b=5zPZXmz+32c5o1tN5qdniB8ttQuR2ZHlD7U09g20gj5hHBDxvpLbzHU8EZN51wyZ+g
         8rtvy5cWcaAPVoAPTJnUDu50SPshf5x9ahZRZIXlOn62OK388H/Eqc16OAScxyoKIPj3
         E/7CbrGqyRdsfWofxqtSLkM6+gtPeEscai2sTl8u9gaXRGyHNK7CuyZxOaPzIMpSHh/M
         E3ygBF86NFU2ob6KZuoGArocQNlP/Z7GL+AV0mSBBUnS+nDKYZ/8GbmBaDwfHCNO2qhY
         BdLUvcs6QqcBTyFbbhMFKXyqPyvtWrT6zB2LRaOTnSU/Sq8KrcsdwFzQLd+uZDFPzDp4
         woYA==
X-Gm-Message-State: AOAM532sWV3t2a7k8r/+wIcvIEyqtZSlJg8PsarYQxruQ7yPT0wwuDLe
        Ago1PjRpnK5KrXXRDyMtSsT3sljEc0RP30nX1Fj20ilXHk0=
X-Google-Smtp-Source: ABdhPJxZooP6OXVMOJBlu2rNQgt4VBjevrGHyY768DhaEwUitikkXWtnYUcIktDJU/bwFtVBVPGLmLbgEz3WX/gAZ1A=
X-Received: by 2002:a25:6e89:0:b0:642:57b:ccd7 with SMTP id
 j131-20020a256e89000000b00642057bccd7mr35395074ybc.115.1651237458734; Fri, 29
 Apr 2022 06:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2204240214430.9383@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2204240214430.9383@angie.orcam.me.uk>
From:   =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>
Date:   Fri, 29 Apr 2022 15:04:07 +0200
Message-ID: <CAAdtpL6=b9hYeBggV3XNUtkOMxd=Zt0_7-TkKKdCTku2y1ip+g@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Fix CP0 counter erratum detection for R4k CPUs
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 9:39 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> Fix the discrepancy between the two places we check for the CP0 counter
> erratum in along with the incorrect comparison of the R4400 revision
> number against 0x30 which matches none and consistently consider all
> R4000 and R4400 processors affected, as documented in processor errata
> publications[1][2][3], following the mapping between CP0 PRId register
> values and processor models:
>
>   PRId   |  Processor Model
> ---------+--------------------
> 00000422 | R4000 Revision 2.2
> 00000430 | R4000 Revision 3.0
> 00000440 | R4400 Revision 1.0
> 00000450 | R4400 Revision 2.0
> 00000460 | R4400 Revision 3.0
>
> No other revision of either processor has ever been spotted.
>
> Contrary to what has been stated in commit ce202cbb9e0b ("[MIPS] Assume
> R4000/R4400 newer than 3.0 don't have the mfc0 count bug") marking the
> CP0 counter as buggy does not preclude it from being used as either a
> clock event or a clock source device.  It just cannot be used as both at
> a time, because in that case clock event interrupts will be occasionally
> lost, and the use as a clock event device takes precedence.
>
> Compare against 0x4ff in `can_use_mips_counter' so that a single machine
> instruction is produced.
>
> References:
>
> [1] "MIPS R4000PC/SC Errata, Processor Revision 2.2 and 3.0", MIPS
>     Technologies Inc., May 10, 1994, Erratum 53, p.13
>
> [2] "MIPS R4400PC/SC Errata, Processor Revision 1.0", MIPS Technologies
>     Inc., February 9, 1994, Erratum 21, p.4
>
> [3] "MIPS R4400PC/SC Errata, Processor Revision 2.0 & 3.0", MIPS
>     Technologies Inc., January 24, 1995, Erratum 14, p.3
>
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: ce202cbb9e0b ("[MIPS] Assume R4000/R4400 newer than 3.0 don't have the mfc0 count bug")
> Cc: stable@vger.kernel.org # v2.6.24+
> ---
>  arch/mips/include/asm/timex.h |    8 ++++----
>  arch/mips/kernel/time.c       |   11 +++--------
>  2 files changed, 7 insertions(+), 12 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
