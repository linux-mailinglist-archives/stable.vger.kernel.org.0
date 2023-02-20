Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA8A69D2F0
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjBTSoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjBTSog (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:44:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625E51E1E0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:44:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A92260F02
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669B4C433EF
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676918674;
        bh=d4Bx4S2fq9PeffyCcYcLMHDz/eiQssEMBaaCsyajxBg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZD2xM9cxegW3YFS2bjgy88Jlcl1DX+wcPQLIt++GbrFj0BcCYlnE0xOYWwY35ki+k
         zS+snxYinTFgz0iwrFDpYgdnzoeu3XjLBh68RDIpzFOkAufMpEQdfnCZF7J5JlL9ut
         ESqiahZzxCX3bVO8uazrdNyLPuTGxi1SfDUBnpiGGvryF1kNDCOYWoeX60f+0ozrNY
         QwSywLYLN9ITjQBYrFCeFswQCgyFxfv6NdqeA4/BJn28I+OIrlOKQNdPLv+rEeQ3eA
         4qdvdFiW6H1bfgCtpZid393vljFCitebAQpKVNLrAwdMSSpZzwVzwhKbw4yE5pwjha
         fXc8nEAvPcM3g==
Received: by mail-ed1-f51.google.com with SMTP id cq23so7953183edb.1
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:44:34 -0800 (PST)
X-Gm-Message-State: AO0yUKV/jtzTe5ihSKeogVFaQ49AuXff/T28CGC8rOEcmd0F1fkLs29w
        IBr/vjH5X8AM3i+MxpkIzlcCIXzPw/SOYgUMidIwwg==
X-Google-Smtp-Source: AK7set8yxxVXxUKNQJv0i3ws370cOjEt5HV31hok9VcKrtUgqK64+Pxa5bz9wMlQ6dJs4bMV+ph6A8I/BRWBRn1ppBs=
X-Received: by 2002:a17:906:b746:b0:88d:64e7:a2be with SMTP id
 fx6-20020a170906b74600b0088d64e7a2bemr4795555ejb.15.1676918672685; Mon, 20
 Feb 2023 10:44:32 -0800 (PST)
MIME-Version: 1.0
References: <20230220120127.1975241-1-kpsingh@kernel.org> <20230220121350.aidsipw3kd4rsyss@treble>
 <CACYkzJ5L9MLuE5Jz+z5-NJCCrUqTbgKQkXSqnQnCfTD_WNA7_Q@mail.gmail.com>
 <CACYkzJ6n=-tobhX0ONQhjHSgmnNjWnNe_dZnEOGtD8Y6S3RHbA@mail.gmail.com>
 <20230220163442.7fmaeef3oqci4ee3@treble> <Y/Ox3MJZF1Yb7b6y@zn.tnic>
 <20230220175929.2laflfb2met6y3kc@treble> <CACYkzJ71xqzY6-wL+YShcL+d6ugzcdFHr6tbYWWE_ep52+RBZQ@mail.gmail.com>
 <Y/O6Wr4BbtfhXrNt@zn.tnic>
In-Reply-To: <Y/O6Wr4BbtfhXrNt@zn.tnic>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 10:44:21 -0800
X-Gmail-Original-Message-ID: <CACYkzJ4jvOGGhuQ1HDzfpGS5vffg9X6hEcLC93QJBFqX+LxLVw@mail.gmail.com>
Message-ID: <CACYkzJ4jvOGGhuQ1HDzfpGS5vffg9X6hEcLC93QJBFqX+LxLVw@mail.gmail.com>
Subject: Re: [PATCH RESEND] x86/speculation: Fix user-mode spectre-v2
 protection with KERNEL_IBRS
To:     Borislav Petkov <bp@alien8.de>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 10:22 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Feb 20, 2023 at 10:01:57AM -0800, KP Singh wrote:
> > Well, we disable IBRS userspace (this is KENREL_IBRS), because it is
> > slow. Now if a user space process wants to protect itself from cross
> > thread training, it should be able to do it, either by turning STIBP
> > always on or using a prctl to enable. With the current logic, it's
> > unable to do so.
>
> Ofcourse it can:
>
>         [SPECTRE_V2_USER_PRCTL]                 = "User space: Mitigation: STIBP via prctl",
>
> we did this at the time so that a userspace process can control it via
> prctl().

No it cannot with IBRS which is really just KERNEL_IBRS enabled, we
bail out if spectre_v2_in_inbrs_mode and ignore any selections:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/cpu/bugs.c#n1202

The whole confusion spews from the fact that while the user thinks
they are enabling spectre_v2=ibrs, they only really get KERNEL_IBRS
and IBRS is dropped in userspace. This in itself seems like a decision
the kernel implicitly took on behalf of the user. Now it also took
their ability to enable spectre_v2_user in this case, which is what
this patch is fixing.


>
> So, maybe you should explain what you're trying to accomplish in detail
> and where it fails...
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
