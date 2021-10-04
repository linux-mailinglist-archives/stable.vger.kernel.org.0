Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF139420538
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 06:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhJDE0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 00:26:31 -0400
Received: from mail1.ugh.no ([178.79.162.34]:58782 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230193AbhJDE0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 00:26:30 -0400
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2021 00:26:30 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 56DC02554CA;
        Mon,  4 Oct 2021 06:15:59 +0200 (CEST)
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LwONpQ8GEa86; Mon,  4 Oct 2021 06:15:58 +0200 (CEST)
Received: from [IPV6:2a0a:2780:4e89:40:96fb:1f70:94af:2f39] (unknown [IPv6:2a0a:2780:4e89:40:96fb:1f70:94af:2f39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id DE8C02554C4;
        Mon,  4 Oct 2021 06:15:57 +0200 (CEST)
Message-ID: <0599f364-c9cc-31af-e500-89778f0b566c@tomt.net>
Date:   Mon, 4 Oct 2021 06:15:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 5.14 058/162] igc: fix build errors for PTP
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Ederson de Souza <ederson.desouza@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, Sasha Levin <sashal@kernel.org>
References: <20210927170233.453060397@linuxfoundation.org>
 <20210927170235.491648102@linuxfoundation.org>
From:   Andre Tomt <andre@tomt.net>
In-Reply-To: <20210927170235.491648102@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.09.2021 19:01, Greg Kroah-Hartman wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> [ Upstream commit 87758511075ec961486fe78d7548dd709b524433 ]
> 
> When IGC=y and PTP_1588_CLOCK=m, the ptp_*() interface family is
> not available to the igc driver. Make this driver depend on
> PTP_1588_CLOCK_OPTIONAL so that it will build without errors.
> 
> Various igc commits have used ptp_*() functions without checking
> that PTP_1588_CLOCK is enabled. Fix all of these here.
> 
> Fixes these build errors:
> 
> ld: drivers/net/ethernet/intel/igc/igc_main.o: in function `igc_msix_other':
> igc_main.c:(.text+0x6494): undefined reference to `ptp_clock_event'
> ld: igc_main.c:(.text+0x64ef): undefined reference to `ptp_clock_event'
> ld: igc_main.c:(.text+0x6559): undefined reference to `ptp_clock_event'
> ld: drivers/net/ethernet/intel/igc/igc_ethtool.o: in function `igc_ethtool_get_ts_info':
> igc_ethtool.c:(.text+0xc7a): undefined reference to `ptp_clock_index'
> ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_feature_enable_i225':
> igc_ptp.c:(.text+0x330): undefined reference to `ptp_find_pin'
> ld: igc_ptp.c:(.text+0x36f): undefined reference to `ptp_find_pin'
> ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_init':
> igc_ptp.c:(.text+0x11cd): undefined reference to `ptp_clock_register'
> ld: drivers/net/ethernet/intel/igc/igc_ptp.o: in function `igc_ptp_stop':
> igc_ptp.c:(.text+0x12dd): undefined reference to `ptp_clock_unregister'
> ld: drivers/platform/x86/dell/dell-wmi-privacy.o: in function `dell_privacy_wmi_probe':
> 
> Fixes: 64433e5bf40ab ("igc: Enable internal i225 PPS")
> Fixes: 60dbede0c4f3d ("igc: Add support for ethtool GET_TS_INFO command")
> Fixes: 87938851b6efb ("igc: enable auxiliary PHC functions for the i225")
> Fixes: 5f2958052c582 ("igc: Add basic skeleton for PTP")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Ederson de Souza <ederson.desouza@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/ethernet/intel/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index 82744a7501c7..c11d974a62d8 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -335,6 +335,7 @@ config IGC
>   	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
>   	default n
>   	depends on PCI
> +	depends on PTP_1588_CLOCK_OPTIONAL
>   	help
>   	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
>   	  family of adapters.
> 

PTP_1588_CLOCK_OPTIONAL does not exist in 5.14, so this effectively 
disables the igc driver completely when applied to stable as-is.
