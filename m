Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D02016FCB3
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgBZK43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:56:29 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:39845 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727463AbgBZK43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 05:56:29 -0500
Received: from [192.168.27.209] (unknown [37.157.136.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by extserv.mm-sol.com (Postfix) with ESMTPSA id E54EACF87;
        Wed, 26 Feb 2020 12:56:25 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mm-sol.com; s=201706;
        t=1582714585; bh=0fhTqZuAuScb+3wjVpZ3mzL33tpGlwZ/fo6HSg9kaIM=;
        h=Subject:To:Cc:From:Date:From;
        b=D9BpdAmeswVlbyJr/5FoHLhHLjdTNyEzmlRJj6TAZ7+7CU8zgN1hGEP1332YDhZad
         Tj1nw9rOL/Z//oM5+ctvSkIzMyGOuu0bV5qpliyN8RnN6cEvSLgk8887dwgMRoh6o/
         sZmTqZE0f6kwVf4gEcSZwUsqdgM8dd7snCBSP5G8vdrwiyL/g8UVv00scMt32U+mOw
         z1GfueVf8LZ1YcMcmDouZIXHe6kvTqMRSKH6qw8oEbFEAROjjC7LxNb8FCa9LnY84z
         6PX6Ui1CotV9CzMQhPJ5rXakN/dHnuPpDLecWexWWXCPWNe+dgtLsO5VZeNsPl37qS
         DD1+IPXhZ32qA==
Subject: Re: [PATCH v2] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marc Gonzalez <marc.w.gonzalez@free.fr>, stable@vger.kernel.org
References: <20191227012717.78965-1-bjorn.andersson@linaro.org>
 <20200226102255.GA13830@e121166-lin.cambridge.arm.com>
From:   Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <4e1587e9-352c-a2de-d136-18506500641d@mm-sol.com>
Date:   Wed, 26 Feb 2020 12:56:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226102255.GA13830@e121166-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lorenzo,

On 2/26/20 12:22 PM, Lorenzo Pieralisi wrote:
> On Thu, Dec 26, 2019 at 05:27:17PM -0800, Bjorn Andersson wrote:
>> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
>> the fixup to only affect the relevant PCIe bridges.
>>
>> Cc: stable@vger.kernel.org
> 
> Hi Bjorn,
> 
> to simplify stable's merging, would you mind helping me with
> the stable releases you want this patch to apply to please ?
> 

We've to have this in the patch:

Cc: stable@vger.kernel.org # v5.2+
Fixes: 322f03436692 ("PCI: qcom: Use default config space read function")

> I will apply it then.
> 
> Thanks,
> Lorenzo
> 
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> ---
>>
>> Stan, I picked up all the suggested device id's from the previous thread and
>> added 0x1000 for QCS404. I looked at creating platform specific defines in
>> pci_ids.h, but SDM845 has both 106 and 107... Please let me know if you would
>> prefer that I do this anyway.
>>
>>  drivers/pci/controller/dwc/pcie-qcom.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
>> index 5ea527a6bd9f..138e1a2d21cc 100644
>> --- a/drivers/pci/controller/dwc/pcie-qcom.c
>> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
>> @@ -1439,7 +1439,13 @@ static void qcom_fixup_class(struct pci_dev *dev)
>>  {
>>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
>>  }
>> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1000, qcom_fixup_class);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);
>>  
>>  static struct platform_driver qcom_pcie_driver = {
>>  	.probe = qcom_pcie_probe,
>> -- 
>> 2.24.0
>>

-- 
regards,
Stan
