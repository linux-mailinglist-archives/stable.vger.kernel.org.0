Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9370A18EE8D
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 04:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgCWDhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 23:37:37 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16263 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCWDhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Mar 2020 23:37:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e782ea60000>; Sun, 22 Mar 2020 20:36:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 22 Mar 2020 20:37:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 22 Mar 2020 20:37:36 -0700
Received: from [10.19.66.205] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Mar
 2020 03:37:33 +0000
Subject: Re: [PATCH] phy: tegra: should select USB_PHY
To:     Corentin Labbe <clabbe@baylibre.com>, <jonathanh@nvidia.com>,
        <kishon@ti.com>, <thierry.reding@gmail.com>, <treding@nvidia.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <1584545013-19859-1-git-send-email-clabbe@baylibre.com>
X-Nvconfidentiality: public
From:   Nagarjuna Kristam <nkristam@nvidia.com>
Message-ID: <f720dc73-e6c3-ead7-6a45-6f2b54e0f4ff@nvidia.com>
Date:   Mon, 23 Mar 2020 09:09:41 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584545013-19859-1-git-send-email-clabbe@baylibre.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584934567; bh=0hfRlRzIddqZPpiMXJgOvPWCKjWj2e6XvJATvVythHo=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Asjl1iARSY27+VP5NLW7ipRgnnUhqQcODPj3NQ1VIqaR/HvKlS8L6D7JxTKD226P1
         ejfxlKg3/bUtfKYWgByF2LSuDAc6uxYqYUQa7y8yKRYeLQLjnSdf0BT/cN3wg3Lt8y
         jAoY+CbIParTjXM8TnlDLITOto9dQZ+HsaO1hoprfWw3GsUVMBlPEPL5ABxLlHbzNF
         PiOEGjXlquz6Jti4rHsej1O4SEPnTdO0ZIhl9Utf0d4Oum2B5m9ET/A1h9g1mZNZnf
         L3Roc4hHaNV07Nk6pomFOEnh8jNlIZCeBJ741PBIizMJtt2E/cuDU58yrF2em6wBWc
         k0I40MaXPMO+w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Nagarjuna Kristam <nkristam@nvidia.com>

On 18-03-2020 20:53, Corentin Labbe wrote:
> External email: Use caution opening links or attachments
> 
> 
> I have hit the following build error:
> armv7a-hardfloat-linux-gnueabi-ld: drivers/phy/tegra/xusb.o: in function `tegra_xusb_port_unregister':
> xusb.c:(.text+0x2ac): undefined reference to `usb_remove_phy'
> armv7a-hardfloat-linux-gnueabi-ld: drivers/phy/tegra/xusb.o: in function `tegra_xusb_setup_ports':
> xusb.c:(.text+0xf30): undefined reference to `usb_add_phy_dev'
> 
> PHY_TEGRA_XUSB should select USB_PHY
> 
> Fixes: 23babe30fb45d ("phy: tegra: xusb: Add usb-phy support")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>   drivers/phy/tegra/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/phy/tegra/Kconfig b/drivers/phy/tegra/Kconfig
> index df07c4dea059..a208aca4ba7b 100644
> --- a/drivers/phy/tegra/Kconfig
> +++ b/drivers/phy/tegra/Kconfig
> @@ -3,6 +3,7 @@ config PHY_TEGRA_XUSB
>          tristate "NVIDIA Tegra XUSB pad controller driver"
>          depends on ARCH_TEGRA
>          select USB_CONN_GPIO
> +       select USB_PHY
>          help
>            Choose this option if you have an NVIDIA Tegra SoC.
> 
> --
> 2.24.1
> 
