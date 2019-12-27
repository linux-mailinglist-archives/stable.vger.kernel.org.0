Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC79F12B35D
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 09:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfL0I7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 03:59:05 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:34357 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfL0I7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 03:59:05 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2019 03:59:04 EST
Received: from [192.168.1.13] (87-126-225-137.ip.btc-net.bg [87.126.225.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by extserv.mm-sol.com (Postfix) with ESMTPSA id 49135CF4E;
        Fri, 27 Dec 2019 10:51:56 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mm-sol.com; s=201706;
        t=1577436716; bh=bJiYGKO/9WPFqn77XOxGnZ0/2b7Pu46nlAv2y5Gj754=;
        h=Subject:To:Cc:From:Date:From;
        b=GPaSepEjMyGzmSZmQ40HyrYL9fJlz0X/j1s2Hs9YxZbDbPs/B5nQ2eKTdGeQcfjg8
         Q6eG92rSGfM4Khg4S3vjSg6Ip+Ai1gg8h9A6GEvOJ/4y7U+wuW/3go1j8miNjwRrR+
         B41SM2QkGhxCNg5HdyaPazzMBaQHBTc86jnlwPl1yr5ikF+Yp/prUlMqqjd0cbuBui
         rXNhHcR5WZk/YjsICbQN1DSL4IjLmASetdCpuHZ1bAPZNIkv/8JcjBdvSE+5TCTd0m
         12iWA2E3WW6ag575kWYhUWZWcgt7P2qA70tcPMMP2VEz5hov/Nrh2tnu0tLvqo3cvJ
         BNGUQFt3nXzFQ==
Subject: Re: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marc Gonzalez <marc.w.gonzalez@free.fr>, stable@vger.kernel.org
References: <20191227012717.78965-1-bjorn.andersson@linaro.org>
From:   Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <9e5ee7e8-aa63-e82c-8135-acc77b476c87@mm-sol.com>
Date:   Fri, 27 Dec 2019 10:51:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191227012717.78965-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On 12/27/19 3:27 AM, Bjorn Andersson wrote:
> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
> the fixup to only affect the relevant PCIe bridges.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Stan, I picked up all the suggested device id's from the previous thread and
> added 0x1000 for QCS404. I looked at creating platform specific defines in
> pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
> prefer that I do this anyway.

Looks good,

Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>

> 
>  drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 5ea527a6bd9f..138e1a2d21cc 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
>  {
>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
>  }
> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
>  
>  static struct platform_driver qcom_pcie_driver = {
>  	.probe = qcom_pcie_probe,
> 

-- 
regards,
Stan
