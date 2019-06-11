Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00653D0BF
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 17:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404914AbfFKPZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 11:25:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:32063 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404926AbfFKPZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 11:25:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 08:25:51 -0700
X-ExtLoop1: 1
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.140.156]) ([10.249.140.156])
  by orsmga006.jf.intel.com with ESMTP; 11 Jun 2019 08:25:49 -0700
Subject: Re: [PATCH AUTOSEL 4.14 15/31] PCI: PM: Avoid possible
 suspend-to-idle issue
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Keith Busch <keith.busch@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-pci@vger.kernel.org
References: <20190608114646.9415-1-sashal@kernel.org>
 <20190608114646.9415-15-sashal@kernel.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <7003865c-8689-78f2-d441-f2a223fb3122@intel.com>
Date:   Tue, 11 Jun 2019 17:25:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190608114646.9415-15-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/2019 1:46 PM, Sasha Levin wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>
> [ Upstream commit d491f2b75237ef37d8867830ab7fad8d9659e853 ]
>
> If a PCI driver leaves the device handled by it in D0 and calls
> pci_save_state() on the device in its ->suspend() or ->suspend_late()
> callback, it can expect the device to stay in D0 over the whole
> s2idle cycle.  However, that may not be the case if there is a
> spurious wakeup while the system is suspended, because in that case
> pci_pm_suspend_noirq() will run again after pci_pm_resume_noirq()
> which calls pci_restore_state(), via pci_pm_default_resume_early(),
> so state_saved is cleared and the second iteration of
> pci_pm_suspend_noirq() will invoke pci_prepare_to_sleep() which
> may change the power state of the device.
>
> To avoid that, add a new internal flag, skip_bus_pm, that will be set
> by pci_pm_suspend_noirq() when it runs for the first time during the
> given system suspend-resume cycle if the state of the device has
> been saved already and the device is still in D0.  Setting that flag
> will cause the next iterations of pci_pm_suspend_noirq() to set
> state_saved for pci_pm_resume_noirq(), so that it always restores the
> device state from the originally saved data, and avoid calling
> pci_prepare_to_sleep() for the device.
>
> Fixes: 33e4f80ee69b ("ACPI / PM: Ignore spurious SCI wakeups from suspend-to-idle")
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Keith Busch <keith.busch@intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/pci/pci-driver.c | 17 ++++++++++++++++-
>   include/linux/pci.h      |  1 +
>   2 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index ea69b4dbab66..f5d66335fe53 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -726,6 +726,8 @@ static int pci_pm_suspend(struct device *dev)
>   	struct pci_dev *pci_dev = to_pci_dev(dev);
>   	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>   
> +	pci_dev->skip_bus_pm = false;
> +
>   	if (pci_has_legacy_pm_support(pci_dev))
>   		return pci_legacy_suspend(dev, PMSG_SUSPEND);
>   
> @@ -799,7 +801,20 @@ static int pci_pm_suspend_noirq(struct device *dev)
>   		}
>   	}
>   
> -	if (!pci_dev->state_saved) {
> +	if (pci_dev->skip_bus_pm) {
> +		/*
> +		 * The function is running for the second time in a row without
> +		 * going through full resume, which is possible only during
> +		 * suspend-to-idle in a spurious wakeup case.  Moreover, the
> +		 * device was originally left in D0, so its power state should
> +		 * not be changed here and the device register values saved
> +		 * originally should be restored on resume again.
> +		 */
> +		pci_dev->state_saved = true;
> +	} else if (pci_dev->state_saved) {
> +		if (pci_dev->current_state == PCI_D0)
> +			pci_dev->skip_bus_pm = true;
> +	} else {
>   		pci_save_state(pci_dev);
>   		if (pci_power_manageable(pci_dev))
>   			pci_prepare_to_sleep(pci_dev);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 59f4d10568c6..430f3c335446 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -346,6 +346,7 @@ struct pci_dev {
>   						   D3cold, not set for devices
>   						   powered on/off by the
>   						   corresponding bridge */
> +	unsigned int	skip_bus_pm:1;	/* Internal: Skip bus-level PM */
>   	unsigned int	ignore_hotplug:1;	/* Ignore hotplug events */
>   	unsigned int	hotplug_user_indicators:1; /* SlotCtl indicators
>   						      controlled exclusively by

This has been reported to be problematic, I wouldn't recommend taking it 
for -stable at this point.


