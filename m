Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5371F4BAA57
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239408AbiBQTxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:53:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiBQTw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:52:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3749F12E150;
        Thu, 17 Feb 2022 11:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC6CC61D6F;
        Thu, 17 Feb 2022 19:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438EDC340F5;
        Thu, 17 Feb 2022 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645127564;
        bh=ZhQxF0tPXMlYqWyHKU+1EFwIzt/X85cBfMSyiNtLNwc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=N3q7ZHzEir/9IK/PGW+3dMKawSKM3KHTVB0REMnWpIEazeg1BTxuWepTpRprIRKPI
         XmGpqTE40xrLD8tJkBKCJxDJFOHcr6iYvTnjlBsBBXMj3UbckzYkxN/7wU5Ygx5mrk
         ETE3YbdvQqT8R06yoKVRu6kMzrbvehESqHsLVNuR42qsb7LAj9NnFT2oA+kvsCETGt
         ox0NZV2AZw2DzmW07UuMa2RituDxee7maP037UT/LVLYS5cSaVkI4fklqI2IhpP5+V
         klEOQqAFRD7lzuSKdAr9w41EjgBa5tjoYjjyu/4ZNQJCNIfaK81rkYX9NflqCMGKSz
         ykTJRqwak3lzA==
Received: by mail-wm1-f53.google.com with SMTP id k127-20020a1ca185000000b0037bc4be8713so7014976wme.3;
        Thu, 17 Feb 2022 11:52:44 -0800 (PST)
X-Gm-Message-State: AOAM532172Lvk3f61e6H4Kx+ki0RC9qGprFMPFkmCPjvClzyy/VJixoa
        VlI5RHr/tjrzpsbppEDs3iZozS4McH4D8f4BAhk=
X-Google-Smtp-Source: ABdhPJwiemEIjRKk4frN6QbDwgyUBnVeU/8bBRkvxFxBQULsWx/seWlsMA1hduXoxyV0dNHVRWvY1oHknvGbya8Zxyg=
X-Received: by 2002:a05:600c:3d06:b0:37b:a5ea:a61b with SMTP id
 bh6-20020a05600c3d0600b0037ba5eaa61bmr4183906wmb.32.1645127562557; Thu, 17
 Feb 2022 11:52:42 -0800 (PST)
MIME-Version: 1.0
References: <20220128045004.4843-1-sunilvl@ventanamicro.com>
 <877d9xx14f.fsf@igel.home> <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de>
 <87tud1vjn4.fsf@igel.home> <49d3aeab-1fe6-8d17-bc83-78f3555109c7@gmx.de>
 <87pmnpvh66.fsf@igel.home> <20220217105450.GA20183@sunil-ThinkPad-T490> <CAOnJCULWjCHCCS7wzTBVsYcPzWPpL9jmS7xx5LUFT2tRvAZk6w@mail.gmail.com>
In-Reply-To: <CAOnJCULWjCHCCS7wzTBVsYcPzWPpL9jmS7xx5LUFT2tRvAZk6w@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 17 Feb 2022 20:52:30 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFXu75cDo=rx4rG6WFwd=At+nMWRzq378EoLu7GuHU64w@mail.gmail.com>
Message-ID: <CAMj1kXFXu75cDo=rx4rG6WFwd=At+nMWRzq378EoLu7GuHU64w@mail.gmail.com>
Subject: Re: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Sunil V L <sunilvl@ventanamicro.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <apatel@ventanamicro.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Feb 2022 at 20:47, Atish Patra <atishp@atishpatra.org> wrote:
>
> On Thu, Feb 17, 2022 at 2:55 AM Sunil V L <sunilvl@ventanamicro.com> wrote:
> >
> > On Mon, Feb 14, 2022 at 12:09:05PM +0100, Andreas Schwab wrote:
> > > On Feb 14 2022, Heinrich Schuchardt wrote:
> > >
> > > > On 2/14/22 11:15, Andreas Schwab wrote:
> > > >> On Feb 14 2022, Heinrich Schuchardt wrote:
> > > >>
> > > >>> set_boot_hartid() implies that the caller can change the boot hart ID.
> > > >>> As this is not a case this name obviously would be a misnomer.
> > > >>
> > > >> initialize_boot_hartid would fit better.
> > > >>
> > > >
> > > > Another misnomer.
> > >
> > > But the best fit so far.
> >
> > Can we use the name init_boot_hartid_from_fdt()? While I understand
> > Heinrich's point, I think since we have "_from_fdt", this may be fine.
> >
>
> init_boot_hartid_from_fdt or parse_boot_hartid_from_fdt
>
> are definitely much better than the current one.
>
> > I didn't rename the function since it was not recommended to do multiple
> > things in a "Fix" patch. If we can consider this as not very serious
> > issue which needs a "Fix" patch, then I can combine this patch with the
> > RISCV_EFI_BOOT_PROTOCOL patch series.
> >
>
> IMHO, it is okay to include this in the RISCV_EFI_BOOT_PROTOCOL series
> as we are not going to have hartid U32_MAX in a few months :)
>
>
> > Hi Ard, let me know your suggestion on how to proceed with this.
> >

The patch is fine as it is. I agree that naming is important, but for
a helper function that is only used a single time right in the same
source file, it doesn't matter that much.

I have queued this up now.

Thanks,
Ard.
