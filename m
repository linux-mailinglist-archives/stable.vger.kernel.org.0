Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0683369CA33
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBTLt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjBTLtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:49:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372E410C1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:49:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F15F3B80CA1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC78DC433D2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676893787;
        bh=ayuVUotvjNep0klt/eT1EtD5lIjplbSW0FkKHA1zgT0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l/pyl7cVpN+f7QN/21kCPtyrXRq9FgNe8BH3Z/I2aQ9SujB9mbm58Luc+wU2GdVd8
         joMkQKa5A9AA8/RrV/V6F6b6bO9b+GLGS+/he7ECjL7c+8UQJadWTrsBv0GV+3upJ9
         HDYm3gVq8Qix9yYrLznJt1b/XODOn7wvDfAMBgQBuVvvHX/amHPkW9qhgcsicUPbYc
         lMbKlgcd1vXVEwbfvPOFaE3m26YgD6EackHRR2OQfL5dae4C7RC5UaOSMqiCvg/lpp
         U7lS2vY+5ZjtrOehRN2htTVHEcQbupL5895Va6HL+u4xEMRJrZCctJKKQW78BVG44H
         kNEH0XH3FPRBQ==
Received: by mail-ed1-f41.google.com with SMTP id b12so3556438edd.4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:49:47 -0800 (PST)
X-Gm-Message-State: AO0yUKUloxpqnMgmNQvAsAMfYVytD8cS3w2XspvLxHXygSSBn+gEePEU
        NgS8HpNelBDBvGaEgZgpDMfLtRpTjtnXkyLCWmeJOQ==
X-Google-Smtp-Source: AK7set+2jhtMyfGdWhZIPqmCD6i5d/XcG7cfGYfkcQ7d6WwBzg1bIOjkA0WOD5BMOpCWJAL9apoNMEhCAtWlOHPXJ8U=
X-Received: by 2002:a17:906:f88f:b0:8b0:7e1d:f6fa with SMTP id
 lg15-20020a170906f88f00b008b07e1df6famr3853325ejb.15.1676893765439; Mon, 20
 Feb 2023 03:49:25 -0800 (PST)
MIME-Version: 1.0
References: <20230220103930.1963742-1-kpsingh@kernel.org> <Y/NQ6w4UlEuBSTql@kroah.com>
 <20230220113859.j2tidqnifzjgyros@treble>
In-Reply-To: <20230220113859.j2tidqnifzjgyros@treble>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 03:49:14 -0800
X-Gmail-Original-Message-ID: <CACYkzJ4TGTvsa0bk_k=u-MHUZfHqp-G8CM=wSV_dP8+Bfmfznw@mail.gmail.com>
Message-ID: <CACYkzJ4TGTvsa0bk_k=u-MHUZfHqp-G8CM=wSV_dP8+Bfmfznw@mail.gmail.com>
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection with KERNEL_IBRS
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, security@kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 3:39 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Mon, Feb 20, 2023 at 11:52:27AM +0100, Greg KH wrote:
> > On Mon, Feb 20, 2023 at 11:39:30AM +0100, KP Singh wrote:
> > > With the introduction of KERNEL_IBRS, STIBP is no longer needed
> > > to prevent cross thread training in the kernel space. When KERNEL_IBR=
S
> > > was added, it also disabled the user-mode protections for spectre_v2.
> > > KERNEL_IBRS does not mitigate cross thread training in the userspace.
> > >
> > > In order to demonstrate the issue, one needs to avoid syscalls in the
> > > victim as syscalls can shorten the window size due to
> > > a user -> kernel -> user transition which sets the
> > > IBRS bit when entering kernel space and clearing any training the
> > > attacker may have done.
> > >
> > > Allow users to select a spectre_v2_user mitigation (STIBP always on,
> > > opt-in via prctl) when KERNEL_IBRS is enabled.
> > >
> > > Reported-by: Jos=C3=A9 Oliveira <joseloliveira11@gmail.com>
> > > Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> > > Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=3Dibrs option t=
o support Kernel IBRS")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: KP Singh <kpsingh@kernel.org>
> > > ---
> > >  arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
> > >  1 file changed, 17 insertions(+), 8 deletions(-)
> >
> > As this is posted publicly, there's no need to send it to
> > security@kernel.org, it doesn't need to be involved.
>
> Also, since this seems intended to be public, please add lkml to Cc on
> the next revision.

Sure.

>
> --
> Josh
