Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A5342097D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 12:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhJDKuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 06:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhJDKuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 06:50:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0385A61222;
        Mon,  4 Oct 2021 10:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633344492;
        bh=LwPkg6HgEFttm4+gkwWZjXErILpWGuuCAZcf1MpIwS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wrt2hvndxzmT8HkKcIbY/DQR9urzzLn7YZZmHdgWj2q7F7GRk1W8Psov4DWPbj1Il
         gCs0yz6OgC+9VApnsFf0gT5P93jn26AV07UIiLKnjAvpj5qh16ht0iFyy2GVuvpNMh
         u6AEyPCj7DwImwzuU2yEpTyYHbqk5JDWWbvDF+SU=
Date:   Mon, 4 Oct 2021 12:48:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andre Tomt <andre@tomt.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Ederson de Souza <ederson.desouza@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 058/162] igc: fix build errors for PTP
Message-ID: <YVrb6tqBvuF87Ghj@kroah.com>
References: <20210927170233.453060397@linuxfoundation.org>
 <20210927170235.491648102@linuxfoundation.org>
 <0599f364-c9cc-31af-e500-89778f0b566c@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0599f364-c9cc-31af-e500-89778f0b566c@tomt.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 06:15:56AM +0200, Andre Tomt wrote:
> On 27.09.2021 19:01, Greg Kroah-Hartman wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > [ Upstream commit 87758511075ec961486fe78d7548dd709b524433 ]
> > 
> > When IGC=y and PTP_1588_CLOCK=m, the ptp_*() interface family is
> > not available to the igc driver. Make this driver depend on
> > PTP_1588_CLOCK_OPTIONAL so that it will build without errors.
> > 
> > Various igc commits have used ptp_*() functions without checking
> > that PTP_1588_CLOCK is enabled. Fix all of these here.
> > 
> > Fixes these build errors:
> > 
> > ld: drivers/net/ethernet/intel/igc/igc_main.o: in function `igc_msix_other':
> > igc_main.c:(.text+0x6494): undefined reference to `ptp_clock_event'
> > ld: igc_main.c:(.text+0x64ef): undefined reference to `ptp_clock_event'
> > ld: igc_main.c:(.text+0x6559): undefined reference to `ptp_clock_event'
> > ld: drivers/net/ethernet/intel/igc/igc_ethtool.o: in function `igc_ethtool_get_ts_info':
> > igc_ethtool.c:(.text+0xc7a): undefined reference to `ptp_clock_index'
> > ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_feature_enable_i225':
> > igc_ptp.c:(.text+0x330): undefined reference to `ptp_find_pin'
> > ld: igc_ptp.c:(.text+0x36f): undefined reference to `ptp_find_pin'
> > ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_init':
> > igc_ptp.c:(.text+0x11cd): undefined reference to `ptp_clock_register'
> > ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_stop':
> > igc_ptp.c:(.text+0x12dd): undefined reference to `ptp_clock_unregister'
> > ld: drivers/platform/x86/dell/dell-wmi-privacy.o: in function `dell_privacy_wmi_probe':
> > 
> > Fixes: 64433e5bf40ab ("igc: Enable internal i225 PPS")
> > Fixes: 60dbede0c4f3d ("igc: Add support for ethtool GET_TS_INFO command")
> > Fixes: 87938851b6efb ("igc: enable auxiliary PHC functions for the i225")
> > Fixes: 5f2958052c582 ("igc: Add basic skeleton for PTP")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Ederson de Souza <ederson.desouza@intel.com>
> > Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Cc: intel-wired-lan@lists.osuosl.org
> > Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/net/ethernet/intel/Kconfig | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> > index 82744a7501c7..c11d974a62d8 100644
> > --- a/drivers/net/ethernet/intel/Kconfig
> > +++ b/drivers/net/ethernet/intel/Kconfig
> > @@ -335,6 +335,7 @@ config IGC
> >   	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
> >   	default n
> >   	depends on PCI
> > +	depends on PTP_1588_CLOCK_OPTIONAL
> >   	help
> >   	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
> >   	  family of adapters.
> > 
> 
> PTP_1588_CLOCK_OPTIONAL does not exist in 5.14, so this effectively disables
> the igc driver completely when applied to stable as-is.

Now dropped from the queue, again :)

thanks,

greg k-h
