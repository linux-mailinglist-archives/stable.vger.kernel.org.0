Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D39D6AD6EC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 06:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCGFmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 00:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCGFmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 00:42:14 -0500
Received: from xry111.site (xry111.site [IPv6:2001:470:683e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863826C1A0;
        Mon,  6 Mar 2023 21:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1678167730;
        bh=MXs0RutSFeo030+emuNS6pf+otSoMivDBt6OOMQKw1Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UcrV19+N7mv6P5eYiuGuC652PSuAALGMJQoaV9fhES8mQg/xh7iYC/fREp+T8U63a
         lnN+fu5PQsAU6KebxnXaaJkQqygv1Y17GCWpJtP3Vbr9F00BcghprzHjwfZIlDFzzB
         /DJICzC5qK9gbOLXiE9oUoTD6gbPELUfifk+VAwI=
Received: from [IPv6:240e:358:1153:ee00:dc73:854d:832e:5] (unknown [IPv6:240e:358:1153:ee00:dc73:854d:832e:5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 8DAB965A9A;
        Tue,  7 Mar 2023 00:42:06 -0500 (EST)
Message-ID: <8996e9ba32cbdc24b828c9a37793b39f17eb33a8.camel@xry111.site>
Subject: Ping: [PATCH] PCI: kirin: Select REGMAP_MMIO for PCIE_KIRIN
From:   Xi Ruoyao <xry111@xry111.site>
To:     linux-pci@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Krzysztof =?gb2312?Q?Wilczy=A8=BDski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Xiaowei Song <songxiaowei@huawei.com>, stable@vger.kernel.org
Date:   Tue, 07 Mar 2023 13:42:01 +0800
In-Reply-To: <20230228043423.19335-1-xry111@xry111.site>
References: <20230228043423.19335-1-xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gentle ping.

On Tue, 2023-02-28 at 12:34 +0800, Xi Ruoyao wrote:
> pcie-kirin.c invokes devm_regmap_init_mmio, so it's necessary to
> select
> REGMAP_MMIO or vmlinux fails to link with "undefined reference to
> `__devm_regmap_init_mmio_clk`.
>=20
> Cc: stable@vger.kernel.org=C2=A0# at least for 6.1 and 6.2
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
> =C2=A0drivers/pci/controller/dwc/Kconfig | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/pci/controller/dwc/Kconfig
> b/drivers/pci/controller/dwc/Kconfig
> index 434f6a4f4041..d29551261e80 100644
> --- a/drivers/pci/controller/dwc/Kconfig
> +++ b/drivers/pci/controller/dwc/Kconfig
> @@ -307,6 +307,7 @@ config PCIE_KIRIN
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tristate "HiSilicon Kirin=
 series SoCs PCIe controllers"
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0depends on PCI_MSI
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0select PCIE_DW_HOST
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0select REGMAP_MMIO
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0help
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Say Y here if you =
want PCIe controller support
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 on HiSilicon Kirin=
 series SoCs.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
