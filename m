Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363952FA50B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405962AbhARPcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:32:50 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51156 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405872AbhARPck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 10:32:40 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2021 10:32:21 EST
Received: from [192.168.0.3] (hst-221-43.medicom.bg [84.238.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: svarbanov@mm-sol.com)
        by extserv.mm-sol.com (Postfix) with ESMTPSA id 38932D0D4;
        Mon, 18 Jan 2021 17:21:52 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mm-sol.com; s=201706;
        t=1610983312; bh=i1NrteZMyUtusFI3Xa7Z0Tm0f2R0KAmp9SC0wkfqI+k=;
        h=Subject:To:Cc:From:Date:From;
        b=e0gXbSZYkyGUQv2NjAFBHk/sC8+vcq0dubLoTlMl1/MY/c4uq7IT08BAiiFwRCmHA
         FCuo3+zJGq3LLhzKGDMpoZKph60fkKEKhq2PebGVQ09p6CKjFq+bUDdAbXPqUpEamR
         IKOa+K/7/CJjkyXL0UlkCjz6YTh++8N3syKNVt1ED7ax85sg2y8wnDdGCnNjAw8ZXP
         KzDZkjonjclgAjt2v3n4T8AH9K/69yOV5C1+1rgtvGunQv4bVuTX0n1xRGXaYTLn7c
         AczEMs1EfG8UC6Xv9mtWEg2K/j0EIe+CzQn0vpHSGcBmYTmZKyCKiROJoYLYLAZqiw
         zkJu3JLyJ9ysA==
Subject: Re: [RESEND PATCH] PCI: qcom: use PHY_REFCLK_USE_PAD only for ipq8064
To:     Ansuel Smith <ansuelsmth@gmail.com>, lorenzo.pieralisi@arm.com
Cc:     Ilia Mirkin <imirkin@alum.mit.edu>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201019165555.8269-1-ansuelsmth@gmail.com>
From:   Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <b01f8aba-69cf-0809-0909-0d7adc9af4c0@mm-sol.com>
Date:   Mon, 18 Jan 2021 17:21:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201019165555.8269-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Thanks for the patch!

On 10/19/20 7:55 PM, Ansuel Smith wrote:
> The use of PHY_REFCLK_USE_PAD introduced a regression for apq8064
> devices. It was tested that while apq doesn't require the padding, ipq
> SoC must use it or the kernel hangs on boot.
> 
> Fixes: de3c4bf6489 ("PCI: qcom: Add support for tx term offset for rev 2.1.0")
> Reported-by: Ilia Mirkin <imirkin@alum.mit.edu>
> Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.19+

Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>

> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 3aac77a295ba..dad6e9ce66ba 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -387,7 +387,9 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  
>  	/* enable external reference clock */
>  	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
> -	val &= ~PHY_REFCLK_USE_PAD;
> +	/* USE_PAD is required only for ipq806x */
> +	if (!of_device_is_compatible(node, "qcom,pcie-apq8064"))
> +		val &= ~PHY_REFCLK_USE_PAD;
>  	val |= PHY_REFCLK_SSP_EN;
>  	writel(val, pcie->parf + PCIE20_PARF_PHY_REFCLK);
>  
> 

-- 
regards,
Stan
