Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3917D4AC56F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 17:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbiBGQWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 11:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345732AbiBGQJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 11:09:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9EEC0401E3;
        Mon,  7 Feb 2022 08:09:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54EABB81620;
        Mon,  7 Feb 2022 16:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B487C36AE2;
        Mon,  7 Feb 2022 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644250185;
        bh=zmd2o9oLA0EJ0hPOoSHeAgUAtJ/i5oTwZaJJrykDlgM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mJSTsCnbTI3gwg/8BhSVQ+RBGPrG+psB6hlPxH2TkERftMdOHpsCZTo5MNoeifO1L
         oFrULqWEX0iWf+gGMaZH2QDadFBqmSGfutMMDcVyYKu0uwtxsIRlZPSsWP+XN7t+gA
         r8OaZctUL0ilvXmdCUeQTDILiTKRgaqk5rtCiY+MEkaT+0HodiWd37fMVWTP+uaeya
         0zU4tVUBj2JvaEpJfySAVL5/b0dWuwoC3v8xANFI6+v+VCvFYfU5v4dcOruIH8co/X
         Je4AJeG6Vl3Vyo+7Euuk3LCkuySqicc0lRH4jodrf47WNRi/RLTPmyAnNHDKac1GqM
         dpmi98M+KgR3A==
Received: by mail-ed1-f42.google.com with SMTP id f17so14004784edd.2;
        Mon, 07 Feb 2022 08:09:45 -0800 (PST)
X-Gm-Message-State: AOAM532O3hG1AOvJ2wvbh2SeBUlFdEsZYiP3JcIBVdw+BfdP1NoWV6yQ
        ZcWy/S4q7xQoelYZctvy2uOm66fB5C2TE5QfGA==
X-Google-Smtp-Source: ABdhPJxkzi+j5PDhmc4PGrG364yBx0Lt608JLV09wibWGr9XJBFhwpweKp1UvdU3JzJzVyrWRoTz/EIpL6vQYPBMLKo=
X-Received: by 2002:a50:e68d:: with SMTP id z13mr160190edm.307.1644250183395;
 Mon, 07 Feb 2022 08:09:43 -0800 (PST)
MIME-Version: 1.0
References: <20211129173637.303201-1-robh@kernel.org> <Yf2wTLjmcRj+AbDv@xps13.dannf>
 <CAL_Jsq+4b4Yy8rJGJv9j9j_TCm6mTAkW5fzcDuuW-jOoiZ2GLg@mail.gmail.com> <CALdTtnuK+D7gNbEDgHbrc29pFFCR3XYAHqrK3=X_hQxUx-Seow@mail.gmail.com>
In-Reply-To: <CALdTtnuK+D7gNbEDgHbrc29pFFCR3XYAHqrK3=X_hQxUx-Seow@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 7 Feb 2022 10:09:31 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJUmjG-SiuR9T7f=5nGcSjTLhuF_382EQDf74kcqdAq_w@mail.gmail.com>
Message-ID: <CAL_JsqJUmjG-SiuR9T7f=5nGcSjTLhuF_382EQDf74kcqdAq_w@mail.gmail.com>
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 5, 2022 at 3:13 PM dann frazier <dann.frazier@canonical.com> wr=
ote:
>
> On Sat, Feb 5, 2022 at 9:05 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Fri, Feb 4, 2022 at 5:01 PM dann frazier <dann.frazier@canonical.com=
> wrote:
> > >
> > > On Mon, Nov 29, 2021 at 11:36:37AM -0600, Rob Herring wrote:
> > > > Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> > > > broke PCI support on XGene. The cause is the IB resources are now s=
orted
> > > > in address order instead of being in DT dma-ranges order. The resul=
t is
> > > > which inbound registers are used for each region are swapped. I don=
't
> > > > know the details about this h/w, but it appears that IB region 0
> > > > registers can't handle a size greater than 4GB. In any case, limiti=
ng
> > > > the size for region 0 is enough to get back to the original assignm=
ent
> > > > of dma-ranges to regions.
> > >
> > > hey Rob!
> > >
> > > I've been seeing a panic on HP Moonshoot m400 cartridges (X-Gene1) -
> > > only during network installs - that I also bisected down to commit
> > > 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup"). I was
> > > hoping that this patch that fixed the issue on St=C3=A9phane's X-Gene=
2
> > > system would also fix my issue, but no luck. In fact, it seems to jus=
t
> > > makes it fail differently. Reverting both patches is required to get =
a
> > > v5.17-rc kernel to boot.
> > >
> > > I've collected the following logs - let me know if anything else woul=
d
> > > be useful.
> > >
> > > 1) v5.17-rc2+ (unmodified):
> > >    http://dannf.org/bugs/m400-no-reverts.log
> > >    Note that the mlx4 driver fails initialization.
> > >
> > > 2) v5.17-rc2+, w/o the commit that fixed St=C3=A9phane's system:
> > >    http://dannf.org/bugs/m400-xgene2-fix-reverted.log
> > >    Note the mlx4 MSI-X timeout, and later panic.
> > >
> > > 3) v5.17-rc2+, w/ both commits reverted (works)
> > >    http://dannf.org/bugs/m400-both-reverted.log
> >
> > The ranges and dma-ranges addresses don't appear to match up with any
> > upstream dts files. Can you send me the DT?
>
> Sure: http://dannf.org/bugs/fdt

The first fix certainly is a problem. It's going to need something
besides size to key off of (originally it was dependent on order of
dma-ranges entries).

The 2nd issue is the 'dma-ranges' has a second entry that is now ignored:

dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00>, <0x00
0x79000000 0x00 0x79000000 0x00 0x800000>;

Based on the flags (3rd addr cell: 0x0), we have an inbound config
space which the kernel now ignores because inbound config space
accesses make no sense. But clearly some setup is needed. Upstream, in
contrast, sets up a memory range that includes this region, so the
setup does happen:

<0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>

Minimally, I suspect it will work if you change dma-ranges 2nd entry to:

<0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>

While we shouldn't break existing DTs, the moonshot DT doesn't use
what's documented upstream. There are multiple differences compared to
what's documented. Is upstream supposed to support upstream DTs,
downstream DTs, and ACPI for XGene which is an abandoned platform with
only a handful of users?

Rob
