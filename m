Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670454D89D0
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 17:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiCNQmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 12:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243880AbiCNQi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 12:38:26 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D3F31EEFE;
        Mon, 14 Mar 2022 09:37:00 -0700 (PDT)
Received: from jpiotrowski-Surface-Book-3 (ip-037-201-215-233.um10.pools.vodafone-ip.de [37.201.215.233])
        by linux.microsoft.com (Postfix) with ESMTPSA id E9FF5205836A;
        Mon, 14 Mar 2022 09:36:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E9FF5205836A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1647275819;
        bh=TANwhXsmvSoowjz9fhb6c0Fd/b7jlbQ0LayQhJAe704=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sevBVUwN9Njy9W0lVbgHuO2iFIH/DCQJx1beCuQ7p+2YNcsvNvvz46MV/SD+9K7pn
         Z9Ri9xz0mGzKuEhEq6Ckh1+omZu0Xfe8RyB6C2LP3PC5S4UUksvWV9rruh2E6+R1ai
         I3A+Nq17RUIJ/6JsU/zMDjZyGn4bssEvg0s1egxE=
Date:   Mon, 14 Mar 2022 17:36:47 +0100
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Stefan Roese <sr@denx.de>, Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Marek Vasut <marex@denx.de>, stable@vger.kernel.org,
        x86@kernel.org, maz@kernel.org
Subject: Re: [tip: irq/urgent] PCI/MSI: Mask MSI-X vectors only on success
Message-ID: <Yi9vH2F2OBDprwd8@jpiotrowski-Surface-Book-3>
References: <20211210161025.3287927-1-sr@denx.de>
 <163948488617.23020.3934435568065766936.tip-bot2@tip-bot2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <163948488617.23020.3934435568065766936.tip-bot2@tip-bot2>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas, Hi Stefan,

On Tue, Dec 14, 2021 at 12:28:06PM -0000, tip-bot2 for Stefan Roese wrote:
> The following commit has been merged into the irq/urgent branch of tip:
> 
> Commit-ID:     83dbf898a2d45289be875deb580e93050ba67529
> Gitweb:        https://git.kernel.org/tip/83dbf898a2d45289be875deb580e93050ba67529
> Author:        Stefan Roese <sr@denx.de>
> AuthorDate:    Tue, 14 Dec 2021 12:49:32 +01:00
> Committer:     Thomas Gleixner <tglx@linutronix.de>
> CommitterDate: Tue, 14 Dec 2021 13:23:32 +01:00
> 
> PCI/MSI: Mask MSI-X vectors only on success
> 
> Masking all unused MSI-X entries is done to ensure that a crash kernel
> starts from a clean slate, which correponds to the reset state of the
> device as defined in the PCI-E specificion 3.0 and later:
> 
>  Vector Control for MSI-X Table Entries
>  --------------------------------------
> 
>  "00: Mask bit:  When this bit is set, the function is prohibited from
>                  sending a message using this MSI-X Table entry.
>                  ...
>                  This bit’s state after reset is 1 (entry is masked)."
> 
> A Marvell NVME device fails to deliver MSI interrupts after trying to
> enable MSI-X interrupts due to that masking. It seems to take the MSI-X
> mask bits into account even when MSI-X is disabled.
> 
> While not specification compliant, this can be cured by moving the masking
> into the success path, so that the MSI-X table entries stay in device reset
> state when the MSI-X setup fails.
> 
> [ tglx: Move it into the success path, add comment and amend changelog ]
> 
> Fixes: aa8092c1d1f1 ("PCI/MSI: Mask all unused MSI-X entries")                                                                                                                                                                                                                 
> Signed-off-by: Stefan Roese <sr@denx.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-pci@vger.kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Michal Simek <michal.simek@xilinx.com>
> Cc: Marek Vasut <marex@denx.de>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20211210161025.3287927-1-sr@denx.de
> ---
>  drivers/pci/msi.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 48e3f4e..6748cf9 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -722,9 +722,6 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
>  		goto out_disable;
>  	}
>  
> -	/* Ensure that all table entries are masked. */
> -	msix_mask_all(base, tsize);
> -
>  	ret = msix_setup_entries(dev, base, entries, nvec, affd);
>  	if (ret)
>  		goto out_disable;
> @@ -751,6 +748,16 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
>  	/* Set MSI-X enabled bits and unmask the function */
>  	pci_intx_for_msi(dev, 0);
>  	dev->msix_enabled = 1;
> +
> +	/*
> +	 * Ensure that all table entries are masked to prevent
> +	 * stale entries from firing in a crash kernel.
> +	 *
> +	 * Done late to deal with a broken Marvell NVME device
> +	 * which takes the MSI-X mask bits into account even
> +	 * when MSI-X is disabled, which prevents MSI delivery.
> +	 */
> +	msix_mask_all(base, tsize);
>  	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
>  
>  	pcibios_free_irq(dev);

We've had reports of issues with AWS m4 instances, which use Intel 82559 VFs
for networking (ixgbevf) with MSI-X interrupts, which I've bisected down to
this commit. Since this commit these VMs no longer have any network connectivity
and so fail to boot. This occurs with both 5.15 and 5.10 kernels, reverting the
backport of this commit restores networking.

Do you have any suggestions of how this can be resolved other than a revert?

Here's the full bisect log:

$ git bisect log
git bisect start
# good: [4e8c680af6d51ba9315e31bd4f7599e080561a2d] Linux 5.15.7
git bisect good 4e8c680af6d51ba9315e31bd4f7599e080561a2d
# bad: [efe3167e52a5833ec20ee6214be9b99b378564a8] Linux 5.15.27
git bisect bad efe3167e52a5833ec20ee6214be9b99b378564a8
# bad: [63dcc388662c3562de94d69bfa771ae4cd29b79f] Linux 5.15.16
git bisect bad 63dcc388662c3562de94d69bfa771ae4cd29b79f
# good: [57dcae4a8b93271c4e370920ea0dbb94a0215d30] Linux 5.15.10
git bisect good 57dcae4a8b93271c4e370920ea0dbb94a0215d30
# bad: [25960cafa06e6fcd830e6c792e6a7de68c1e25ed] Linux 5.15.12
git bisect bad 25960cafa06e6fcd830e6c792e6a7de68c1e25ed
# bad: [fb6ad5cb3b6745e7bffc5fe19b130f3594375634] Linux 5.15.11
git bisect bad fb6ad5cb3b6745e7bffc5fe19b130f3594375634
# good: [257b3bb16634fd936129fe2f57a91594a75b8751] drm/amd/pm: fix a potential gpu_metrics_table memory leak
git bisect good 257b3bb16634fd936129fe2f57a91594a75b8751
# bad: [bbdaa7a48f465a2ee76d65839caeda08af1ef3b2] btrfs: fix double free of anon_dev after failure to create subvolume
git bisect bad bbdaa7a48f465a2ee76d65839caeda08af1ef3b2
# good: [c8e8e6f4108e4c133b09f31f6cc7557ee6df3bb6] bpf, selftests: Fix racing issue in btf_skc_cls_ingress test
git bisect good c8e8e6f4108e4c133b09f31f6cc7557ee6df3bb6
# bad: [5cb5c3e1b184da9f49e46119a0e506519fc58185] usb: xhci: Extend support for runtime power management for AMD's Yellow carp.
git bisect bad 5cb5c3e1b184da9f49e46119a0e506519fc58185
# good: [e7a8a261bab07ec1ed5f5bb990aacc4de9c08eb4] tty: n_hdlc: make n_hdlc_tty_wakeup() asynchronous
git bisect good e7a8a261bab07ec1ed5f5bb990aacc4de9c08eb4
# good: [4df1af29930b03d61fb774bfaa5100dbdb964628] PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error
git bisect good 4df1af29930b03d61fb774bfaa5100dbdb964628
# bad: [d8888cdabedf353ab9b5a6af75f70bf341a3e7df] PCI/MSI: Mask MSI-X vectors only on success
git bisect bad d8888cdabedf353ab9b5a6af75f70bf341a3e7df
# first bad commit: [d8888cdabedf353ab9b5a6af75f70bf341a3e7df] PCI/MSI: Mask MSI-X vectors only on success

Bests,
Jeremi
