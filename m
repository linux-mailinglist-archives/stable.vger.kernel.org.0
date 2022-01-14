Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F18048E50B
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 08:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiANHwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 02:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiANHwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 02:52:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F403BC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 23:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3308C61DD9
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 07:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C283C36AED
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 07:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642146760;
        bh=B2isBu7YCHL0qVjqCAfobs4ozgFfk9p7+gOi5ygFixs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XyHKj64CfqC4lT0o4iKQFGbBcOI/Wga/LI0BJAoa/4OT7SAa6pplvCcpa+yfpjA6Z
         p22xhpLPCx+mM9q552afk8Z1DxexhXo7bEdxfTS97V32y+DKb9AVOzIr+MShk2W+TV
         gc6+HQve1PJhST5LFND9KC6Jmra29xtFpqBUyjM2aiJTGkWRr1ch3grsexeTeCACRJ
         say9IXOZhQ1o4rugGIt+VbtfMN80dtbbyXb00PCulcZjuNDrrXT3X4NW1iZ9f7Y7m9
         t9ddPn+a1b8kh61MLY9UY1kTu1Up06DzruJg68Y3f0G0mYDKgbroYurNgT7wkSPHUH
         GyWro1SQ23uig==
Received: by mail-wm1-f46.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so5144936wme.0
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 23:52:40 -0800 (PST)
X-Gm-Message-State: AOAM531tra6xYMo9ER5OFU0V5ZpguYQCfcOEcASQGZGhsIzE0AsOBuEt
        KUqp4J7Aas9Lz9ujUT06DoJsIZ6hbYHfH2eVt8U=
X-Google-Smtp-Source: ABdhPJxfErEBqSsDmxgtmJLMWFashPkU5S4OLLnXmtcLsB+3LJ3wGRt9hVcRnrzMOH/b00RRwL8zEXqdlc6v1egs/zk=
X-Received: by 2002:a05:600c:3c9c:: with SMTP id bg28mr7085295wmb.190.1642146758797;
 Thu, 13 Jan 2022 23:52:38 -0800 (PST)
MIME-Version: 1.0
References: <6017b3e5-8ce2-1312-7f0b-b0d7991ee87e@oracle.com>
In-Reply-To: <6017b3e5-8ce2-1312-7f0b-b0d7991ee87e@oracle.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 14 Jan 2022 08:52:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEkoc=M1Y=C7vKhzSM5GJvjmQjeO_zxVyS1PLM4D9b9Kg@mail.gmail.com>
Message-ID: <CAMj1kXEkoc=M1Y=C7vKhzSM5GJvjmQjeO_zxVyS1PLM4D9b9Kg@mail.gmail.com>
Subject: Re: efi/libstub: arm64: Double check image alignment at entry -
 checked against EFI_KIMG_ALIGN or SEGMENT_ALIGN
To:     Mihai Carabas <mihai.carabas@oracle.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Karl Heubaum <karl.heubaum@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 at 08:29, Mihai Carabas <mihai.carabas@oracle.com> wrote:
>
> Hello Ard,
>
> In patch 'efi/libstub: arm64: Double check image alignment at entry'
> (c32ac11da3f83bb42b986702a9b92f0a14ed4182) you added the following check:
>
> if (!IS_ALIGNED((u64)_text, EFI_KIMG_ALIGN))
>      efi_err("FIRMWARE BUG: kernel image not aligned on %ldk boundary\n", +
> EFI_KIMG_ALIGN >> 10);
>
> Unfortunatelly the kernel is aligned at SEGMENT_SIZE and this is the size
> populated in the PE headers:
>
> arch/arm64/kernel/efi-header.S: .long   SEGMENT_ALIGN
> // SectionAlignment
>
> EFI_KIMG_ALIGN is defined as: (SEGMENT_ALIGN > THREAD_ALIGN ? SEGMENT_ALIGN
> : THREAD_ALIGN)
>
> So it depends on THREAD_ALIGN. On newer builds these message started to
> appear even though the loader (Grub) is taking into account the PE header
> (which is stating 64K).
>
> Did you want to also modify the alignment in the headers/linkers or may be
> check against SEGMENT_ALIGN?
>

Thanks for the report.

I missed that 64k pages kernels will need more alignment than what
they describe in the PE/COFF header. 64k is the maximum here so we
should check against SEGMENT_ALIGN not EFI_KIMG_ALIGN for the warning.
