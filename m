Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A65C3878B6
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349090AbhERM35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 08:29:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:52596 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243225AbhERM35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 08:29:57 -0400
IronPort-SDR: C18GeF6N1MDzKZqVCRnQBOr8GzGhHgecQRYXaL/zUqSrYJEPjmW1DLJ2pZIdVkaIOQlkY93bML
 iTQmwKdxMXTA==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="188106976"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="188106976"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 05:28:38 -0700
IronPort-SDR: jzzL+WGbbYTfh5GLnaswahjJ33l1Q9ApkgD1h+e0FZbpQMWO1dTjfBqs220Cx/RUALOxmv3KQS
 GkV4sHBQXXuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="541948234"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 18 May 2021 05:28:35 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 18 May 2021 15:28:34 +0300
Date:   Tue, 18 May 2021 15:28:34 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] usb: typec: tcpm: Move TCPC to APPLY_RC state
 during PR_SWAP
Message-ID: <YKOy8q649sBql9wk@kuha.fi.intel.com>
References: <20210517192112.40934-1-badhri@google.com>
 <20210517192112.40934-3-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517192112.40934-3-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 12:21:11PM -0700, Badhri Jagan Sridharan wrote:
> When vbus auto discharge is enabled, TCPCI based TCPC transitions
> into Attached.SNK/Attached.SRC state. During PR_SWAP, TCPCI based
> TCPC would disconnect when partner changes power roles. TCPC has
> to be moved APPLY RC state during PR_SWAP. This is done by
> ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2 and
> POWER_CONTROL.AutodischargeDisconnect is 0. Once the swap sequence
> is done, AutoDischargeDisconnect is re-enabled.
> 
> Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> Changes since v1:
> - Added additional check port->tcpc->apply_rc as suggested by Guenter
>   Roeck
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 16 ++++++++++++++++
>  include/linux/usb/tcpm.h      |  4 ++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index b475d9b9d38d..3c2cade986c9 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -786,6 +786,19 @@ static int tcpm_enable_auto_vbus_discharge(struct tcpm_port *port, bool enable)
>  	return ret;
>  }
>  
> +static void tcpm_apply_rc(struct tcpm_port *port)
> +{
> +	/*
> +	 * TCPCI: Move to APPLY_RC state to prevent disconnect during PR_SWAP
> +	 * when Vbus auto discharge on disconnect is enabled.
> +	 */
> +	if (port->tcpc->enable_auto_vbus_discharge && port->tcpc->apply_rc) {
> +		tcpm_log(port, "Apply_RC");
> +		port->tcpc->apply_rc(port->tcpc, port->cc_req, port->polarity);
> +		tcpm_enable_auto_vbus_discharge(port, false);
> +	}
> +}
> +
>  /*
>   * Determine RP value to set based on maximum current supported
>   * by a port if configured as source.
> @@ -4428,6 +4441,7 @@ static void run_state_machine(struct tcpm_port *port)
>  		tcpm_set_state(port, ready_state(port), 0);
>  		break;
>  	case PR_SWAP_START:
> +		tcpm_apply_rc(port);
>  		if (port->pwr_role == TYPEC_SOURCE)
>  			tcpm_set_state(port, PR_SWAP_SRC_SNK_TRANSITION_OFF,
>  				       PD_T_SRC_TRANSITION);
> @@ -4467,6 +4481,7 @@ static void run_state_machine(struct tcpm_port *port)
>  		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON_PRS);
>  		break;
>  	case PR_SWAP_SRC_SNK_SINK_ON:
> +		tcpm_enable_auto_vbus_discharge(port, true);
>  		/* Set the vbus disconnect threshold for implicit contract */
>  		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
>  		tcpm_set_state(port, SNK_STARTUP, 0);
> @@ -4483,6 +4498,7 @@ static void run_state_machine(struct tcpm_port *port)
>  			       PD_T_PS_SOURCE_OFF);
>  		break;
>  	case PR_SWAP_SNK_SRC_SOURCE_ON:
> +		tcpm_enable_auto_vbus_discharge(port, true);
>  		tcpm_set_cc(port, tcpm_rp_cc(port));
>  		tcpm_set_vbus(port, true);
>  		/*
> diff --git a/include/linux/usb/tcpm.h b/include/linux/usb/tcpm.h
> index 42fcfbe10590..bffc8d3e14ad 100644
> --- a/include/linux/usb/tcpm.h
> +++ b/include/linux/usb/tcpm.h
> @@ -66,6 +66,8 @@ enum tcpm_transmit_type {
>   *		For example, some tcpcs may include BC1.2 charger detection
>   *		and use that in this case.
>   * @set_cc:	Called to set value of CC pins
> + * @apply_rc:	Optional; Needed to move TCPCI based chipset to APPLY_RC state
> + *		as stated by the TCPCI specification.
>   * @get_cc:	Called to read current CC pin values
>   * @set_polarity:
>   *		Called to set polarity
> @@ -120,6 +122,8 @@ struct tcpc_dev {
>  	int (*get_vbus)(struct tcpc_dev *dev);
>  	int (*get_current_limit)(struct tcpc_dev *dev);
>  	int (*set_cc)(struct tcpc_dev *dev, enum typec_cc_status cc);
> +	int (*apply_rc)(struct tcpc_dev *dev, enum typec_cc_status cc,
> +			enum typec_cc_polarity polarity);
>  	int (*get_cc)(struct tcpc_dev *dev, enum typec_cc_status *cc1,
>  		      enum typec_cc_status *cc2);
>  	int (*set_polarity)(struct tcpc_dev *dev,
> -- 
> 2.31.1.751.gd2f1c929bd-goog

-- 
heikki
