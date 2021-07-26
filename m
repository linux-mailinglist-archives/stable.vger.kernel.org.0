Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84A13D659D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 19:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhGZQny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 12:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232941AbhGZQng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 12:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE1860F6E;
        Mon, 26 Jul 2021 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627320244;
        bh=DvXze96V4sJ55D1fineSjlUtIu2Ymo2XgdIq6mLnDrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=i82zLDZG39xVnCdnLsX4XdPOhNWp4Z7SLctohxAu3tetJvPlb0eNNuWjnTyB2oEtp
         XJb3StYuwkxsNumPRxuB7fk/vA1dKyDnyyyJVOqKMGFFWW5MzgCJ7+W1YReIwyjlAf
         tip0jcW6xjJy4lTRQdeH2LMpFFGysDuwEFFJQFTvUF/5aPdyCtFQNr9SyG+c9yHqaY
         lGTQwWY2D0cnKpO3ubS9EaMwDv7mHSQsNaNxe5NbPHrHc7oPHvu99y/pX+Hk6nW7qF
         QSsIGVV5EppJGHcz3MMRM+p4Ntvp0y924dPgkdbbIB0pAyPoUco8IfTWP+0jLYlqti
         rOBRWg3flXbXg==
Date:   Mon, 26 Jul 2021 12:24:03 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     linux-pci@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        =?iso-8859-1?Q?R=F6tti?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Zachary Zhang <zhangzg@marvell.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI: Add Max Payload Size quirk for ASMedia ASM1062
 SATA controller
Message-ID: <20210726172403.GA623272@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210624171418.27194-2-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 24, 2021 at 07:14:18PM +0200, Marek Behún wrote:
> The ASMedia ASM1062 SATA controller advertises
> Max_Payload_Size_Supported of 512, but in fact it cannot handle TLPs
> with payload size of 512.
> 
> We discovered this issue on PCIe controllers capable of MPS = 512
> (Aardvark and DesignWare), where the issue presents itself as an
> External Abort. Bjorn Helgaas says:
>   Probably ASM1062 reports a Malformed TLP error when it receives a data
>   payload of 512 bytes, and Aardvark, DesignWare, etc convert this to an
>   arm64 External Abort.
> 
> Limiting Max Payload Size to 256 bytes solves this problem.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212695
> Reported-by: Rötti <espressobinboardarmbiantempmailaddress@posteo.de>
> Cc: Pali Rohár <pali@kernel.org>
> Cc: stable@vger.kernel.org

Applied both to pci/enumeration for v5.15, thanks!

Were you able to confirm that a Malformed TLP error was logged?  The
lspci in the bugzilla is from a system with no AER support, so no
information from that one.  I don't know if any of the PCIe
controllers you tested support both AER and MPS=512.

> ---
>  drivers/pci/quirks.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 4d9b9d8fbc43..a4ba3e3b3c5e 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3239,6 +3239,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
>  			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
>  			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
>  
>  /*
>   * Intel 5000 and 5100 Memory controllers have an erratum with read completion
> -- 
> 2.31.1
> 
