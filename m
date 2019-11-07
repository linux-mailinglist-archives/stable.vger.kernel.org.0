Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8848F2BEC
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 11:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733238AbfKGKPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 05:15:30 -0500
Received: from ns.iliad.fr ([212.27.33.1]:37428 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733142AbfKGKPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 05:15:30 -0500
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 3AA3C2022D;
        Thu,  7 Nov 2019 11:15:27 +0100 (CET)
Received: from [192.168.108.51] (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 1ADA120189;
        Thu,  7 Nov 2019 11:15:27 +0100 (CET)
Subject: Re: [PATCH] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        MSM <linux-arm-msm@vger.kernel.org>,
        PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
References: <20191102002420.4091061-1-bjorn.andersson@linaro.org>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
Message-ID: <8f15abf9-80bc-9767-e61c-6e0455effbf0@free.fr>
Date:   Thu, 7 Nov 2019 11:15:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191102002420.4091061-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Thu Nov  7 11:15:27 2019 +0100 (CET)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/11/2019 01:24, Bjorn Andersson wrote:

> There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
> the fixup to only affect the PCIe 2.0 (0x106) and PCIe 3.0 (0x107)
> bridges.

Hey, git blames me! Why didn't you CC me? :-)

Commit 322f03436692481993d389f539c016d20bb0fa1d
PCI: qcom: Use default config space read function

The patch's history is of interest:
https://lkml.org/lkml/2019/3/11/614
https://www.spinics.net/lists/linux-arm-msm/msg49090.html

> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 3 ++-
>  include/linux/pci_ids.h                | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 35f4980480bb..b91abf4d4905 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -1441,7 +1441,8 @@ static void qcom_fixup_class(struct pci_dev *dev)
>  {
>  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
>  }
> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE20, qcom_fixup_class);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE30, qcom_fixup_class);
>  
>  static struct platform_driver qcom_pcie_driver = {
>  	.probe = qcom_pcie_probe,
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 21a572469a4e..3d0724ee4d2f 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2413,6 +2413,8 @@
>  #define PCI_VENDOR_ID_LENOVO		0x17aa
>  
>  #define PCI_VENDOR_ID_QCOM		0x17cb
> +#define PCIE_DEVICE_ID_QCOM_PCIE20	0x0106
> +#define PCIE_DEVICE_ID_QCOM_PCIE30	0x0107

I don't think the fixup is required for 0x106 and 0x107...

In v1, I wrote:
FWIW, this quirk is no longer required on recent chips:
msm8996 (tested by Stanimir), msm8998 (tested by me), sdm845 (untested) are unaffected
apq/ipq8064 is affected => what is the device ID for these chips?
others?

IIRC, 0x0101 requires the fixup because
dw_pcie_wr_own_conf(pp, PCI_CLASS_DEVICE, 2, PCI_CLASS_BRIDGE_PCI);
is broken on that platform (grrr, HW devs)
(See my v3, tested by Srinivas)

Stan wrote:

Yes it is good but to avoid breaking another SoCs could you add fixups
for the following SoCs:

SoC		device ID
ipq4019 	0x1001
ipq8064		0x101
ipq8074		0x108

ipq8064 has the same device ID as apq8064, but I'm not sure do we need
defines per SoC or just rename DEV_ID_8064 ? I'm fine with both ways.


In conclusion, my analysis in v5 was wrong
"Changes from v4 to v5: Apply fixup to all qcom chips, the same way it was before
(thus the code remains functionally equivalent)"
=> The fixup was applied *more widely* than before, so not functionally equivalent.

Regards.
