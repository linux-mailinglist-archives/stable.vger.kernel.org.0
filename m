Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7618C462023
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 20:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345426AbhK2TTo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Nov 2021 14:19:44 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:42132
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231415AbhK2TRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 14:17:44 -0500
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 1FE5941E9F
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 19:14:25 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id i63so36451251lji.3
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 11:14:25 -0800 (PST)
X-Gm-Message-State: AOAM533e8XOOLOjSxCEiIXo+0ZW1pgRwhxG6uNFBDFUVFmZi8yUtaOoN
        n3d8oPRnuGHAz1HZyAJfk0ve+XGDdzBtaKjwX+Fj3g==
X-Google-Smtp-Source: ABdhPJy6tlWcl9tuWIn0Dybo+bAubAlmBJK8KhhQEV/k3KiuxwCNQAo3iiP7Kt6c0VpHRRrrbX3Owws2wxiVzvWgVgI=
X-Received: by 2002:a2e:5850:: with SMTP id x16mr51799860ljd.122.1638213264420;
 Mon, 29 Nov 2021 11:14:24 -0800 (PST)
MIME-Version: 1.0
References: <20211129173637.303201-1-robh@kernel.org>
In-Reply-To: <20211129173637.303201-1-robh@kernel.org>
From:   =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Date:   Mon, 29 Nov 2021 14:14:13 -0500
X-Gmail-Original-Message-ID: <CA+enf=vOE7dAPL+fpcFytxMkVsDcgrroCchWKYfd6YjGaE4bVQ@mail.gmail.com>
Message-ID: <CA+enf=vOE7dAPL+fpcFytxMkVsDcgrroCchWKYfd6YjGaE4bVQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: xgene: Fix IB window setup
To:     Rob Herring <robh@kernel.org>
Cc:     Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        stable@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 12:36 PM Rob Herring <robh@kernel.org> wrote:
>
> Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> broke PCI support on XGene. The cause is the IB resources are now sorted
> in address order instead of being in DT dma-ranges order. The result is
> which inbound registers are used for each region are swapped. I don't
> know the details about this h/w, but it appears that IB region 0
> registers can't handle a size greater than 4GB. In any case, limiting
> the size for region 0 is enough to get back to the original assignment
> of dma-ranges to regions.
>
> Reported-by: Stéphane Graber <stgraber@ubuntu.com>
> Fixes: 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> Link: https://lore.kernel.org/all/CA+enf=v9rY_xnZML01oEgKLmvY1NGBUUhnSJaETmXtDtXfaczA@mail.gmail.com/
> Cc: stable@vger.kernel.org # v5.5+
> Signed-off-by: Rob Herring <robh@kernel.org>

I've been running with this exact change on top of the latest 5.12
stable release for a few days now, so can confirm that on my hardware
it's behaving perfectly (on 4 different servers).

Tested-by: Stéphane Graber <stgraber@ubuntu.com>

> ---
>  drivers/pci/controller/pci-xgene.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
> index 56d0d50338c8..d83dbd977418 100644
> --- a/drivers/pci/controller/pci-xgene.c
> +++ b/drivers/pci/controller/pci-xgene.c
> @@ -465,7 +465,7 @@ static int xgene_pcie_select_ib_reg(u8 *ib_reg_mask, u64 size)
>                 return 1;
>         }
>
> -       if ((size > SZ_1K) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 0))) {
> +       if ((size > SZ_1K) && (size < SZ_4G) && !(*ib_reg_mask & (1 << 0))) {
>                 *ib_reg_mask |= (1 << 0);
>                 return 0;
>         }
> --
> 2.32.0
>
