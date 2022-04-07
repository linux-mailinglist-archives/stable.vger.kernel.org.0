Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E674F7647
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241226AbiDGGi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241258AbiDGGit (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:38:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE43592D3D;
        Wed,  6 Apr 2022 23:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6D2D61D67;
        Thu,  7 Apr 2022 06:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE4FC385AC;
        Thu,  7 Apr 2022 06:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649313398;
        bh=y8Hzh6X4ov/pWCwdyVdXH8J0X9JbXxB31XioMauX8I0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gSRWIyM3zCcHxW0KEvgIQOePA23ryzGrMJh6y33avUH9lLcLrtTQbZxSylSSYUeVE
         gQWdDTSap7/UqEXOOufd5NcOPqgdymPNRdXk7dKn8L5FGrktzXbDwNt0VF0+dN7z9L
         cy6o+LnitEiQm+05Itm9yK6HOOVzirB+SWsPD1QS4g02xD2fvLXJu6pnJNznL8w4y8
         G3AF5EPP8SW3SMZKuGyFOeWEFraKTJM3h/U92wkO8GNTwwoQMlMp/s4kAinGXaLlIY
         wK//amQjSkVwz786YWzyA9xQ9hlxTrjPKBCMSRBXe36441jcNImZXJVN4bNTQOg2v/
         j5lylyQFMb16g==
Received: by mail-ua1-f54.google.com with SMTP id n9so3146534uaj.5;
        Wed, 06 Apr 2022 23:36:38 -0700 (PDT)
X-Gm-Message-State: AOAM530dwVMx2aG/KAjAacOPQ+9ER65ETKyRCENsr9XQP+N8PxCevCGh
        a6H1yKCsJKHhIqtMQWA1KhonxXPEbhatWklbwnc=
X-Google-Smtp-Source: ABdhPJydzCgTxScgqH3neRJgDnYZjHcS9lgL73MhlBIqhRB6tjH5OZPFpm4siyD9r6yxEwjcjdMCGPb4oXGfY4egEzI=
X-Received: by 2002:a9f:2048:0:b0:352:9b4f:ac98 with SMTP id
 66-20020a9f2048000000b003529b4fac98mr3551530uam.12.1649313397262; Wed, 06 Apr
 2022 23:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <Yk3YUFfvEszb+cXT@kroah.com> <mhng-492e449b-ad90-4725-86a0-d5d84e4c35be@palmer-mbp2014>
In-Reply-To: <mhng-492e449b-ad90-4725-86a0-d5d84e4c35be@palmer-mbp2014>
From:   Guo Ren <guoren@kernel.org>
Date:   Thu, 7 Apr 2022 14:36:26 +0800
X-Gmail-Original-Message-ID: <CAJF2gTS_W6NyA4mhHm4fsCsbAGaEb8XN-k=Aq=SCdOEP-kuy9g@mail.gmail.com>
Message-ID: <CAJF2gTS_W6NyA4mhHm4fsCsbAGaEb8XN-k=Aq=SCdOEP-kuy9g@mail.gmail.com>
Subject: Re: [PATCH V3] riscv: patch_text: Fixup last cpu should be master
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 7, 2022 at 3:06 AM Palmer Dabbelt <palmer@rivosinc.com> wrote:
>
> On Wed, 06 Apr 2022 11:13:36 PDT (-0700), Greg KH wrote:
> > On Wed, Apr 06, 2022 at 10:16:49PM +0800, guoren@kernel.org wrote:
> >> From: Guo Ren <guoren@linux.alibaba.com>
> >>
> >> These patch_text implementations are using stop_machine_cpuslocked
> >> infrastructure with atomic cpu_count. The original idea: When the
> >> master CPU patch_text, the others should wait for it. But current
> >> implementation is using the first CPU as master, which couldn't
> >> guarantee the remaining CPUs are waiting. This patch changes the
> >> last CPU as the master to solve the potential risk.
> >>
> >> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> >> Signed-off-by: Guo Ren <guoren@kernel.org>
> >> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> >> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> >> Cc: <stable@vger.kernel.org>
> >> ---
> >>  arch/riscv/kernel/patch.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > What commit id does this change fix?
>
> I think it's been there since the beginning of our text patching, so
>
> Fixes: 043cb41a85de ("riscv: introduce interfaces to patch kernel code")
Yes, it the riscv origin.

>
> seems like the best bet, but I'll go take another look before merging
> it.  That's confusing here, as I acked it, but that was for an earlier
> version that touched more than one arch so it was more ambiguous as to
> which tree it was going through (IIRC I said one of those "LMK if you
> want it through my tree, but here's an Ack in case someone else wants to
> take it" sort of things, as I usually do when it's ambiguous).
Thx for the clarification, I would remove the acked in the next version.

>
> Without a changelog, cover letter, or the other patches in the set it's
> kind of hard to tell, though ;)
Okay, I should add a changelog for the patch with cover letter.


-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
