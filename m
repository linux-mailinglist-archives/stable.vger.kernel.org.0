Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF169C951
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBTLMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTLMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:12:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3CA9ED4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6CDEB80C03
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A18C433D2
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676891517;
        bh=aRAG74wwkazhGXZu7oIU1G4r76VRwBaHTok+w+m3vUU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FzP1iYvu6bj4Ifaxu5VJCN1SKXqwXXH9Cibb7Aw/QP4Z2Rkt5aSLojcmHEF/MpuYW
         989GJJbHEZ1BL0mPUXJ66i7RM6Pgy0fJYx2kHcmKzYPZqFkIxdi/b74ZaptjpyfZnF
         jOE1W5dP38VaVPBLujTrCIvkEKZYNTpqUUpCqqxRYpKCgWGq/9x1e9MXYCfsxqeknY
         nQrQeoKy9gm4WqptYQi7ItYuL4kVxbMJAs5kSximbJ94StB2wCMg/c7y/K5RMAauJf
         ftPb4pDDkXPZ/lbU/2cnr62C2X4X7VmJSzyCDuwCF1GPERK9DJ/wsFh7Qdbq0vBYLx
         /DUYQQvYhW2Hg==
Received: by mail-ed1-f54.google.com with SMTP id h16so3367079edz.10
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:11:57 -0800 (PST)
X-Gm-Message-State: AO0yUKWKDx6SPaVISibLqrC+CBWbpJHn3alqgLrb9Q8+6Umb8ejuYr5d
        oltKJB7wzdSQ/NSErkWT0G8RmCtsuQ1F81hvaTLyyw==
X-Google-Smtp-Source: AK7set8d4TabdY1UeOKao+S4xngpO6xV7Yi41SU9v9PUQHIq+b9eGF/J4fJkB3c58/eyUVrvu/fBpKkg2dw8e8+3ofQ=
X-Received: by 2002:a17:906:b746:b0:88d:64e7:a2be with SMTP id
 fx6-20020a170906b74600b0088d64e7a2bemr4164163ejb.15.1676891495045; Mon, 20
 Feb 2023 03:11:35 -0800 (PST)
MIME-Version: 1.0
References: <20230220103930.1963742-1-kpsingh@kernel.org> <Y/NQ6w4UlEuBSTql@kroah.com>
In-Reply-To: <Y/NQ6w4UlEuBSTql@kroah.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 20 Feb 2023 03:11:24 -0800
X-Gmail-Original-Message-ID: <CACYkzJ7Umq_XQEAHZyPE60zhbWsSF_i-vNa7u_qCeqBgGVfC4g@mail.gmail.com>
Message-ID: <CACYkzJ7Umq_XQEAHZyPE60zhbWsSF_i-vNa7u_qCeqBgGVfC4g@mail.gmail.com>
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection with KERNEL_IBRS
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     security@kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 2:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Feb 20, 2023 at 11:39:30AM +0100, KP Singh wrote:
> > With the introduction of KERNEL_IBRS, STIBP is no longer needed
> > to prevent cross thread training in the kernel space. When KERNEL_IBRS
> > was added, it also disabled the user-mode protections for spectre_v2.
> > KERNEL_IBRS does not mitigate cross thread training in the userspace.
> >
> > In order to demonstrate the issue, one needs to avoid syscalls in the
> > victim as syscalls can shorten the window size due to
> > a user -> kernel -> user transition which sets the
> > IBRS bit when entering kernel space and clearing any training the
> > attacker may have done.
> >
> > Allow users to select a spectre_v2_user mitigation (STIBP always on,
> > opt-in via prctl) when KERNEL_IBRS is enabled.
> >
> > Reported-by: Jos=C3=A9 Oliveira <joseloliveira11@gmail.com>
> > Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> > Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=3Dibrs option to =
support Kernel IBRS")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: KP Singh <kpsingh@kernel.org>
> > ---
> >  arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
> >  1 file changed, 17 insertions(+), 8 deletions(-)
>
> As this is posted publicly, there's no need to send it to
> security@kernel.org, it doesn't need to be involved.

Sure, it's okay. Please do note in my first patch, I did follow
https://www.kernel.org/doc/Documentation/admin-guide/security-bugs.rst,
if you want folks to explicitly Cc maintainers with their fix or
report, I think it's worth mentioning in the guidelines there as the
current language seems to imply that the maintainers will be pulled in
by the security team:

"It is possible that the security team will bring in extra help from
area maintainers to understand and fix the security vulnerability."

- KP

>
> thanks,
>
> greg k-h
