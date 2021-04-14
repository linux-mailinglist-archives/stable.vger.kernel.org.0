Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1E135ED50
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349241AbhDNGk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:40:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63558 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349243AbhDNGkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 02:40:43 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210414064020euoutp02433eeecfd37ff7e5c1fb9d2e315a677f~1pjycsBDl3136431364euoutp024
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 06:40:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210414064020euoutp02433eeecfd37ff7e5c1fb9d2e315a677f~1pjycsBDl3136431364euoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1618382420;
        bh=H56gZ5sOUpuywwIUhKw7ev6AyUwZ/h1833wXxZ/+qic=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=J3GdznMxnN7TH5b6dq9kb8kr9gqfOLKbpr3yNGcpUwfRk+coDxxxV+osJhdievhrb
         oJJOr6NEtXRQo811iRwOsGJeWfPrgrxJW+xv2xw+LYsV4BdICiUaUHFCdpFXEzdgWW
         /ukKvypQcNf5B+5+lP3Q4rStlsN93ONPG7iWSY+o=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210414064020eucas1p2a7529e7b9b1758b56e9a94fe658e01ad~1pjyKshEo1403614036eucas1p2Q;
        Wed, 14 Apr 2021 06:40:20 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 7A.63.09444.35E86706; Wed, 14
        Apr 2021 07:40:19 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210414064019eucas1p2b4659d8e8e653b6004c3c7421adb1e44~1pjxg92am1401014010eucas1p2T;
        Wed, 14 Apr 2021 06:40:19 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210414064019eusmtrp297c82d2621cad9bb4fdf5eb0b1826964~1pjxgHONu0270802708eusmtrp2n;
        Wed, 14 Apr 2021 06:40:19 +0000 (GMT)
X-AuditID: cbfec7f4-dbdff700000024e4-f0-60768e53f45e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 6F.CE.08696.35E86706; Wed, 14
        Apr 2021 07:40:19 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210414064018eusmtip12ede421b08548f82fbdc514204c230b3~1pjwsY0Su2380423804eusmtip1k;
        Wed, 14 Apr 2021 06:40:18 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: dwc: Move iATU detection earlier
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     linux-arm-msm@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-pci@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, stable@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <982668fd-ea62-208b-afa3-bd020a7dc049@samsung.com>
Date:   Wed, 14 Apr 2021 08:40:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413142219.2301430-1-dmitry.baryshkov@linaro.org>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7djP87rBfWUJBk2zrS3OPf7NYrGkKcPi
        9P53LBYTz/9kszh8o4nRYuL+s+wWZ+cdZ7N48/sFu8Xdlk5Wi9a9R9gt/u/ZwW6xYOMjRosT
        bR/YHXg91sxbw+ixYFOpx6ZVnWwed67tYfPY+G4Hk8eJ6d9ZPD5vkgtgj+KySUnNySxLLdK3
        S+DKePVkJVNBl0pF7/Hn7A2MK+S6GDk5JARMJD6fPcIIYgsJrGCUeHtWo4uRC8j+wijR17uK
        FcL5zCixYPUqRpiOu0+WQCWWM0p8Ov+NCaL9I1DVPm4QW1jAVmLZ6x2sILaIwFVGic8XZUAa
        mAU2MUlsn3GEHSTBJmAo0fW2iw3E5hWwk9i6dyYLiM0ioCqx4NZDsLioQJLEzUv/mSFqBCVO
        znwCVsMp4CzRd/4BWJxZQF5i+9s5ULa4xK0n85lAlkkITOaUWNvzE+psF4ltN18yQdjCEq+O
        b2GHsGUk/u+EaWhmlHh4bi07hNPDKHG5aQZUt7XEnXO/gE7iAFqhKbF+lz5E2FHi0vUWJpCw
        hACfxI23ghBH8ElM2jadGSLMK9HRJgRRrSYx6/g6uLUHL1xinsCoNAvJa7OQvDMLyTuzEPYu
        YGRZxSieWlqcm55abJSXWq5XnJhbXJqXrpecn7uJEZjQTv87/mUH4/JXH/UOMTJxMB5ilOBg
        VhLhdZtSkiDEm5JYWZValB9fVJqTWnyIUZqDRUmcN2nLmnghgfTEktTs1NSC1CKYLBMHp1QD
        06xrO3S/CeiG1jEt9Cj51xOc6eg0x7llh/XdncemedZ3bdJXi9SrUKxwm5Du3vdf1WPHy9Co
        BOajD1pMarZG6DZts4radFVD8akMx+aJP/ccNZvzyPfhuot6+8+oa7NsObA11fhiwJKZ83h/
        fMv9dayU26FUbtmeaz3b76a8eSnaUcGa/mYvs1HelVc2JkyM/1SOHGvcq/Kt6Wb/2hLbCa9u
        7++2Y996I2Hqz5V7P778Zy39491fNbm560IyLldb9259rTmRteZ09j1vOZV/yx7b7Tks3qV4
        cqLMkt7u3Df5LNM4v89R11uc+eKX6PL9KTmdc2b8CeVz/+f4sCmhe9EDCSHuLVMjSgxVy6Ls
        /imxFGckGmoxFxUnAgDPfMal1wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/xu7rBfWUJBqtuc1uce/ybxWJJU4bF
        6f3vWCwmnv/JZnH4RhOjxcT9Z9ktzs47zmbx5vcLdou7LZ2sFq17j7Bb/N+zg91iwcZHjBYn
        2j6wO/B6rJm3htFjwaZSj02rOtk87lzbw+ax8d0OJo8T07+zeHzeJBfAHqVnU5RfWpKqkJFf
        XGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CX8erJSqaCLpWK3uPP2RsY
        V8h1MXJySAiYSNx9soS1i5GLQ0hgKaPEm1tzWSESMhInpzVA2cISf651sUEUvWeUeLfmBRtI
        QljAVmLZ6x1g3SIC1xkl1py5yA7iMAtsYZL4NKsFau40RokDl5uZQFrYBAwlut52gbXzCthJ
        bN07kwXEZhFQlVhw6yFYXFQgSeLe5ZXMEDWCEidnPgGr4RRwlug7/wAszixgJjFv80MoW15i
        +9s5ULa4xK0n85kmMArNQtI+C0nLLCQts5C0LGBkWcUoklpanJueW2ykV5yYW1yal66XnJ+7
        iREYx9uO/dyyg3Hlq496hxiZOBgPMUpwMCuJ8LpNKUkQ4k1JrKxKLcqPLyrNSS0+xGgK9M9E
        ZinR5HxgIskriTc0MzA1NDGzNDC1NDNWEuc1ObImXkggPbEkNTs1tSC1CKaPiYNTqoGpL4TJ
        e5bPfN3jqm5Puad0a4pu0q+bUVzDoGWtZcXPM+PrWcFUYfuUHRZr3FVy9/Aum9CVdfLCusiz
        jHOZ1Xut443lopfw2NpwLik/Xzz5crzszRsHOFdNXBOY+ofz6EXevxlva3Z/Y76nxqn6aHWx
        4tfcf6tO+pvd3n7LVuwud/vPuAKN0LrAyCcaW0T1C2e8VeWd2mN8bsXOzIZW2azMLBGxnw1V
        yxa/uTwv9o6+78TpLSuED29WCHvrdmyq/fQrC5VSZx25++HR5bNrKw+7xLIdvWq+5mz+itRs
        j1yph3FLfogePqJ7SsDD4dCDxzMjPK8ZBOcdnbNdWXtyYNHO93aurXXyE9/+4bq7koVFiaU4
        I9FQi7moOBEAkac1oGwDAAA=
X-CMS-MailID: 20210414064019eucas1p2b4659d8e8e653b6004c3c7421adb1e44
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210413142228eucas1p105a35585dfedf7faf301942e47039563
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210413142228eucas1p105a35585dfedf7faf301942e47039563
References: <CGME20210413142228eucas1p105a35585dfedf7faf301942e47039563@eucas1p1.samsung.com>
        <20210413142219.2301430-1-dmitry.baryshkov@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 13.04.2021 16:22, Dmitry Baryshkov wrote:
> From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
>
> dw_pcie_ep_init() depends on the detected iATU region numbers to allocate
> the in/outbound window management bitmap.  It fails after 281f1f99cf3a
> ("PCI: dwc: Detect number of iATU windows").
>
> Move the iATU region detection into a new function, move the detection to
> the very beginning of dw_pcie_host_init() and dw_pcie_ep_init().  Also
> remove it from the dw_pcie_setup(), since it's more like a software
> initialization step than hardware setup.
>
> Fixes: 281f1f99cf3a ("PCI: dwc: Detect number of iATU windows")
> Link: https://lore.kernel.org/r/20210125044803.4310-1-Zhiqiang.Hou@nxp.com
> Tested-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Cc: stable@vger.kernel.org	# v5.11+
> [DB: moved dw_pcie_iatu_detect to happen after host_init callback]
> Link: https://lore.kernel.org/linux-pci/20210407131255.702054-1-dmitry.baryshkov@linaro.org
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Works fine on Samsung Exynos5433 based TM2e board after moving the call 
after host_init callback:

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/pci/controller/dwc/pcie-designware-ep.c   |  2 ++
>   drivers/pci/controller/dwc/pcie-designware-host.c |  1 +
>   drivers/pci/controller/dwc/pcie-designware.c      | 11 ++++++++---
>   drivers/pci/controller/dwc/pcie-designware.h      |  1 +
>   4 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
> index 1c25d8337151..8d028a88b375 100644
> --- a/drivers/pci/controller/dwc/pcie-designware-ep.c
> +++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
> @@ -705,6 +705,8 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
>   		}
>   	}
>   
> +	dw_pcie_iatu_detect(pci);
> +
>   	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "addr_space");
>   	if (!res)
>   		return -EINVAL;
> diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
> index 7e55b2b66182..24192b40e3a2 100644
> --- a/drivers/pci/controller/dwc/pcie-designware-host.c
> +++ b/drivers/pci/controller/dwc/pcie-designware-host.c
> @@ -398,6 +398,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
>   		if (ret)
>   			goto err_free_msi;
>   	}
> +	dw_pcie_iatu_detect(pci);
>   
>   	dw_pcie_setup_rc(pp);
>   	dw_pcie_msi_init(pp);
> diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
> index 004cb860e266..a945f0c0e73d 100644
> --- a/drivers/pci/controller/dwc/pcie-designware.c
> +++ b/drivers/pci/controller/dwc/pcie-designware.c
> @@ -660,11 +660,9 @@ static void dw_pcie_iatu_detect_regions(struct dw_pcie *pci)
>   	pci->num_ob_windows = ob;
>   }
>   
> -void dw_pcie_setup(struct dw_pcie *pci)
> +void dw_pcie_iatu_detect(struct dw_pcie *pci)
>   {
> -	u32 val;
>   	struct device *dev = pci->dev;
> -	struct device_node *np = dev->of_node;
>   	struct platform_device *pdev = to_platform_device(dev);
>   
>   	if (pci->version >= 0x480A || (!pci->version &&
> @@ -693,6 +691,13 @@ void dw_pcie_setup(struct dw_pcie *pci)
>   
>   	dev_info(pci->dev, "Detected iATU regions: %u outbound, %u inbound",
>   		 pci->num_ob_windows, pci->num_ib_windows);
> +}
> +
> +void dw_pcie_setup(struct dw_pcie *pci)
> +{
> +	u32 val;
> +	struct device *dev = pci->dev;
> +	struct device_node *np = dev->of_node;
>   
>   	if (pci->link_gen > 0)
>   		dw_pcie_link_set_max_speed(pci, pci->link_gen);
> diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
> index 7247c8b01f04..7d6e9b7576be 100644
> --- a/drivers/pci/controller/dwc/pcie-designware.h
> +++ b/drivers/pci/controller/dwc/pcie-designware.h
> @@ -306,6 +306,7 @@ int dw_pcie_prog_inbound_atu(struct dw_pcie *pci, u8 func_no, int index,
>   void dw_pcie_disable_atu(struct dw_pcie *pci, int index,
>   			 enum dw_pcie_region_type type);
>   void dw_pcie_setup(struct dw_pcie *pci);
> +void dw_pcie_iatu_detect(struct dw_pcie *pci);
>   
>   static inline void dw_pcie_writel_dbi(struct dw_pcie *pci, u32 reg, u32 val)
>   {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

