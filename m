Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C2148B302
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 18:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbiAKROx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 12:14:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiAKROv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 12:14:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB7BB81C29;
        Tue, 11 Jan 2022 17:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B15C36AEB;
        Tue, 11 Jan 2022 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641921288;
        bh=C8FF6MNv73/KekWgaN6QY/oW8qujrDQNHNGYROu0o8c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=L0wnIqszsycAa2VvE0G8W7bHMjZXsVu95tc8lbGg2F18okzq7M+y1B7gyGWqUAXxN
         fbUaXqJ//e35disB3+3rW2YnqC02t1Xl9O1taQxaa7iH/wH83Wqkg5LwZYiau2MFaZ
         gY7DzD4OsEt2H3OhTc/9DkevFX731JNvcFHz50D6nroWML8fD0feLdzLRuPd7DIyOF
         8kW1c/SV7utr1FmW4VoCCSEJ31py9yG000c3+gZFZpI4VrC2HnVEaiGy8fsZDZnFVU
         cce3Y4FExJ20ke4kEEYKpH41FP2lAg9ZH9lXg1by0TVsD1nSS0r9iaCA+I59qAf+UM
         qTxguba6o4/HA==
Date:   Tue, 11 Jan 2022 11:14:47 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH resend v2] PCI: pciehp: Use
 down_read/write_nested(reset_lock) to fix lockdep errors
Message-ID: <20220111171447.GA152379@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217141709.379663-1-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 03:17:09PM +0100, Hans de Goede wrote:
> Use down_read_nested() and down_write_nested() when taking the
> ctrl->reset_lock rw-sem, passing the number of PCIe hotplug controllers in
> the path to the PCI root bus as lock subclass parameter. This fixes the
> following false-positive lockdep report when unplugging a Lenovo X1C8 from
> a Lenovo 2nd gen TB3 dock:
> 
> [   28.583853] pcieport 0000:06:01.0: pciehp: Slot(1): Link Down
> [   28.583891] pcieport 0000:06:01.0: pciehp: Slot(1): Card not present
> [   28.584849] ============================================
> [   28.584854] WARNING: possible recursive locking detected
> [   28.584858] 5.16.0-rc2+ #621 Not tainted
> [   28.584864] --------------------------------------------
> [   28.584867] irq/124-pciehp/86 is trying to acquire lock:
> [   28.584873] ffff8e5ac4299ef8 (&ctrl->reset_lock){.+.+}-{3:3}, at: pciehp_check_presence+0x23/0x80
> [   28.584904]
>                but task is already holding lock:
> [   28.584908] ffff8e5ac4298af8 (&ctrl->reset_lock){.+.+}-{3:3}, at: pciehp_ist+0xf3/0x180
> [   28.584929]
>                other info that might help us debug this:
> [   28.584933]  Possible unsafe locking scenario:
> 
> [   28.584936]        CPU0
> [   28.584939]        ----
> [   28.584942]   lock(&ctrl->reset_lock);
> [   28.584949]   lock(&ctrl->reset_lock);
> [   28.584955]
>                 *** DEADLOCK ***
> 
> [   28.584959]  May be due to missing lock nesting notation
> 
> [   28.584963] 3 locks held by irq/124-pciehp/86:
> [   28.584970]  #0: ffff8e5ac4298af8 (&ctrl->reset_lock){.+.+}-{3:3}, at: pciehp_ist+0xf3/0x180
> [   28.584991]  #1: ffffffffa3b024e8 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pciehp_unconfigure_device+0x31/0x110
> [   28.585012]  #2: ffff8e5ac1ee2248 (&dev->mutex){....}-{3:3}, at: device_release_driver+0x1c/0x40
> [   28.585037]
>                stack backtrace:
> [   28.585042] CPU: 4 PID: 86 Comm: irq/124-pciehp Not tainted 5.16.0-rc2+ #621
> [   28.585052] Hardware name: LENOVO 20U90SIT19/20U90SIT19, BIOS N2WET30W (1.20 ) 08/26/2021
> [   28.585059] Call Trace:
> [   28.585064]  <TASK>
> [   28.585073]  dump_stack_lvl+0x59/0x73
> [   28.585087]  __lock_acquire.cold+0xc5/0x2c6
> [   28.585106]  ? find_held_lock+0x2b/0x80
> [   28.585124]  lock_acquire+0xb5/0x2b0
> [   28.585132]  ? pciehp_check_presence+0x23/0x80
> [   28.585144]  ? lock_is_held_type+0xa8/0x120
> [   28.585161]  down_read+0x3e/0x50
> [   28.585172]  ? pciehp_check_presence+0x23/0x80
> [   28.585183]  pciehp_check_presence+0x23/0x80
> [   28.585194]  pciehp_runtime_resume+0x5c/0xa0
> [   28.585206]  ? pci_msix_init+0x60/0x60
> [   28.585214]  device_for_each_child+0x45/0x70
> [   28.585227]  pcie_port_device_runtime_resume+0x20/0x30
> [   28.585236]  pci_pm_runtime_resume+0xa7/0xc0
> [   28.585246]  ? pci_pm_freeze_noirq+0x100/0x100
> [   28.585257]  __rpm_callback+0x41/0x110
> [   28.585271]  ? pci_pm_freeze_noirq+0x100/0x100
> [   28.585281]  rpm_callback+0x59/0x70
> [   28.585293]  rpm_resume+0x512/0x7b0
> [   28.585309]  __pm_runtime_resume+0x4a/0x90
> [   28.585322]  __device_release_driver+0x28/0x240
> [   28.585338]  device_release_driver+0x26/0x40
> [   28.585351]  pci_stop_bus_device+0x68/0x90
> [   28.585363]  pci_stop_bus_device+0x2c/0x90
> [   28.585373]  pci_stop_and_remove_bus_device+0xe/0x20
> [   28.585384]  pciehp_unconfigure_device+0x6c/0x110
> [   28.585396]  ? __pm_runtime_resume+0x58/0x90
> [   28.585409]  pciehp_disable_slot+0x5b/0xe0
> [   28.585421]  pciehp_handle_presence_or_link_change+0xc3/0x2f0
> [   28.585436]  pciehp_ist+0x179/0x180
> [   28.585449]  ? disable_irq_nosync+0x10/0x10
> [   28.585460]  irq_thread_fn+0x1d/0x60
> [   28.585470]  ? irq_thread+0x81/0x1a0
> [   28.585480]  irq_thread+0xcb/0x1a0
> [   28.585491]  ? irq_thread_fn+0x60/0x60
> [   28.585502]  ? irq_thread_check_affinity+0xb0/0xb0
> [   28.585514]  kthread+0x165/0x190
> [   28.585522]  ? set_kthread_struct+0x40/0x40
> [   28.585531]  ret_from_fork+0x1f/0x30
> [   28.585554]  </TASK>
> 
> This lockdep warning is triggered because with Thunderbolt, hotplug ports
> are nested. When removing multiple devices in a daisy-chain, each hotplug
> port's reset_lock may be acquired recursively. It's never the same lock,
> so the lockdep splat is a false positive.
> 
> Because locks at the same hierarchy level are never acquired recursively,
> a per-level lockdep class is sufficient to fix the lockdep warning.
> 
> The choice to use one lockdep subclass per pcie-hotplug controller in
> the path to the root-bus was made to conserve class keys because their
> number is limited and the complexity grows quadratically with number of
> keys according to Documentation/locking/lockdep-design.rst.
> 
> Link: https://lore.kernel.org/linux-pci/20190402021933.GA2966@mit.edu/
> Link: https://lore.kernel.org/linux-pci/de684a28-9038-8fc6-27ca-3f6f2f6400d7@redhat.com/
> Cc: stable@vger.kernel.org
> Reported-by: "Theodore Ts'o" <tytso@mit.edu>
> Reviewed-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Applied to pci/hotplug for v5.17, thanks, Hans!

> ---
> Changes in v2:
> - Only use a subclass for each hotplug capable port/parent in the path to
>   the PCI root bus, instead of one for each level in the PCI hierarchy,
>   to avoid hitting MAX_LOCKDEP_SUBCLASSES
> - Drop the "PCI: Add a pci_dev_depth() helper function" since we now need
>   a special version of this to only count hotplug ports
> - Various commit message improvements
> ---
>  drivers/pci/hotplug/pciehp.h      |  3 +++
>  drivers/pci/hotplug/pciehp_core.c |  2 +-
>  drivers/pci/hotplug/pciehp_hpc.c  | 21 ++++++++++++++++++---
>  3 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index 918dccbc74b6..e0a614acee05 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -75,6 +75,8 @@ extern int pciehp_poll_time;
>   * @reset_lock: prevents access to the Data Link Layer Link Active bit in the
>   *	Link Status register and to the Presence Detect State bit in the Slot
>   *	Status register during a slot reset which may cause them to flap
> + * @depth: Number of additional hotplug ports in the path to the root bus,
> + *	used as lock subclass for @reset_lock
>   * @ist_running: flag to keep user request waiting while IRQ thread is running
>   * @request_result: result of last user request submitted to the IRQ thread
>   * @requester: wait queue to wake up on completion of user request,
> @@ -106,6 +108,7 @@ struct controller {
>  
>  	struct hotplug_slot hotplug_slot;	/* hotplug core interface */
>  	struct rw_semaphore reset_lock;
> +	unsigned int depth;
>  	unsigned int ist_running;
>  	int request_result;
>  	wait_queue_head_t requester;
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index f34114d45259..4042d87d539d 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -166,7 +166,7 @@ static void pciehp_check_presence(struct controller *ctrl)
>  {
>  	int occupied;
>  
> -	down_read(&ctrl->reset_lock);
> +	down_read_nested(&ctrl->reset_lock, ctrl->depth);
>  	mutex_lock(&ctrl->state_lock);
>  
>  	occupied = pciehp_card_present_or_link_active(ctrl);
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index 83a0fa119cae..963fb50528da 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -583,7 +583,7 @@ static void pciehp_ignore_dpc_link_change(struct controller *ctrl,
>  	 * the corresponding link change may have been ignored above.
>  	 * Synthesize it to ensure that it is acted on.
>  	 */
> -	down_read(&ctrl->reset_lock);
> +	down_read_nested(&ctrl->reset_lock, ctrl->depth);
>  	if (!pciehp_check_link_active(ctrl))
>  		pciehp_request(ctrl, PCI_EXP_SLTSTA_DLLSC);
>  	up_read(&ctrl->reset_lock);
> @@ -746,7 +746,7 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
>  	 * Disable requests have higher priority than Presence Detect Changed
>  	 * or Data Link Layer State Changed events.
>  	 */
> -	down_read(&ctrl->reset_lock);
> +	down_read_nested(&ctrl->reset_lock, ctrl->depth);
>  	if (events & DISABLE_SLOT)
>  		pciehp_handle_disable_request(ctrl);
>  	else if (events & (PCI_EXP_SLTSTA_PDC | PCI_EXP_SLTSTA_DLLSC))
> @@ -906,7 +906,7 @@ int pciehp_reset_slot(struct hotplug_slot *hotplug_slot, bool probe)
>  	if (probe)
>  		return 0;
>  
> -	down_write(&ctrl->reset_lock);
> +	down_write_nested(&ctrl->reset_lock, ctrl->depth);
>  
>  	if (!ATTN_BUTTN(ctrl)) {
>  		ctrl_mask |= PCI_EXP_SLTCTL_PDCE;
> @@ -962,6 +962,20 @@ static inline void dbg_ctrl(struct controller *ctrl)
>  
>  #define FLAG(x, y)	(((x) & (y)) ? '+' : '-')
>  
> +static inline int pcie_hotplug_depth(struct pci_dev *dev)
> +{
> +	struct pci_bus *bus = dev->bus;
> +	int depth = 0;
> +
> +	while (bus->parent) {
> +		bus = bus->parent;
> +		if (bus->self && bus->self->is_hotplug_bridge)
> +			depth++;
> +	}
> +
> +	return depth;
> +}
> +
>  struct controller *pcie_init(struct pcie_device *dev)
>  {
>  	struct controller *ctrl;
> @@ -975,6 +989,7 @@ struct controller *pcie_init(struct pcie_device *dev)
>  		return NULL;
>  
>  	ctrl->pcie = dev;
> +	ctrl->depth = pcie_hotplug_depth(dev->port);
>  	pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &slot_cap);
>  
>  	if (pdev->hotplug_user_indicators)
> -- 
> 2.33.1
> 
