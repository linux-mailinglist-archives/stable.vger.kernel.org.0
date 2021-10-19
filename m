Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7594340D2
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhJSVy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 17:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhJSVyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 17:54:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 491386113D;
        Tue, 19 Oct 2021 21:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634680362;
        bh=RChkijL4VgeiILZ/hKivuyweXS5HKozQM5/t83ixE4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=dACRbHL5KuWVhHI8Eeg/t64gpnkT3KqH36q/3jN6gyRusHzonDIV4dRB8RUy5aeQ6
         tXef5o6GOZzITXrw+84Msi+/mVqtqH+LLfmBBXqq5vUTVMl58M3h8/xn+4MZPVF/Zv
         euc43455+CRuIa6ds71IcSolD2gJD5lUIzvFadRiRc22H5QbHrfPcQvFhbVZMINohP
         7VggRlYCrwf/O94NN7iNdqtIQlVedTYSn9XNtc0NBY1WG8R+DYEJ2bZr+UyiQGX05n
         Rs9yfEJpeKaIKdpt9Lx6s2huH5lO2iSWPIWS9Oy28sVCwWdxuv891ek2QNPkZ8JXO8
         tRTGlpvgnmJIw==
Date:   Tue, 19 Oct 2021 16:52:40 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Benoit =?iso-8859-1?Q?Gr=E9goire?= <benoitg@coeus.ca>,
        Hui Wang <hui.wang@canonical.com>, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v5 1/2] x86/PCI: Ignore E820 reservations for bridge
 windows on newer systems
Message-ID: <20211019215240.GA2411590@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211014183943.27717-2-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 08:39:42PM +0200, Hans de Goede wrote:
> Some BIOS-es contain a bug where they add addresses which map to system
> RAM in the PCI host bridge window returned by the ACPI _CRS method, see
> commit 4dc2287c1805 ("x86: avoid E820 regions when allocating address
> space").
> 
> To work around this bug Linux excludes E820 reserved addresses when
> allocating addresses from the PCI host bridge window since 2010.
> 
> Recently (2020) some systems have shown-up with E820 reservations which
> cover the entire _CRS returned PCI bridge memory window, causing all
> attempts to assign memory to PCI BARs which have not been setup by the
> BIOS to fail. For example here are the relevant dmesg bits from a
> Lenovo IdeaPad 3 15IIL 81WE:
> 
>  [mem 0x000000004bc50000-0x00000000cfffffff] reserved
>  pci_bus 0000:00: root bus resource [mem 0x65400000-0xbfffffff window]
> 
> The ACPI specifications appear to allow this new behavior:
> 
> The relationship between E820 and ACPI _CRS is not really very clear.
> ACPI v6.3, sec 15, table 15-374, says AddressRangeReserved means:
> 
>   This range of addresses is in use or reserved by the system and is
>   not to be included in the allocatable memory pool of the operating
>   system's memory manager.
> 
> and it may be used when:
> 
>   The address range is in use by a memory-mapped system device.
> 
> Furthermore, sec 15.2 says:
> 
>   Address ranges defined for baseboard memory-mapped I/O devices, such
>   as APICs, are returned as reserved.
> 
> A PCI host bridge qualifies as a baseboard memory-mapped I/O device,
> and its apertures are in use and certainly should not be included in
> the general allocatable pool, so the fact that some BIOS-es reports
> the PCI aperture as "reserved" in E820 doesn't seem like a BIOS bug.
> 
> So it seems that the excluding of E820 reserved addresses is a mistake.
> 
> Ideally Linux would fully stop excluding E820 reserved addresses,
> but then the old systems this was added for will regress.
> Instead keep the old behavior for old systems, while ignoring
> the E820 reservations for any systems from now on.
> 
> Old systems are defined here as BIOS year < 2018, this was chosen to
> make sure that pci_use_e820 will not be set on the currently affected
> systems, while at the same time also taking into account that the
> systems for which the E820 checking was originally added may have
> received BIOS updates for quite a while (esp. CVE related ones),
> giving them a more recent BIOS year then 2010.
> 
> Also add pci=no_e820 and pci=use_e820 options to allow overriding
> the BIOS year heuristic.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206459
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1868899
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1871793
> BugLink: https://bugs.launchpad.net/bugs/1878279
> BugLink: https://bugs.launchpad.net/bugs/1931715
> BugLink: https://bugs.launchpad.net/bugs/1932069
> BugLink: https://bugs.launchpad.net/bugs/1921649
> Cc: Benoit Grégoire <benoitg@coeus.ca>
> Cc: Hui Wang <hui.wang@canonical.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I haven't seen anybody else eager to merge this, so I guess I'll stick
my neck out here.

I applied this to my for-linus branch for v5.15.

> ---
> Changes in v5:
> - Drop mention of Windows behavior from the commit msg, replace with a
>   reference to the specs
> - Improve documentation in Documentation/admin-guide/kernel-parameters.txt
> - Reword the big comment added, use "PCI host bridge window" in it and drop
>   all refences to Windows
> 
> Changes in v4:
> - Rewrap the big comment block to fit in 80 columns
> - Add Rafael's Acked-by
> - Add Cc: stable@vger.kernel.org
> 
> Changes in v3:
> - Commit msg tweaks (drop dmesg timestamps, typo fix)
> - Use "defined(CONFIG_...)" instead of "defined CONFIG_..."
> - Add Mika's Reviewed-by
> 
> Changes in v2:
> - Replace the per model DMI quirk approach with disabling E820 reservations
>   checking for all systems with a BIOS year >= 2018
> - Add documentation for the new kernel-parameters to
>   Documentation/admin-guide/kernel-parameters.txt
> ---
> Other patches trying to address the same issue:
> https://lore.kernel.org/r/20210624095324.34906-1-hui.wang@canonical.com
> https://lore.kernel.org/r/20200617164734.84845-1-mika.westerberg@linux.intel.com
> V1 patch:
> https://lore.kernel.org/r/20211005150956.303707-1-hdegoede@redhat.com
> ---
>  .../admin-guide/kernel-parameters.txt         |  9 ++++++
>  arch/x86/include/asm/pci_x86.h                | 10 +++++++
>  arch/x86/kernel/resource.c                    |  4 +++
>  arch/x86/pci/acpi.c                           | 28 +++++++++++++++++++
>  arch/x86/pci/common.c                         |  6 ++++
>  5 files changed, 57 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 43dc35fe5bc0..07f1615206d4 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3949,6 +3949,15 @@
>  				please report a bug.
>  		nocrs		[X86] Ignore PCI host bridge windows from ACPI.
>  				If you need to use this, please report a bug.
> +		use_e820	[X86] Use E820 reservations to exclude parts of
> +				PCI host bridge windows. This is a workaround
> +				for BIOS defects in host bridge _CRS methods.
> +				If you need to use this, please report a bug to
> +				<linux-pci@vger.kernel.org>.
> +		no_e820		[X86] Ignore E820 reservations for PCI host
> +				bridge windows. This is the default on modern
> +				hardware. If you need to use this, please report
> +				a bug to <linux-pci@vger.kernel.org>.
>  		routeirq	Do IRQ routing for all PCI devices.
>  				This is normally done in pci_enable_device(),
>  				so this option is a temporary workaround
> diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
> index 490411dba438..0bb4e7dd0ffc 100644
> --- a/arch/x86/include/asm/pci_x86.h
> +++ b/arch/x86/include/asm/pci_x86.h
> @@ -39,6 +39,8 @@ do {						\
>  #define PCI_ROOT_NO_CRS		0x100000
>  #define PCI_NOASSIGN_BARS	0x200000
>  #define PCI_BIG_ROOT_WINDOW	0x400000
> +#define PCI_USE_E820		0x800000
> +#define PCI_NO_E820		0x1000000
>  
>  extern unsigned int pci_probe;
>  extern unsigned long pirq_table_addr;
> @@ -64,6 +66,8 @@ void pcibios_scan_specific_bus(int busn);
>  
>  /* pci-irq.c */
>  
> +struct pci_dev;
> +
>  struct irq_info {
>  	u8 bus, devfn;			/* Bus, device and function */
>  	struct {
> @@ -232,3 +236,9 @@ static inline void mmio_config_writel(void __iomem *pos, u32 val)
>  # define x86_default_pci_init_irq	NULL
>  # define x86_default_pci_fixup_irqs	NULL
>  #endif
> +
> +#if defined(CONFIG_PCI) && defined(CONFIG_ACPI)
> +extern bool pci_use_e820;
> +#else
> +#define pci_use_e820 false
> +#endif
> diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
> index 9b9fb7882c20..e8dc9bc327bd 100644
> --- a/arch/x86/kernel/resource.c
> +++ b/arch/x86/kernel/resource.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/ioport.h>
>  #include <asm/e820/api.h>
> +#include <asm/pci_x86.h>
>  
>  static void resource_clip(struct resource *res, resource_size_t start,
>  			  resource_size_t end)
> @@ -28,6 +29,9 @@ static void remove_e820_regions(struct resource *avail)
>  	int i;
>  	struct e820_entry *entry;
>  
> +	if (!pci_use_e820)
> +		return;
> +
>  	for (i = 0; i < e820_table->nr_entries; i++) {
>  		entry = &e820_table->entries[i];
>  
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 948656069cdd..72d473054262 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -21,6 +21,8 @@ struct pci_root_info {
>  
>  static bool pci_use_crs = true;
>  static bool pci_ignore_seg = false;
> +/* Consumed in arch/x86/kernel/resource.c */
> +bool pci_use_e820 = false;
>  
>  static int __init set_use_crs(const struct dmi_system_id *id)
>  {
> @@ -160,6 +162,32 @@ void __init pci_acpi_crs_quirks(void)
>  	       "if necessary, use \"pci=%s\" and report a bug\n",
>  	       pci_use_crs ? "Using" : "Ignoring",
>  	       pci_use_crs ? "nocrs" : "use_crs");
> +
> +	/*
> +	 * Some BIOS-es contain a bug where they add addresses which map to
> +	 * system RAM in the PCI host bridge window returned by the ACPI _CRS
> +	 * method, see commit 4dc2287c1805 ("x86: avoid E820 regions when
> +	 * allocating address space"). To avoid this Linux by default excludes
> +	 * E820 reservations when allocating addresses since 2010.
> +	 * In 2020 some systems have shown-up with E820 reservations which cover
> +	 * the entire _CRS returned PCI host bridge window, causing all attempts
> +	 * to assign memory to PCI BARs to fail if Linux uses E820 reservations.
> +	 *
> +	 * Ideally Linux would fully stop using E820 reservations, but then
> +	 * the old systems this was added for will regress.
> +	 * Instead keep the old behavior for old systems, while ignoring the
> +	 * E820 reservations for any systems from now on.
> +	 */
> +	if (year >= 0 && year < 2018)
> +		pci_use_e820 = true;
> +
> +	if (pci_probe & PCI_NO_E820)
> +		pci_use_e820 = false;
> +	else if (pci_probe & PCI_USE_E820)
> +		pci_use_e820 = true;
> +
> +	printk(KERN_INFO "PCI: %s E820 reservations for host bridge windows\n",
> +	       pci_use_e820 ? "Using" : "Ignoring");
>  }
>  
>  #ifdef	CONFIG_PCI_MMCONFIG
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 3507f456fcd0..091ec7e94fcb 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -595,6 +595,12 @@ char *__init pcibios_setup(char *str)
>  	} else if (!strcmp(str, "nocrs")) {
>  		pci_probe |= PCI_ROOT_NO_CRS;
>  		return NULL;
> +	} else if (!strcmp(str, "use_e820")) {
> +		pci_probe |= PCI_USE_E820;
> +		return NULL;
> +	} else if (!strcmp(str, "no_e820")) {
> +		pci_probe |= PCI_NO_E820;
> +		return NULL;
>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
>  	} else if (!strcmp(str, "big_root_window")) {
>  		pci_probe |= PCI_BIG_ROOT_WINDOW;
> -- 
> 2.31.1
> 
