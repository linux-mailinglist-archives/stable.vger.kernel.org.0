Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074B24ADB3D
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 15:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377722AbiBHOfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 09:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377698AbiBHOfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 09:35:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C052C03FECE;
        Tue,  8 Feb 2022 06:35:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D044B81AF8;
        Tue,  8 Feb 2022 14:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC78C340F4;
        Tue,  8 Feb 2022 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644330900;
        bh=MrCNTTZmKlzAuz3fwnSg3bS0Qka94fcpFrFcZ3Mq0ow=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z1sh7V+nSOP9Xw+WaHe/Pd5mAeLjC6KNy6v3Vk6r02zerPzzwiu+lmz6HXtb450zq
         K8VGu3fZbe1EJsV1QmrKvOCbZYraliQLRbosS7/NKPOeAjPrwuz8K/XQehnC80K3nY
         QEm4YhVEAVqypa0UgkSvFlzX19mCfCB5ec5MS5WlK4h/8WaVSDPsj/Bdd8VFhc42Uk
         eOS7orjVYe6aQxFoPxpHj0HQ+1gXvbcZyiA35O73rADWOLGV90KrehQkp9Qh8nYokp
         d8I9gt+g31RQoXsmvIaJ/ZTT1SJ023b/viLHLt24iIjHDblyr28Al3DSQWatqwzIOV
         Ek9EhUOVRYxaQ==
Received: by mail-ed1-f41.google.com with SMTP id u18so37534102edt.6;
        Tue, 08 Feb 2022 06:35:00 -0800 (PST)
X-Gm-Message-State: AOAM531Qx2f7G1Xv8EXVgBjdFttRy3KhbtGe7Pq7xmktu6WyphbmIidy
        MgbYhBL2fNFfh2mgIXjNWtc2n105hM/9jGbp+g==
X-Google-Smtp-Source: ABdhPJy79mBKqHZM3sFn6qThXw/30s+hgz04lOPjxO5dJceaXnncLpPviPXlfIbr9FBR1E+ZpwotuJSjNklQfR51GjU=
X-Received: by 2002:a50:8a89:: with SMTP id j9mr4760118edj.111.1644330896918;
 Tue, 08 Feb 2022 06:34:56 -0800 (PST)
MIME-Version: 1.0
References: <20211129173637.303201-1-robh@kernel.org> <Yf2wTLjmcRj+AbDv@xps13.dannf>
 <CAL_Jsq+4b4Yy8rJGJv9j9j_TCm6mTAkW5fzcDuuW-jOoiZ2GLg@mail.gmail.com>
 <CALdTtnuK+D7gNbEDgHbrc29pFFCR3XYAHqrK3=X_hQxUx-Seow@mail.gmail.com>
 <CAL_JsqJUmjG-SiuR9T7f=5nGcSjTLhuF_382EQDf74kcqdAq_w@mail.gmail.com> <YgHFFIRT6E0j9TlX@xps13.dannf>
In-Reply-To: <YgHFFIRT6E0j9TlX@xps13.dannf>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 8 Feb 2022 08:34:45 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJLTkDm_ZbFWSKwKvVAh0KpxiS9y6LEwmhQ-kejTcLq7A@mail.gmail.com>
Message-ID: <CAL_JsqJLTkDm_ZbFWSKwKvVAh0KpxiS9y6LEwmhQ-kejTcLq7A@mail.gmail.com>
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

On Mon, Feb 7, 2022 at 7:19 PM dann frazier <dann.frazier@canonical.com> wr=
ote:
>
> On Mon, Feb 07, 2022 at 10:09:31AM -0600, Rob Herring wrote:
> > On Sat, Feb 5, 2022 at 3:13 PM dann frazier <dann.frazier@canonical.com=
> wrote:
> > >
> > > On Sat, Feb 5, 2022 at 9:05 AM Rob Herring <robh@kernel.org> wrote:
> > > >
> > > > On Fri, Feb 4, 2022 at 5:01 PM dann frazier <dann.frazier@canonical=
.com> wrote:
> > > > >
> > > > > On Mon, Nov 29, 2021 at 11:36:37AM -0600, Rob Herring wrote:
> > > > > > Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for set=
up")
> > > > > > broke PCI support on XGene. The cause is the IB resources are n=
ow sorted
> > > > > > in address order instead of being in DT dma-ranges order. The r=
esult is
> > > > > > which inbound registers are used for each region are swapped. I=
 don't
> > > > > > know the details about this h/w, but it appears that IB region =
0
> > > > > > registers can't handle a size greater than 4GB. In any case, li=
miting
> > > > > > the size for region 0 is enough to get back to the original ass=
ignment
> > > > > > of dma-ranges to regions.
> > > > >
> > > > > hey Rob!
> > > > >
> > > > > I've been seeing a panic on HP Moonshoot m400 cartridges (X-Gene1=
) -
> > > > > only during network installs - that I also bisected down to commi=
t
> > > > > 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup"). I w=
as
> > > > > hoping that this patch that fixed the issue on St=C3=A9phane's X-=
Gene2
> > > > > system would also fix my issue, but no luck. In fact, it seems to=
 just
> > > > > makes it fail differently. Reverting both patches is required to =
get a
> > > > > v5.17-rc kernel to boot.
> > > > >
> > > > > I've collected the following logs - let me know if anything else =
would
> > > > > be useful.
> > > > >
> > > > > 1) v5.17-rc2+ (unmodified):
> > > > >    http://dannf.org/bugs/m400-no-reverts.log
> > > > >    Note that the mlx4 driver fails initialization.
> > > > >
> > > > > 2) v5.17-rc2+, w/o the commit that fixed St=C3=A9phane's system:
> > > > >    http://dannf.org/bugs/m400-xgene2-fix-reverted.log
> > > > >    Note the mlx4 MSI-X timeout, and later panic.
> > > > >
> > > > > 3) v5.17-rc2+, w/ both commits reverted (works)
> > > > >    http://dannf.org/bugs/m400-both-reverted.log
> > > >
> > > > The ranges and dma-ranges addresses don't appear to match up with a=
ny
> > > > upstream dts files. Can you send me the DT?
> > >
> > > Sure: http://dannf.org/bugs/fdt
> >
> > The first fix certainly is a problem. It's going to need something
> > besides size to key off of (originally it was dependent on order of
> > dma-ranges entries).
> >
> > The 2nd issue is the 'dma-ranges' has a second entry that is now ignore=
d:
> >
> > dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00>, <0x00
> > 0x79000000 0x00 0x79000000 0x00 0x800000>;
> >
> > Based on the flags (3rd addr cell: 0x0), we have an inbound config
> > space which the kernel now ignores because inbound config space
> > accesses make no sense. But clearly some setup is needed. Upstream, in
> > contrast, sets up a memory range that includes this region, so the
> > setup does happen:
> >
> > <0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>
> >
> > Minimally, I suspect it will work if you change dma-ranges 2nd entry to=
:
> >
> > <0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>
>
> Thanks for looking into this Rob. I tried to test that theory, but it
> didn't seem to work. This is what I tried:
>
> --- m400.dts    2022-02-07 20:16:44.840475323 +0000
> +++ m400.dts.dmaonly    2022-02-08 00:17:54.097132000 +0000
> @@ -446,7 +446,7 @@
>                         reg =3D <0x00 0x1f2b0000 0x00 0x10000 0xe0 0xd000=
0000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x80=
0000>;
>                         reg-names =3D "csr\0cfg\0msi_gen\0msi_term";
>                         ranges =3D <0x1000000 0x00 0x00 0xe0 0x10000000 0=
x00 0x10000 0x2000000 0x00 0x30000000 0xe1 0x30000000 0x00 0x80000000>;
> -                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> +                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x4=
0 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges-ep =3D <0x2000000 0x00 0x00 0x00 0x00 0=
x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x7=
9000000 0x00 0x79000000 0x00 0x100000>;
>                         interrupts =3D <0x00 0x10 0x04>;
> @@ -471,7 +471,7 @@
>                         reg =3D <0x00 0x1f2c0000 0x00 0x10000 0xd0 0xd000=
0000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x80=
0000>;
>                         reg-names =3D "csr\0cfg\0msi_gen\0msi_term";
>                         ranges =3D <0x1000000 0x00 0x00 0xd0 0x10000000 0=
x00 0x10000 0x2000000 0x00 0x30000000 0xd1 0x30000000 0x00 0x80000000>;
> -                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> +                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x4=
0 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges-ep =3D <0x2000000 0x00 0x00 0x00 0x00 0=
x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x7=
9000000 0x00 0x79000000 0x00 0x100000>;
>                         interrupts =3D <0x00 0x10 0x04>;
> @@ -496,7 +496,7 @@
>                         reg =3D <0x00 0x1f2d0000 0x00 0x10000 0x90 0xd000=
0000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x80=
0000>;
>                         reg-names =3D "csr\0cfg\0msi_gen\0msi_term";
>                         ranges =3D <0x1000000 0x00 0x00 0x90 0x10000000 0=
x00 0x10000 0x2000000 0x00 0x30000000 0x91 0x30000000 0x00 0x80000000>;
> -                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> +                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x4=
0 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges-ep =3D <0x2000000 0x00 0x00 0x00 0x00 0=
x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x7=
9000000 0x00 0x79000000 0x00 0x100000>;
>                         interrupts =3D <0x00 0x10 0x04>;
> @@ -522,7 +522,7 @@
>                         reg =3D <0x00 0x1f500000 0x00 0x10000 0xa0 0xd000=
0000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x80=
0000>;
>                         reg-names =3D "csr\0cfg\0msi_gen\0msi_term";
>                         ranges =3D <0x2000000 0x00 0x30000000 0xa1 0x3000=
0000 0x00 0x80000000>;
> -                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> +                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x4=
0 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges-ep =3D <0x2000000 0x00 0x00 0x00 0x00 0=
x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x7=
9000000 0x00 0x79000000 0x00 0x100000>;
>                         interrupts =3D <0x00 0x10 0x04>;
> @@ -547,7 +547,7 @@
>                         reg =3D <0x00 0x1f510000 0x00 0x10000 0xc0 0xd000=
0000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x80=
0000>;
>                         reg-names =3D "csr\0cfg\0msi_gen\0msi_term";
>                         ranges =3D <0x1000000 0x00 0x00 0xc0 0x10000000 0=
x00 0x10000 0x2000000 0x00 0x30000000 0xc1 0x30000000 0x00 0x80000000>;
> -                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
> +                       dma-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x=
40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges =3D <0x42000000 0x40 0x00 0x40 0x00 0x4=
0 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>                         ib-ranges-ep =3D <0x2000000 0x00 0x00 0x00 0x00 0=
x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x7=
9000000 0x00 0x79000000 0x00 0x100000>;
>                         interrupts =3D <0x00 0x10 0x04>;
>
> And that failed to boot with a 5.17-rc3. Since dma-ranges was
> previously identical to ib-ranges, I also tried making the same change
> to ib-ranges, but with no success.

Failed to boot at all or just PCIe still didn't work causing boot to
eventually fail? 'ib-ranges' is unknown to the kernel, so the firmware
is using it somehow?

You also need to revert the first fix for PCIe to work.


> > While we shouldn't break existing DTs, the moonshot DT doesn't use
> > what's documented upstream. There are multiple differences compared to
> > what's documented. Is upstream supposed to support upstream DTs,
> > downstream DTs, and ACPI for XGene which is an abandoned platform with
> > only a handful of users?
>
> That's a fair question, though it's one of a policy, and I feel I'd be
> overstepping by weighing in. I suppose one option I have is to try
> and create and upstream a dts for these systems and modify our
> boot.scr to always load that over the one provided by firmware. While
> we do have some of these systems in production, they are being retired
> and replaced with newer kit over time, and it's possible we'll never
> need to upgrade them to a modern kernel.
>
>   -dann
