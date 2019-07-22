Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4D76F6CD
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 02:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfGVAkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 20:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVAkz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 20:40:55 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82EA0206BF;
        Mon, 22 Jul 2019 00:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563756054;
        bh=KHFAVDQTHGzw2Ct6ufGOLuan923qz4afL8qI13NMWpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z8YS4lPfN+19t/r2Z7TOa4ZDa2SHUEO0bkVyRWJeulhLZRqhg13QtqPc8x8ZMkSQq
         7ZWv6fTss358QAUBFkGclinbsMBi4jq+TXCU8c0/iCyIQrhPaspDB5TgDdtZf47al3
         vLG6zPfWvmxDfiH+FCBawLBY+W+JT6e80NmO+c/w=
Date:   Sun, 21 Jul 2019 20:40:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 086/105] PCI / ACPI: Use cached ACPI device
 state to get PCI device power state
Message-ID: <20190722004054.GF1607@sasha-vm>
References: <20190715142839.9896-1-sashal@kernel.org>
 <20190715142839.9896-86-sashal@kernel.org>
 <01d729e3-9778-9e4f-84d2-16b7353eeee1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <01d729e3-9778-9e4f-84d2-16b7353eeee1@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 11:22:44AM +0200, Rafael J. Wysocki wrote:
>On 7/15/2019 4:28 PM, Sasha Levin wrote:
>>From: Mika Westerberg <mika.westerberg@linux.intel.com>
>>
>>[ Upstream commit 83a16e3f6d70da99896c7a2639c0b60fff13afb8 ]
>>
>>The ACPI power state returned by acpi_device_get_power() may depend on
>>the configuration of ACPI power resources in the system which may change
>>any time after acpi_device_get_power() has returned, unless the
>>reference counters of the ACPI power resources in question are set to
>>prevent that from happening. Thus it is invalid to use acpi_device_get_power()
>>in acpi_pci_get_power_state() the way it is done now and the value of
>>the ->power.state field in the corresponding struct acpi_device objects
>>(which reflects the ACPI power resources reference counting, among other
>>things) should be used instead.
>>
>>As an example where this becomes an issue is Intel Ice Lake where the
>>Thunderbolt controller (NHI), two PCIe root ports (RP0 and RP1) and xHCI
>>all share the same power resources. The following picture with power
>>resources marked with [] shows the topology:
>>
>>   Host bridge
>>     |
>>     +- RP0 ---\
>>     +- RP1 ---|--+--> [TBT]
>>     +- NHI --/   |
>>     |            |
>>     |            v
>>     +- xHCI --> [D3C]
>>
>>Here TBT and D3C are the shared ACPI power resources. ACPI _PR3() method
>>of the devices in question returns either TBT or D3C or both.
>>
>>Say we runtime suspend first the root ports RP0 and RP1, then NHI. Now
>>since the TBT power resource is still on when the root ports are runtime
>>suspended their dev->current_state is set to D3hot. When NHI is runtime
>>suspended TBT is finally turned off but state of the root ports remain
>>to be D3hot. Now when the xHCI is runtime suspended D3C gets also turned
>>off. PCI core thus has power states of these devices cached in their
>>dev->current_state as follows:
>>
>>   RP0 -> D3hot
>>   RP1 -> D3hot
>>   NHI -> D3cold
>>   xHCI -> D3cold
>>
>>If the user now runs lspci for instance, the result is all 1's like in
>>the below output (00:07.0 is the first root port, RP0):
>>
>>00:07.0 PCI bridge: Intel Corporation Device 8a1d (rev ff) (prog-if ff)
>>     !!! Unknown header type 7f
>>     Kernel driver in use: pcieport
>>
>>In short the hardware state is not in sync with the software state
>>anymore. The exact same thing happens with the PME polling thread which
>>ends up bringing the root ports back into D0 after they are runtime
>>suspended.
>>
>>For this reason, modify acpi_pci_get_power_state() so that it uses the
>>ACPI device power state that was cached by the ACPI core. This makes the
>>PCI device power state match the ACPI device power state regardless of
>>state of the shared power resources which may still be on at this point.
>>
>>Link: https://lore.kernel.org/r/20190618161858.77834-2-mika.westerberg@linux.intel.com
>>Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  drivers/pci/pci-acpi.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>>diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
>>index a3cedf8de863..688e195e85b4 100644
>>--- a/drivers/pci/pci-acpi.c
>>+++ b/drivers/pci/pci-acpi.c
>>@@ -563,7 +563,8 @@ static pci_power_t acpi_pci_get_power_state(struct pci_dev *dev)
>>  	if (!adev || !acpi_device_power_manageable(adev))
>>  		return PCI_UNKNOWN;
>>-	if (acpi_device_get_power(adev, &state) || state == ACPI_STATE_UNKNOWN)
>>+	state = adev->power.state;
>>+	if (state == ACPI_STATE_UNKNOWN)
>>  		return PCI_UNKNOWN;
>>  	return state_conv[state];
>
>This requires additional changes to really work in all cases, please 
>do not include it alone into -stable.

I've dropped it, thanks!

--
Thanks,
Sasha
