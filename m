Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF6B3878BD
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349106AbhERMbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 08:31:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:15014 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243225AbhERMbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 08:31:11 -0400
IronPort-SDR: +157d68JyosE4ib/9uk/bQTEhVXpoDlZfUhWJ+0CoYgMOIVV5Rdz+NRWvI4tBs3DofjTJcgnT+
 i62JhZezahmQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="200746369"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="200746369"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 05:29:53 -0700
IronPort-SDR: 44+0HXFQpnZD3rsi+WipY2h6YFR7baNyxmSJyBQ8xku0qbfuqZ8l53hhC4Db9TU2kp+ETYuU+v
 cRYxLynX5K5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="541948886"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 18 May 2021 05:29:50 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 18 May 2021 15:29:49 +0300
Date:   Tue, 18 May 2021 15:29:49 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] usb: typec: tcpci: Implement callback for apply_rc
Message-ID: <YKOzPSFmTcDf6R7S@kuha.fi.intel.com>
References: <20210517192112.40934-1-badhri@google.com>
 <20210517192112.40934-4-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517192112.40934-4-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 12:21:12PM -0700, Badhri Jagan Sridharan wrote:
> APPLY RC is defined as ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2 and
> POWER_CONTROL.AutodischargeDisconnect is 0. When ROLE_CONTROL.CC1 ==
> ROLE_CONTROL.CC2, set the other CC to OPEN.
> 
> Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> Changes since V1:
> - Added Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/usb/typec/tcpm/tcpci.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index 25b480752266..34b5095cc84f 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -115,6 +115,32 @@ static int tcpci_set_cc(struct tcpc_dev *tcpc, enum typec_cc_status cc)
>  	return 0;
>  }
>  
> +int tcpci_apply_rc(struct tcpc_dev *tcpc, enum typec_cc_status cc, enum typec_cc_polarity polarity)
> +{
> +	struct tcpci *tcpci = tcpc_to_tcpci(tcpc);
> +	unsigned int reg;
> +	int ret;
> +
> +	ret = regmap_read(tcpci->regmap, TCPC_ROLE_CTRL, &reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * APPLY_RC state is when ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2 and vbus autodischarge on
> +	 * disconnect is disabled. Bail out when ROLE_CONTROL.CC1 != ROLE_CONTROL.CC2.
> +	 */
> +	if (((reg & (TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT)) >>
> +	     TCPC_ROLE_CTRL_CC2_SHIFT) !=
> +	    ((reg & (TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT)) >>
> +	     TCPC_ROLE_CTRL_CC1_SHIFT))
> +		return 0;
> +
> +	return regmap_update_bits(tcpci->regmap, TCPC_ROLE_CTRL, polarity == TYPEC_POLARITY_CC1 ?
> +				  TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT :
> +				  TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT,
> +				  TCPC_ROLE_CTRL_CC_OPEN);
> +}
> +
>  static int tcpci_start_toggling(struct tcpc_dev *tcpc,
>  				enum typec_port_type port_type,
>  				enum typec_cc_status cc)
> @@ -728,6 +754,7 @@ struct tcpci *tcpci_register_port(struct device *dev, struct tcpci_data *data)
>  	tcpci->tcpc.get_vbus = tcpci_get_vbus;
>  	tcpci->tcpc.set_vbus = tcpci_set_vbus;
>  	tcpci->tcpc.set_cc = tcpci_set_cc;
> +	tcpci->tcpc.apply_rc = tcpci_apply_rc;
>  	tcpci->tcpc.get_cc = tcpci_get_cc;
>  	tcpci->tcpc.set_polarity = tcpci_set_polarity;
>  	tcpci->tcpc.set_vconn = tcpci_set_vconn;
> -- 
> 2.31.1.751.gd2f1c929bd-goog

-- 
heikki
