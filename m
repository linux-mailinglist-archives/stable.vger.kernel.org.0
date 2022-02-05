Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F734AA9E3
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 17:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344180AbiBEQFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 11:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiBEQFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 11:05:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBABC061348;
        Sat,  5 Feb 2022 08:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 915CFB80838;
        Sat,  5 Feb 2022 16:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DD4C340F0;
        Sat,  5 Feb 2022 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644077114;
        bh=iGl+LyscJtuYcWTnVG1S7euCrsahtiihJfZ5fXoL1oY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=X8JG6/nhNcYBVz4/LJvbKrIf9ECKksD7ZPe9T0KLjN00eoxdzDXuvV2g8JObMwM4I
         SuCGv5ZhUw9sOU+AEEsrb2XsQa+vAkMziBmFjJjP0lSzFd4Q6GM/kaCjROVvGspsi7
         3puFJhl2RPVG1IbT+Xqx+czYGYI6+nRICXb8lWM2/OipmgBJ/Coh+Y9wKrm/NiLlX/
         KjFu8LDsqipVQ+NuE8G2uVmzI1C3CWZXqJHLg4aQECoqtFSa+GBW1QSawTe3WFa4nZ
         xLuxXnBJodnVEIGiQdVAhS66UU+gWPH42wopjR0PUSpZgrAL4Mzp45jX+v8dsW8ac7
         fNKUn3xkrm/pw==
Received: by mail-ej1-f52.google.com with SMTP id h7so28847606ejf.1;
        Sat, 05 Feb 2022 08:05:14 -0800 (PST)
X-Gm-Message-State: AOAM533BmffB8VwulVYvmGcopmH8FfdehOJh+LosYs0QmdJu3DaFOfWb
        Wkc+PNKqW2mVOtgXPoM0wWq0hO4yuXrdbkc/Gg==
X-Google-Smtp-Source: ABdhPJytLF9Q2nt2dRl8Opyzi56TDl6eMrr5GoPOpmBw0oArIh2ZSq9F81OSLu+ma2Vdkgt5+UD3teTYmfNPZUliJI8=
X-Received: by 2002:a17:906:4781:: with SMTP id cw1mr3582423ejc.264.1644077112652;
 Sat, 05 Feb 2022 08:05:12 -0800 (PST)
MIME-Version: 1.0
References: <20211129173637.303201-1-robh@kernel.org> <Yf2wTLjmcRj+AbDv@xps13.dannf>
In-Reply-To: <Yf2wTLjmcRj+AbDv@xps13.dannf>
From:   Rob Herring <robh@kernel.org>
Date:   Sat, 5 Feb 2022 10:05:01 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+4b4Yy8rJGJv9j9j_TCm6mTAkW5fzcDuuW-jOoiZ2GLg@mail.gmail.com>
Message-ID: <CAL_Jsq+4b4Yy8rJGJv9j9j_TCm6mTAkW5fzcDuuW-jOoiZ2GLg@mail.gmail.com>
Subject: Re: [PATCH] PCI: xgene: Fix IB window setup
To:     dann frazier <dann.frazier@canonical.com>
Cc:     Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        stable <stable@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 4, 2022 at 5:01 PM dann frazier <dann.frazier@canonical.com> wr=
ote:
>
> On Mon, Nov 29, 2021 at 11:36:37AM -0600, Rob Herring wrote:
> > Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> > broke PCI support on XGene. The cause is the IB resources are now sorte=
d
> > in address order instead of being in DT dma-ranges order. The result is
> > which inbound registers are used for each region are swapped. I don't
> > know the details about this h/w, but it appears that IB region 0
> > registers can't handle a size greater than 4GB. In any case, limiting
> > the size for region 0 is enough to get back to the original assignment
> > of dma-ranges to regions.
>
> hey Rob!
>
> I've been seeing a panic on HP Moonshoot m400 cartridges (X-Gene1) -
> only during network installs - that I also bisected down to commit
> 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup"). I was
> hoping that this patch that fixed the issue on St=C3=A9phane's X-Gene2
> system would also fix my issue, but no luck. In fact, it seems to just
> makes it fail differently. Reverting both patches is required to get a
> v5.17-rc kernel to boot.
>
> I've collected the following logs - let me know if anything else would
> be useful.
>
> 1) v5.17-rc2+ (unmodified):
>    http://dannf.org/bugs/m400-no-reverts.log
>    Note that the mlx4 driver fails initialization.
>
> 2) v5.17-rc2+, w/o the commit that fixed St=C3=A9phane's system:
>    http://dannf.org/bugs/m400-xgene2-fix-reverted.log
>    Note the mlx4 MSI-X timeout, and later panic.
>
> 3) v5.17-rc2+, w/ both commits reverted (works)
>    http://dannf.org/bugs/m400-both-reverted.log

The ranges and dma-ranges addresses don't appear to match up with any
upstream dts files. Can you send me the DT?

Otherwise, we're going to need some debugging added to
xgene_pcie_setup_ib_reg() to see if the register setup changed. I can
come up with something next week.

Rob
