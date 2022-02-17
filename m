Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95304BAA14
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 20:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245376AbiBQTrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 14:47:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbiBQTrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 14:47:20 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDAD2612C
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:47:03 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d310db3812so43870067b3.3
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 11:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oaFgdGApNlDvtZyiIfo82SRxAus8TF8HrqjXlvq9h8Y=;
        b=SuxQdh+t5+fvwh5ODRCj4O0o5dFuhnXt8wycvDS/oc9U/RxDeBZ3bX5ZeesGn6+oJY
         CgPo+r2zBBVKinwJc2jONuwupZkCPpbAswzez7svHTfufRM0UpnHc0JQysuQUpfg39SP
         AhXLqSKJ8RK3c/iQgxWFs5sMqgai7dSUoqMso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oaFgdGApNlDvtZyiIfo82SRxAus8TF8HrqjXlvq9h8Y=;
        b=wkY29J16X1zGfb1KkbI6c6xdlDXAdY8KW00GLyHgnSLX9p0FoIzYS3a8T7Aj5GRbeY
         AmcLYdDEvCN8mqi56Sx1dAvWtwa+nEvGuUZqCEp6P6dB+sfNxJ4c/LdgB17iNwrt5dLE
         4KDrTeZfh18rW4958d/BLTWB/cdyDWE+jODA5XVRqSYx8OypagAigYGARhNO6erhDlID
         GNJM+Td37PS39LlR0RUdi/u9ss7DAg/Qj+9kKsHKPgK6UgVm0X5Hv9qkxqIPYCC7nSKK
         iVFzu5y3uF+TCayuFy2Jnrk7iPLazdYbmYShuvXXKXACzVOMrTtK3KEcoXbhzduXGgm9
         izMA==
X-Gm-Message-State: AOAM530T1OdypYuEjmHWJSReYSrJokKGoiuaKCRejfLMXu/UbtPc3Or4
        gyihfqfsaBrmg0pUR7kEsvhnxEF4ABR4ZWRuXBHX
X-Google-Smtp-Source: ABdhPJyYFJ0q/2SlA60syxammhFOBpSQhcIB9lrLmw/nIlWery9i8zrN9e9Vgg9W2i5AsrahmkX7VAebgSiqcHvfTL4=
X-Received: by 2002:a81:924a:0:b0:2d6:b588:bd0e with SMTP id
 j71-20020a81924a000000b002d6b588bd0emr2097858ywg.402.1645127222718; Thu, 17
 Feb 2022 11:47:02 -0800 (PST)
MIME-Version: 1.0
References: <20220128045004.4843-1-sunilvl@ventanamicro.com>
 <877d9xx14f.fsf@igel.home> <9cd9f149-d2ea-eb55-b774-8d817b9b6cc9@gmx.de>
 <87tud1vjn4.fsf@igel.home> <49d3aeab-1fe6-8d17-bc83-78f3555109c7@gmx.de>
 <87pmnpvh66.fsf@igel.home> <20220217105450.GA20183@sunil-ThinkPad-T490>
In-Reply-To: <20220217105450.GA20183@sunil-ThinkPad-T490>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 17 Feb 2022 11:46:52 -0800
Message-ID: <CAOnJCULWjCHCCS7wzTBVsYcPzWPpL9jmS7xx5LUFT2tRvAZk6w@mail.gmail.com>
Subject: Re: [PATCH] riscv/efi_stub: Fix get_boot_hartid_from_fdt() return value
To:     Sunil V L <sunilvl@ventanamicro.com>
Cc:     Andreas Schwab <schwab@linux-m68k.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-efi <linux-efi@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <apatel@ventanamicro.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 2:55 AM Sunil V L <sunilvl@ventanamicro.com> wrote:
>
> On Mon, Feb 14, 2022 at 12:09:05PM +0100, Andreas Schwab wrote:
> > On Feb 14 2022, Heinrich Schuchardt wrote:
> >
> > > On 2/14/22 11:15, Andreas Schwab wrote:
> > >> On Feb 14 2022, Heinrich Schuchardt wrote:
> > >>
> > >>> set_boot_hartid() implies that the caller can change the boot hart ID.
> > >>> As this is not a case this name obviously would be a misnomer.
> > >>
> > >> initialize_boot_hartid would fit better.
> > >>
> > >
> > > Another misnomer.
> >
> > But the best fit so far.
>
> Can we use the name init_boot_hartid_from_fdt()? While I understand
> Heinrich's point, I think since we have "_from_fdt", this may be fine.
>

init_boot_hartid_from_fdt or parse_boot_hartid_from_fdt

are definitely much better than the current one.

> I didn't rename the function since it was not recommended to do multiple
> things in a "Fix" patch. If we can consider this as not very serious
> issue which needs a "Fix" patch, then I can combine this patch with the
> RISCV_EFI_BOOT_PROTOCOL patch series.
>

IMHO, it is okay to include this in the RISCV_EFI_BOOT_PROTOCOL series
as we are not going to have hartid U32_MAX in a few months :)


> Hi Ard, let me know your suggestion on how to proceed with this.
>
> Thanks
> Sunil
> >
> > --
> > Andreas Schwab, schwab@linux-m68k.org
> > GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
> > "And now for something completely different."



-- 
Regards,
Atish
