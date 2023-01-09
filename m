Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A595A662DC0
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 18:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjAIR4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 12:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237399AbjAIRzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 12:55:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2F2395FF;
        Mon,  9 Jan 2023 09:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18F03CE113C;
        Mon,  9 Jan 2023 17:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E546C433EF;
        Mon,  9 Jan 2023 17:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673286669;
        bh=aLg8ieTOI3iGGwFQIfew1flIZp97QV5PnfMYuEyFUhw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FV9jpOyzGZ4/JO/LBn+d7PMjyW1yfrFOgNnPILkCxg32CnKpToOm/3krcZy0ejHex
         0A+2WhgCmTiV/nNw7OE6Ej/1uPKBzX4vYUZtfVY7jncrpGkddysGNEgZNDn/B4KLpF
         9Tc8/xJPjUa5M/fC97ovDMVKNdystZsemlXeg1VbVKCPe0c6ivX7wHk1e/Zc2OfbV6
         ALMDM4bCKj7qyd8Bn1b1qvcm8O0H28t90Nt5fFagGn8wux+1AEFulOd/5x39h9YAHe
         e8McRiqBXYM/752NePWoN+Q6Uh+5Kks1Kf47S7BQ1FF1no8YAB+ezBL5vuHGeFqM3o
         FRedd0EeNxKLA==
Received: by mail-lj1-f173.google.com with SMTP id o7so9324097ljj.8;
        Mon, 09 Jan 2023 09:51:09 -0800 (PST)
X-Gm-Message-State: AFqh2krewBIfpMIqMwR9P0xyDOiPvvbWbcBf3jY3QBOnbM2CEmdUqFeq
        e9hdO5+MnIxRjL/evWGBVsKalhSM9YZlSql3a9k=
X-Google-Smtp-Source: AMrXdXsTsA5wV3hCGYwy/I2Cd+AeCA/HAHjHSXfz9nUbduxVYXx5G/6Y6/+7EWE30D11/6IvMhy8+jmM4viE8WKIvG4=
X-Received: by 2002:a2e:96ce:0:b0:283:33fa:ee22 with SMTP id
 d14-20020a2e96ce000000b0028333faee22mr330520ljj.415.1673286667215; Mon, 09
 Jan 2023 09:51:07 -0800 (PST)
MIME-Version: 1.0
References: <20230109095948.2471205-1-ardb@kernel.org> <Y7xTf1SEPTXiCoPM@dev-arch.thelio-3990X>
In-Reply-To: <Y7xTf1SEPTXiCoPM@dev-arch.thelio-3990X>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 9 Jan 2023 18:50:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFphB3G=5V6sSVvjt2ZpB-mitkoz_vmjBESdCnNwOJe8A@mail.gmail.com>
Message-ID: <CAMj1kXFphB3G=5V6sSVvjt2ZpB-mitkoz_vmjBESdCnNwOJe8A@mail.gmail.com>
Subject: Re: [PATCH] efi: tpm: Avoid READ_ONCE() for accessing the event log
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        will@kernel.org, catalin.marinas@arm.com, stable@vger.kernel.org,
        Peter Jones <pjones@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Jan 2023 at 18:48, Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Mon, Jan 09, 2023 at 10:59:48AM +0100, Ard Biesheuvel wrote:
> > Nathan reports that recent kernels built with LTO will crash when doing
> > EFI boot using Fedora's GRUB and SHIM. The culprit turns out to be a
> > misaligned load from the TPM event log, which is annotated with
> > READ_ONCE(), and under LTO, this gets translated into a LDAR instruction
> > which does not tolerate misaligned accesses.
> >
> > Interestingly, this does not happen when booting the same kernel
> > straight from the UEFI shell, and so the fact that the event log may
> > appear misaligned in memory may be caused by a bug in GRUB or SHIM.
> >
> > However, using READ_ONCE() to access firmware tables is slightly unusual
> > in any case, and here, we only need to ensure that 'event' is not
> > dereferenced again after it gets unmapped, so a compiler barrier should
> > be sufficient, and works around the reported issue.
> >
> > Cc: <stable@vger.kernel.org>
> > Cc: Peter Jones <pjones@redhat.com>
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1782
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Based on the thread, I tested this patch without barrier() and my
> machine boots up just fine now with an LTO kernel. Thanks a lot for the
> analysis and fix!
>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
>

Thanks. I've queued this up as a EFI fix.
