Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A55496D5D
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 19:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiAVSjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 13:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiAVSjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 13:39:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67542C06173B;
        Sat, 22 Jan 2022 10:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7578CE09B3;
        Sat, 22 Jan 2022 18:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CAFC004E1;
        Sat, 22 Jan 2022 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642876790;
        bh=BuT77Y8nlmSLNOc+GuY9E3je1e3ZPGvy3NbpmZnE6Cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BILdSYH91XOVL1m0PmyETZECaHFY8aQIYBcNiO8pnQNyc89xZOPgL+QARz3YExDLR
         hLPP9MzTjjiilTDbeKuvWDIOND1zL8PKgO889WO+KiFS0F4fLyhO3Qes1S4mh4oOeB
         4l2WPLNUJBMj09djN2XlLgU/6Qsbag6P83tVEZg2DC1OinEI6FGKHmxqHI2yfkzZsc
         S6FTu26duCmmK1DVhU8fYhI2fzqRSrU6syE0YGDaEbWjcAFKRHicVW/2c1I0N1VTWC
         wgQg5M+0oq1WQCnfbznnQG0/+itqDIIKV2a96MQUyJ4vjB5/v4v2AlTsBZU/TGtaeL
         K95+ZJadAcDyA==
Date:   Sat, 22 Jan 2022 13:39:46 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Nishanth Menon <nm@ti.com>,
        Michael Kelley <mikelley@microsoft.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 36/52] PCI/MSI: Decouple MSI[-X] disable
 from pcim_release()
Message-ID: <YexPchGmB/WGQrOE@sashalap>
References: <20220117165853.1470420-1-sashal@kernel.org>
 <20220117165853.1470420-36-sashal@kernel.org>
 <YeWikhpdcmenkMub@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YeWikhpdcmenkMub@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 06:08:34PM +0100, Greg Kroah-Hartman wrote:
>On Mon, Jan 17, 2022 at 11:58:37AM -0500, Sasha Levin wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> [ Upstream commit 3f35d2cf9fbc656db82579d849cc69c373b1ad0d ]
>>
>> The MSI core will introduce runtime allocation of MSI related data. This
>> data will be devres managed and has to be set up before enabling
>> PCI/MSI[-X]. This would introduce an ordering issue vs. pcim_release().
>>
>> The setup order is:
>>
>>    pcim_enable_device()
>> 	devres_alloc(pcim_release...);
>> 	...
>> 	pci_irq_alloc()
>> 	  msi_setup_device_data()
>> 	     devres_alloc(msi_device_data_release, ...)
>>
>> and once the device is released these release functions are invoked in the
>> opposite order:
>>
>>     msi_device_data_release()
>>     ...
>>     pcim_release()
>>        pci_disable_msi[x]()
>>
>> which is obviously wrong, because pci_disable_msi[x]() requires the MSI
>> data to be available to tear down the MSI[-X] interrupts.
>>
>> Remove the MSI[-X] teardown from pcim_release() and add an explicit action
>> to be installed on the attempt of enabling PCI/MSI[-X].
>>
>> This allows the MSI core data allocation to be ordered correctly in a
>> subsequent step.
>>
>> Reported-by: Nishanth Menon <nm@ti.com>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Tested-by: Michael Kelley <mikelley@microsoft.com>
>> Tested-by: Nishanth Menon <nm@ti.com>
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Link: https://lore.kernel.org/r/87tuf9rdoj.ffs@tglx
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/pci/msi.c   | 33 +++++++++++++++++++++++++++++++++
>>  drivers/pci/pci.c   |  5 -----
>>  include/linux/pci.h |  3 ++-
>>  3 files changed, 35 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index d84cf30bb2790..1093f099846eb 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -461,6 +461,31 @@ void pci_restore_msi_state(struct pci_dev *dev)
>>  }
>>  EXPORT_SYMBOL_GPL(pci_restore_msi_state);
>>
>> +static void pcim_msi_release(void *pcidev)
>> +{
>> +	struct pci_dev *dev = pcidev;
>> +
>> +	dev->is_msi_managed = false;
>> +	pci_free_irq_vectors(dev);
>> +}
>> +
>> +/*
>> + * Needs to be separate from pcim_release to prevent an ordering problem
>> + * vs. msi_device_data_release() in the MSI core code.
>> + */
>> +static int pcim_setup_msi_release(struct pci_dev *dev)
>> +{
>> +	int ret;
>> +
>> +	if (!pci_is_managed(dev) || dev->is_msi_managed)
>> +		return 0;
>> +
>> +	ret = devm_add_action(&dev->dev, pcim_msi_release, dev);
>> +	if (!ret)
>> +		dev->is_msi_managed = true;
>> +	return ret;
>> +}
>> +
>>  static struct msi_desc *
>>  msi_setup_entry(struct pci_dev *dev, int nvec, struct irq_affinity *affd)
>>  {
>> @@ -1029,6 +1054,10 @@ static int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec,
>>  	if (nvec > maxvec)
>>  		nvec = maxvec;
>>
>> +	rc = pcim_setup_msi_release(dev);
>> +	if (rc)
>> +		return rc;
>> +
>>  	for (;;) {
>>  		if (affd) {
>>  			nvec = irq_calc_affinity_vectors(minvec, nvec, affd);
>> @@ -1072,6 +1101,10 @@ static int __pci_enable_msix_range(struct pci_dev *dev,
>>  	if (WARN_ON_ONCE(dev->msix_enabled))
>>  		return -EINVAL;
>>
>> +	rc = pcim_setup_msi_release(dev);
>> +	if (rc)
>> +		return rc;
>> +
>>  	for (;;) {
>>  		if (affd) {
>>  			nvec = irq_calc_affinity_vectors(minvec, nvec, affd);
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 3d2fb394986a4..f3f606c232a8a 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -2024,11 +2024,6 @@ static void pcim_release(struct device *gendev, void *res)
>>  	struct pci_devres *this = res;
>>  	int i;
>>
>> -	if (dev->msi_enabled)
>> -		pci_disable_msi(dev);
>> -	if (dev->msix_enabled)
>> -		pci_disable_msix(dev);
>> -
>>  	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
>>  		if (this->region_mask & (1 << i))
>>  			pci_release_region(dev, i);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 18a75c8e615cd..e26000404e3c3 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -425,7 +425,8 @@ struct pci_dev {
>>  	unsigned int	ats_enabled:1;		/* Address Translation Svc */
>>  	unsigned int	pasid_enabled:1;	/* Process Address Space ID */
>>  	unsigned int	pri_enabled:1;		/* Page Request Interface */
>> -	unsigned int	is_managed:1;
>> +	unsigned int	is_managed:1;		/* Managed via devres */
>> +	unsigned int	is_msi_managed:1;	/* MSI release via devres installed */
>>  	unsigned int	needs_freset:1;		/* Requires fundamental reset */
>>  	unsigned int	state_saved:1;
>>  	unsigned int	is_physfn:1;
>> --
>> 2.34.1
>>
>
>I do not think this is needed for the stable trees, as it only showed up
>in the MSI rework that Thomas added for 5.17-rc1.  So please drop this
>from all of the AUTOSEL kernels.

Dropped, thanks!

-- 
Thanks,
Sasha
