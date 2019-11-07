Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D991F2ABF
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 10:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733220AbfKGJcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 04:32:54 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:49136 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfKGJcy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 04:32:54 -0500
Received: from [192.168.27.209] (unknown [37.157.136.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by extserv.mm-sol.com (Postfix) with ESMTPSA id 465E0CF1E;
        Thu,  7 Nov 2019 11:32:51 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mm-sol.com; s=201706;
        t=1573119171; bh=kHCNDH66hYlQtqftCtURnCy/XixN+D9RTn5mqQoeSzY=;
        h=Subject:To:Cc:From:Date:From;
        b=D0a+2FTc4psh6bsO4T9FUYhg7mG5YDf1aEfIlRIvcfXTZsmIKH5WyTIzqDE0t0+Cc
         J4zSI7KivfBujtK2moHGJxM6RM20gjNbxZ+wouyi0loUMlSICQyu6et4xvAZpumziM
         97YC3WVq74A1ZuffQzgPnH53fuAgKi8KTPc5kM5Mi1JYF/Sf3gtOtD5AxjZXbx4iPY
         6FqSytF/MW+WN36brasmgubMTXQxL7S/w8086nTC6GHWOZwXg0JDOfTepqgqkh9OhA
         g6TMkT8XrojIHVdd0IDa8zRiUsWZe7vAi5xs5yP1LNJX5APndP3CnL1sn6nPy4bYs0
         dRLAFjxZvTsFw==
Subject: Re: [PATCH] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191102002420.4091061-1-bjorn.andersson@linaro.org>
 <f1e89dcc-4d5f-cc1f-8036-dcb062645cb0@mm-sol.com>
 <20191106202351.GE36595@minitux>
From:   Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <87b791db-6e03-b1ab-934c-068521652117@mm-sol.com>
Date:   Thu, 7 Nov 2019 11:32:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191106202351.GE36595@minitux>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bjorn,

On 11/6/19 10:23 PM, Bjorn Andersson wrote:
> On Mon 04 Nov 05:00 PST 2019, Stanimir Varbanov wrote:
> 
>> Hi Bjorn,
>>
>> Thanks for the fix!
>>
>> On 11/2/19 2:24 AM, Bjorn Andersson wrote:
>>> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
>>> the fixup to only affect the PCIe 2.0 (0x106) and PCIe 3.0 (0x107)
>>> bridges.
>>
>> Are you sure that this will not break ops_1_0_0 (Qcom IP rev.: 1.0.0
>> Synopsys IP rev.: 4.11a) i.e. apq8084 ?

OK, I've checked DEVICE IDs for all supported SoCs in pcie-qcom driver:

apq8084 0x101
ipq8064 0x101
apq8064 0x101
msm8996 0x104
ipq8074 0x302
ipq4019 0x1001
qcs404  ??? (can you check for this SoC)

As you can see they are various, so I don't think we have to expose them
in pci_ids.h. See my proposal below.

Of course the last word will be from PCI maintainers.

>>
> 
> I am not, I've only tested this on db820c and db845c. Unfortunately I'm
> unable to find a branch with the necessary dts snippets to test it. Do
> you perhaps have a branch somewhere?
> 
> Regards,
> Bjorn
> 
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>>> ---
>>>  drivers/pci/controller/dwc/pcie-qcom.c | 3 ++-
>>>  include/linux/pci_ids.h                | 2 ++
>>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
>>> index 35f4980480bb..b91abf4d4905 100644
>>> --- a/drivers/pci/controller/dwc/pcie-qcom.c
>>> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
>>> @@ -1441,7 +1441,8 @@ static void qcom_fixup_class(struct pci_dev *dev)
>>>  {
>>>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
>>>  }
>>> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE20, qcom_fixup_class);
>>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE30, qcom_fixup_class);

DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0101, qcom_fixup_class);
DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0104, qcom_fixup_class);
DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0106, qcom_fixup_class);
DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0107, qcom_fixup_class);
DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x0302, qcom_fixup_class);
DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, 0x1001, qcom_fixup_class);

>>>  
>>>  static struct platform_driver qcom_pcie_driver = {
>>>  	.probe = qcom_pcie_probe,
>>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>>> index 21a572469a4e..3d0724ee4d2f 100644
>>> --- a/include/linux/pci_ids.h
>>> +++ b/include/linux/pci_ids.h
>>> @@ -2413,6 +2413,8 @@
>>>  #define PCI_VENDOR_ID_LENOVO		0x17aa
>>>  
>>>  #define PCI_VENDOR_ID_QCOM		0x17cb
>>> +#define PCIE_DEVICE_ID_QCOM_PCIE20	0x0106
>>> +#define PCIE_DEVICE_ID_QCOM_PCIE30	0x0107

... and drop these additions.

>>>  
>>>  #define PCI_VENDOR_ID_CDNS		0x17cd
>>>  
>>>
>>
>> -- 
>> regards,
>> Stan

-- 
regards,
Stan
