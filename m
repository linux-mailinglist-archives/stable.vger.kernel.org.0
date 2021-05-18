Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B783878B0
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 14:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349067AbhERM3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 08:29:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:52564 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349064AbhERM3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 08:29:19 -0400
IronPort-SDR: 86cNO5qTr+I2QiaI3rswOfzj4Y52MsKbnk6aKgTI23OMl0nHvvw7qotGdLD8Vyw2RhbMrOUW4B
 m5KQ82P/jjXg==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="188106907"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="188106907"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 05:28:01 -0700
IronPort-SDR: MM8qw/1R/31YkJnMATNQL70wS4UOOUCwZgEOVvy7IWnGfEU/skBYeo/dEBXMT6nGa5S7VLsVt1
 vX1y1bce134Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="541947906"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 18 May 2021 05:27:58 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 18 May 2021 15:27:57 +0300
Date:   Tue, 18 May 2021 15:27:57 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] usb: typec: tcpm: Refactor logic to
 enable/disable auto vbus dicharge
Message-ID: <YKOyzeYHmnUVCtF0@kuha.fi.intel.com>
References: <20210517192112.40934-1-badhri@google.com>
 <20210517192112.40934-2-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517192112.40934-2-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 12:21:10PM -0700, Badhri Jagan Sridharan wrote:
> The logic to enable vbus auto discharge on disconnect is used in
> more than one place. Since this is repetitive code, moving this into
> its own method.
> 
> Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> Changes since V1:
> - Added Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 39 ++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index b93c4c8d7b15..b475d9b9d38d 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -771,6 +771,21 @@ static void tcpm_set_cc(struct tcpm_port *port, enum typec_cc_status cc)
>  	port->tcpc->set_cc(port->tcpc, cc);
>  }
>  
> +static int tcpm_enable_auto_vbus_discharge(struct tcpm_port *port, bool enable)
> +{
> +	int ret = 0;
> +
> +	if (port->tcpc->enable_auto_vbus_discharge) {
> +		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, enable);
> +		tcpm_log_force(port, "%s vbus discharge ret:%d", enable ? "enable" : "disable",
> +			       ret);
> +		if (!ret)
> +			port->auto_vbus_discharge_enabled = enable;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * Determine RP value to set based on maximum current supported
>   * by a port if configured as source.
> @@ -3445,12 +3460,7 @@ static int tcpm_src_attach(struct tcpm_port *port)
>  	if (ret < 0)
>  		return ret;
>  
> -	if (port->tcpc->enable_auto_vbus_discharge) {
> -		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
> -		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> -		if (!ret)
> -			port->auto_vbus_discharge_enabled = true;
> -	}
> +	tcpm_enable_auto_vbus_discharge(port, true);
>  
>  	ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
>  	if (ret < 0)
> @@ -3527,14 +3537,7 @@ static void tcpm_set_partner_usb_comm_capable(struct tcpm_port *port, bool capab
>  
>  static void tcpm_reset_port(struct tcpm_port *port)
>  {
> -	int ret;
> -
> -	if (port->tcpc->enable_auto_vbus_discharge) {
> -		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, false);
> -		tcpm_log_force(port, "Disable vbus discharge ret:%d", ret);
> -		if (!ret)
> -			port->auto_vbus_discharge_enabled = false;
> -	}
> +	tcpm_enable_auto_vbus_discharge(port, false);
>  	port->in_ams = false;
>  	port->ams = NONE_AMS;
>  	port->vdm_sm_running = false;
> @@ -3602,13 +3605,7 @@ static int tcpm_snk_attach(struct tcpm_port *port)
>  	if (ret < 0)
>  		return ret;
>  
> -	if (port->tcpc->enable_auto_vbus_discharge) {
> -		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
> -		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
> -		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> -		if (!ret)
> -			port->auto_vbus_discharge_enabled = true;
> -	}
> +	tcpm_enable_auto_vbus_discharge(port, true);
>  
>  	ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
>  	if (ret < 0)
> -- 
> 2.31.1.751.gd2f1c929bd-goog

-- 
heikki
