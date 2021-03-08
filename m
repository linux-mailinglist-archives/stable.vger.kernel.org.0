Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3FB330BE4
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 12:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCHLDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 06:03:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:27634 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhCHLDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 06:03:01 -0500
IronPort-SDR: 3USx/fzR8heP2OtperS8d6UETOCcNe8iYb1uyfY+ntCkwROyYDBKkk6IysiALIoQR4uW6nE5/C
 HwbmZ1WShApg==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="249386909"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="249386909"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 03:03:00 -0800
IronPort-SDR: KqOhvw4BOdQfevTSuPcgjToCzWaEhlpQE8tAP9dfVlQcmPI1WcVX3Ao5A9K08t19rvzjRAOwPz
 FlaT+pvrt4Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="508891391"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 08 Mar 2021 03:02:57 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 08 Mar 2021 13:02:56 +0200
Date:   Mon, 8 Mar 2021 13:02:56 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpci: Check ROLE_CONTROL while
 interpreting CC_STATUS
Message-ID: <YEYEYKqUgnaijOmP@kuha.fi.intel.com>
References: <20210304070931.1947316-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304070931.1947316-1-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 11:09:31PM -0800, Badhri Jagan Sridharan wrote:
> While interpreting CC_STATUS, ROLE_CONTROL has to be read to make
> sure that CC1/CC2 is not forced presenting Rp/Rd.
> 
> >From the TCPCI spec:
> 
> 4.4.5.2 ROLE_CONTROL (Normative):
> The TCPM shall write B6 (DRP) = 0b and B3..0 (CC1/CC2) if it wishes
> to control the Rp/Rd directly instead of having the TCPC perform
> DRP toggling autonomously. When controlling Rp/Rd directly, the
> TCPM writes to B3..0 (CC1/CC2) each time it wishes to change the
> CC1/CC2 values. This control is used for TCPM-TCPC implementing
> Source or Sink only as well as when a connection has been detected
> via DRP toggling but the TCPM wishes to attempt Try.Src or Try.Snk.
> 
> Table 4-22. CC_STATUS Register Definition:
> If (ROLE_CONTROL.CC1 = Rd) or ConnectResult=1)
> 00b: SNK.Open (Below maximum vRa)
> 01b: SNK.Default (Above minimum vRd-Connect)
> 10b: SNK.Power1.5 (Above minimum vRd-Connect) Detects Rp-1.5A
> 11b: SNK.Power3.0 (Above minimum vRd-Connect) Detects Rp-3.0A
> 
> If (ROLE_CONTROL.CC2=Rd) or (ConnectResult=1)
> 00b: SNK.Open (Below maximum vRa)
> 01b: SNK.Default (Above minimum vRd-Connect)
> 10b: SNK.Power1.5 (Above minimum vRd-Connect) Detects Rp 1.5A
> 11b: SNK.Power3.0 (Above minimum vRd-Connect) Detects Rp 3.0A
> 
> Fixes: 74e656d6b0551 ("staging: typec: Type-C Port Controller
> Interface driver (tcpci)")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/tcpm/tcpci.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index a27deb0b5f03..027afd7dfdce 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -24,6 +24,15 @@
>  #define	AUTO_DISCHARGE_PD_HEADROOM_MV		850
>  #define	AUTO_DISCHARGE_PPS_HEADROOM_MV		1250
>  
> +#define tcpc_presenting_cc1_rd(reg) \
> +	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
> +	 (((reg) & (TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT)) == \
> +	  (TCPC_ROLE_CTRL_CC_RD << TCPC_ROLE_CTRL_CC1_SHIFT)))
> +#define tcpc_presenting_cc2_rd(reg) \
> +	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
> +	 (((reg) & (TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT)) == \
> +	  (TCPC_ROLE_CTRL_CC_RD << TCPC_ROLE_CTRL_CC2_SHIFT)))
> +

Couldn't you handle that with a single macro by concatenating the CC
line numbers?

>  struct tcpci {
>  	struct device *dev;
>  
> @@ -178,19 +187,25 @@ static int tcpci_get_cc(struct tcpc_dev *tcpc,
>  			enum typec_cc_status *cc1, enum typec_cc_status *cc2)
>  {
>  	struct tcpci *tcpci = tcpc_to_tcpci(tcpc);
> -	unsigned int reg;
> +	unsigned int reg, role_control;
>  	int ret;
>  
> +	ret = regmap_read(tcpci->regmap, TCPC_ROLE_CTRL, &role_control);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret = regmap_read(tcpci->regmap, TCPC_CC_STATUS, &reg);
>  	if (ret < 0)
>  		return ret;
>  
>  	*cc1 = tcpci_to_typec_cc((reg >> TCPC_CC_STATUS_CC1_SHIFT) &
>  				 TCPC_CC_STATUS_CC1_MASK,
> -				 reg & TCPC_CC_STATUS_TERM);
> +				 reg & TCPC_CC_STATUS_TERM ||
> +				 tcpc_presenting_cc1_rd(role_control));
>  	*cc2 = tcpci_to_typec_cc((reg >> TCPC_CC_STATUS_CC2_SHIFT) &
>  				 TCPC_CC_STATUS_CC2_MASK,
> -				 reg & TCPC_CC_STATUS_TERM);
> +				 reg & TCPC_CC_STATUS_TERM ||
> +				 tcpc_presenting_cc2_rd(role_control));
>  
>  	return 0;
>  }
> -- 
> 2.30.1.766.gb4fecdf3b7-goog

thanks,

-- 
heikki
