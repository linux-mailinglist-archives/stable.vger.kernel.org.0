Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5153836AC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbhEQPfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243868AbhEQPcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:32:51 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88851C061D7B;
        Mon, 17 May 2021 07:33:39 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id l129so5888972qke.8;
        Mon, 17 May 2021 07:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zUXCcTEp7YgDsCm4wavnBcjzMoK/HrPuK8nQKcGbgCo=;
        b=qPCBzh0GmWdUhLuNrqQhIWBDLrP/67BEaN7/TsXh5PkHuwMPoL0sSedxXdb2D7HaMn
         AdKv01v9D6Ssz6/V+j/9QzX3JbHzD8U3o7mxpcvadPBJ3nLH5zbmZf6gErbtyvC4TnPN
         ZaI084jPUqg2BcwdVTuT7vDcNwekU3vKt5TWNM5V6KXxUK2OMD/ECrlJmPvYBMSR18Lv
         QF4yJyd1gdbFsuZ7runUCNXAp8m3xxMto8t4ofPDU+fbkhVd0wgdk43A97zXLlFVcm7X
         DHrYRSCTDZZLLLm/EYQErtiwcCnWUc1juAbdu1r3ZnjZ5NMInuLHK5DrO6zW/uoqgpbF
         A5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zUXCcTEp7YgDsCm4wavnBcjzMoK/HrPuK8nQKcGbgCo=;
        b=jYfmwdSHvmlp4cmrwq2Xalu5ke8ku4GFCX+TMlisZxx1iwqdc8KRUQf4hjtLizSqZK
         Ju4TS+IxiBQXu1onxR7lNmaM8P/vuK3Sc9lVikYHDJD0GhUNC0w/muRJiqSmdweFDnIz
         lciz4+JoEgKVIR0LltmudFYNQLdZsELH37eeOx+YC0RemqZIOl4N+rA2XBVGjpAbRWpJ
         WLyMWRtR5hH07Nwg3N0Hs6SeRoFx/eQF/SWxq6SHBaF58JT1jk48zCp0lvLBTLV1Kik0
         Ls1z4c7aKVzCeN3Ky2Zytr+oQJpjRG6JnP8lCCldu8yEfeOfCaMHBEDS685fNnkaM6gu
         QVgg==
X-Gm-Message-State: AOAM531jx2txbKTH0j2j0LVB/pFnZahy0sV1E9aMKa7gz27opt09XEAV
        Wpirofd+KaVj9we2aiMeCDk=
X-Google-Smtp-Source: ABdhPJw6UTnjiUdfEBPd4sgxIUurGaHSQiY1aMNdlH7ISej0ELzabQERSI9TXX1+cyo+PTp+mNHZsA==
X-Received: by 2002:a37:a546:: with SMTP id o67mr143883qke.160.1621262018752;
        Mon, 17 May 2021 07:33:38 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h65sm10601890qkd.112.2021.05.17.07.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:33:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 17 May 2021 07:33:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 2/4] usb: typec: tcpm: Refactor logic to
 enable/disable auto vbus dicharge
Message-ID: <20210517143336.GB3434992@roeck-us.net>
References: <20210515052613.3261340-1-badhri@google.com>
 <20210515052613.3261340-2-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515052613.3261340-2-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 10:26:11PM -0700, Badhri Jagan Sridharan wrote:
> The logic to enable vbus auto discharge on disconnect is used in
> more than one place. Since this is repetitive code, moving this into
> its own method.
> 
> Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto Discharge disconnect support")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

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
> 
