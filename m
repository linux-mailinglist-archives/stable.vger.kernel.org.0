Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3942245FF
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 23:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgGQVxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 17:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgGQVxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 17:53:06 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D822070A;
        Fri, 17 Jul 2020 21:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595022786;
        bh=ZAVaom5QhjHBn6ca9BuiQd8MD1k+/iw1bY0PSQH8YKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=MZtg7O5xNufxkgYT//r++u+TUAkFBKKOuCfbQNU52hEQTuSlF//6vijfE1nkNyKCx
         HM6Tev7IgCO9geyHbYkSxcPjiRjCY77tIXMwEamcCgb97wvdqy/x59QD3NJ1OIFSaY
         RUbdQsNXckoipyqHch8jZjBS2xqJpteSUDL0NFZw=
Date:   Fri, 17 Jul 2020 16:53:04 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nicolas Chauvet <kwizart@gmail.com>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pci: tegra: Revert raw_violation_fixup for tegra124
Message-ID: <20200717215304.GA775582@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717213510.171726-1-kwizart@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please update subject to follow the convention ("git log --online
drivers/pci/controller/pci-tegra.c") to see it:

  PCI: tegra: Revert tegra124 raw_violation_fixup

On Fri, Jul 17, 2020 at 11:35:10PM +0200, Nicolas Chauvet wrote:
> As reported in https://bugzilla.kernel.org/206217 , raw_violation_fixup
> is causing more harm than good in some common use-cases.
> 
> This patch is a partial revert of the 191cd6fb5 commit:
>  "PCI: tegra: Add SW fixup for RAW violations"

Usual style is:
191cd6fb5d2c ("PCI: tegra: Add SW fixup for RAW violations")

> that was first introduced in 5.3-rc1 kernel.
> This fix the following regression since then.
> 
> * Description:
> When both the NIC and MMC are used one can see the following message:
> 
> NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out
> 
>   and
> 
> pcieport 0000:00:02.0: AER: Uncorrected (Non-Fatal) error received: 0000:01:00.0
> r8169 0000:01:00.0: AER: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> r8169 0000:01:00.0: AER:   device [10ec:8168] error status/mask=00004000/00400000
> r8169 0000:01:00.0: AER:    [14] CmpltTO                (First)
> r8169 0000:01:00.0: AER: can't recover (no error_detected callback)
> pcieport 0000:00:02.0: AER: device recovery failed

Indent the quoted text (messages) two spaces so it's distinct from the
prose.

> After that, the ethernet NIC isn't functional anymore even after reloading
> the r8169 module.
> After a reboot, this is reproducible by copying a large file over the
> NIC to the MMC.

This looks like two paragraphs; if so, put a blank line between them.
Otherwise wrap them so they fill the line.  It's hard to read when
there are line breaks that look unnecessary.

> For some reasons this cannot be reproduced when the same file is copied
> to a tmpfs.
> 
> * Little background on the fixup, by Manikanta Maddireddy:
>   "In the internal testing with dGPU on Tegra124, CmplTO is reported by
> dGPU. This happened because FIFO queue in AFI(AXI to PCIe) module
> get full by upstream posted writes. Back to back upstream writes
> interleaved with infrequent reads, triggers RAW violation and CmpltTO.
> This is fixed by reducing the posted write credits and by changing
> updateFC timer frequency. These settings are fixed after stress test.
> 
> In the current case, RTL NIC is also reporting CmplTO. These settings
> seems to be aggravating the issue instead of fixing it."
> 
> v1: first non-RFC version
>  - Disable raw_violation_fixup and fully remove unused code and macros

This version history can go after the "---" so it doesn't get included
in the final commit log.  It's nice if your subject line includes
"[PATCH v2]" or whatever is appropriate.

Add this just before your Signed-off-by:

  Fixes: 191cd6fb5d2c ("PCI: tegra: Add SW fixup for RAW violations")

> Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
> Reviewed-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
> Cc: <stable@vger.kernel.org> # 5.4.x

No "<>" needed around stable@vger.kernel.org

You need not (and shouldn't) cc: stable@vger.kernel.org when you post
this to the list.  The stable tag here in the commit log is
sufficient.  Documentation/process/stable-kernel-rules.rst for more
details.

Is v5.4.x really the oldest kernel that should get this fix?  It looks
like 191cd6fb5d2c appeared in v5.3.
