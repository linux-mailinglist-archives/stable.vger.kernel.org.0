Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3105A31FC76
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 16:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBSP5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 10:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBSP5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 10:57:22 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53C8C061574;
        Fri, 19 Feb 2021 07:56:40 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id 18so6265431oiz.7;
        Fri, 19 Feb 2021 07:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ykv8B79fr+v5PxIlwQX7Stv9lxJFAXd5n8YLdkAVi/c=;
        b=hs14c19qWjyzQUrbgpsJ7b1V232jGu4C5Catc08yJhHrzX0g2sGEDbyQUB19XbE1Xz
         zZyKDINBeUBScwDgpm8OKeBsAmjcEn3GxoS2U7CgAKrUCCtH7xKcwoSTZSQUHwdH3+ev
         Qwu4SCBWBo08SIL4Ow+4R46MYVklMsoSgN7KNE7NdryB9p/pnE1K0F/pMj7CTQWs2LsM
         YTjM25cZeW47s4oHKlaLovaA7GHewTd4qkR/M3NgUkLHsvvlQNggk9hIAorGlmxzZ5cu
         wmWAUbqlSH/ocoJ/+4RRPqGjlj5xhp8yPCD+Fvwu11AdUxJPihs3LyJ8qJna/CxvPaKC
         VVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ykv8B79fr+v5PxIlwQX7Stv9lxJFAXd5n8YLdkAVi/c=;
        b=Ai6KueK9ZigFYjD1fllfB4SKDvBa3yoJVnY6/iSUeePf7WrVsqHaK9PrHPd6l6Kyds
         afzp0jdlVxkMu3f4hcl5Ol2e+lA6rK8Az1KMKyC6yi1gozu+f9EGkjHUSg8xB39qLme/
         7gAeH6AIShkGfVrOkAa7FGbAUakm1N+ZP4FYMDYGl7fL8FYZUElVESUj9UMaGvvdHH5+
         8lTliLZJ2m7sfI5Q1xbFxFLiSUJNQ8LZuR3kUeeNEetWXrUsNlPy8z4vlXYOnV5mklRg
         +UnpHfDwE34oixhPpvRKJCMJX8QiZhXZss1t4+hu86PsFrNGB/wPjaoVQredEKZC1d/m
         L6aQ==
X-Gm-Message-State: AOAM531QI86TpU59EQWqzTWtYlnH4WTkGItKacXpZd+17/M2bBISVYW0
        PP19p57Uik148hIuf+VxtI2SVlx9a8A=
X-Google-Smtp-Source: ABdhPJxpKUREqULzXrt6SHkX64gdru6eWTZNsjy6pP2vPzEief1zbHzAtjElp9pFC/Zs0TAtugxyXQ==
X-Received: by 2002:a05:6808:10ca:: with SMTP id s10mr4455744ois.33.1613750199306;
        Fri, 19 Feb 2021 07:56:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o3sm1789047oou.47.2021.02.19.07.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 07:56:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v2] usb: typec: tcpm: Wait for vbus discharge to VSAFE0V
 before toggling
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyle Tso <kyletso@google.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210219090409.325492-1-badhri@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <c0fbb198-a905-cdd0-3c6e-6af484512a5b@roeck-us.net>
Date:   Fri, 19 Feb 2021 07:56:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210219090409.325492-1-badhri@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/19/21 1:04 AM, Badhri Jagan Sridharan wrote:
> When vbus auto discharge is enabled, TCPM can sometimes be faster than
> the TCPC i.e. TCPM can go ahead and move the port to unattached state
> (involves disabling vbus auto discharge) before TCPC could effectively
> discharge vbus to VSAFE0V. This leaves vbus with residual charge and
> increases the decay time which prevents tsafe0v from being met.
> This change introduces a new state VBUS_DISCHARGE where the TCPM waits
> for a maximum of tSafe0V(max) for vbus to discharge to VSAFE0V before
> transitioning to unattached state and re-enable toggling. If vbus
> discharges to vsafe0v sooner, then, transition to unattached state
> happens right away.
> 
> Also, while in SNK_READY, when auto discharge is enabled, drive
> disconnect based on vbus turning off instead of Rp disappearing on
> CC pins. Rp disappearing on CC pins is almost instanteous compared
> to vbus decay.
> 
> Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto
> Discharge disconnect support")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
> Changes since V1:
> - Add Fixes tag
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 60 +++++++++++++++++++++++++++++++----
>  1 file changed, 53 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index be0b6469dd3d..0ed71725980f 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -62,6 +62,8 @@
>  	S(SNK_TRANSITION_SINK_VBUS),		\
>  	S(SNK_READY),				\
>  						\
> +	S(VBUS_DISCHARGE),			\
> +						\
>  	S(ACC_UNATTACHED),			\
>  	S(DEBUG_ACC_ATTACHED),			\
>  	S(AUDIO_ACC_ATTACHED),			\
> @@ -438,6 +440,9 @@ struct tcpm_port {
>  	enum tcpm_ams next_ams;
>  	bool in_ams;
>  
> +	/* Auto vbus discharge state */
> +	bool auto_vbus_discharge_enabled;
> +
>  #ifdef CONFIG_DEBUG_FS
>  	struct dentry *dentry;
>  	struct mutex logbuffer_lock;	/* log buffer access lock */
> @@ -3413,6 +3418,8 @@ static int tcpm_src_attach(struct tcpm_port *port)
>  	if (port->tcpc->enable_auto_vbus_discharge) {
>  		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
>  		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> +		if (!ret)
> +			port->auto_vbus_discharge_enabled = true;
>  	}
>  
>  	ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
> @@ -3495,6 +3502,8 @@ static void tcpm_reset_port(struct tcpm_port *port)
>  	if (port->tcpc->enable_auto_vbus_discharge) {
>  		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, false);
>  		tcpm_log_force(port, "Disable vbus discharge ret:%d", ret);
> +		if (!ret)
> +			port->auto_vbus_discharge_enabled = false;
>  	}
>  	port->in_ams = false;
>  	port->ams = NONE_AMS;
> @@ -3568,6 +3577,8 @@ static int tcpm_snk_attach(struct tcpm_port *port)
>  		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
>  		ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
>  		tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> +		if (!ret)
> +			port->auto_vbus_discharge_enabled = true;
>  	}
>  
>  	ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
> @@ -3684,6 +3695,12 @@ static void run_state_machine(struct tcpm_port *port)
>  	switch (port->state) {
>  	case TOGGLING:
>  		break;
> +	case VBUS_DISCHARGE:
> +		if (port->port_type == TYPEC_PORT_SRC)
> +			tcpm_set_state(port, SRC_UNATTACHED, PD_T_SAFE_0V);
> +		else
> +			tcpm_set_state(port, SNK_UNATTACHED, PD_T_SAFE_0V);
> +		break;
>  	/* SRC states */
>  	case SRC_UNATTACHED:
>  		if (!port->non_pd_role_swap)
> @@ -4669,7 +4686,9 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
>  	case SRC_READY:
>  		if (tcpm_port_is_disconnected(port) ||
>  		    !tcpm_port_is_source(port)) {
> -			if (port->port_type == TYPEC_PORT_SRC)
> +			if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> +				tcpm_set_state(port, VBUS_DISCHARGE, 0);
> +			else if (port->port_type == TYPEC_PORT_SRC)
>  				tcpm_set_state(port, SRC_UNATTACHED, 0);
>  			else
>  				tcpm_set_state(port, SNK_UNATTACHED, 0);

Unless I am missing something, the new state is only used to set the
PD_T_SAFE_0V timeout. Is it really necessary/useful to add a new state
just for that, while keeping the rest of if/else statements ?
Personally I would prefer something like
			timeout = (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v) ? PD_T_SAFE_0V : 0;
			if (port->port_type == TYPEC_PORT_SRC)
				tcpm_set_state(port, SRC_UNATTACHED, timeout);
			else
				tcpm_set_state(port, SNK_UNATTACHED, timeout);

In this context, any idea why port_type==TYPEC_PORT_DRP results in
SNK_UNATTACHED state ? That seems a bit odd.

Guenter

> @@ -4703,7 +4722,18 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
>  			tcpm_set_state(port, SNK_DEBOUNCED, 0);
>  		break;
>  	case SNK_READY:
> -		if (tcpm_port_is_disconnected(port))
> +		/*
> +		 * When set_auto_vbus_discharge_threshold is enabled, CC pins go
> +		 * away before vbus decays to disconnect threshold. Allow
> +		 * disconnect to be driven by vbus disconnect when auto vbus
> +		 * discharge is enabled.
> +		 *
> +		 * EXIT condition is based primarily on vbus disconnect and CC is secondary.
> +		 * "A port that has entered into USB PD communications with the Source and
> +		 * has seen the CC voltage exceed vRd-USB may monitor the CC pin to detect
> +		 * cable disconnect in addition to monitoring VBUS.
> +		 */
> +		if (!port->auto_vbus_discharge_enabled && tcpm_port_is_disconnected(port))
>  			tcpm_set_state(port, unattached_state(port), 0);
>  		else if (!port->pd_capable &&
>  			 (cc1 != old_cc1 || cc2 != old_cc2))
> @@ -4803,9 +4833,16 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
>  		 */
>  		break;
>  
> +	case VBUS_DISCHARGE:
> +		/* Do nothing. Waiting for vsafe0v signal */
> +		break;
>  	default:
> -		if (tcpm_port_is_disconnected(port))
> -			tcpm_set_state(port, unattached_state(port), 0);
> +		if (tcpm_port_is_disconnected(port)) {
> +			if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> +				tcpm_set_state(port, VBUS_DISCHARGE, 0);
> +			else
> +				tcpm_set_state(port, unattached_state(port), 0);
> +		}
>  		break;
>  	}
>  }
> @@ -4988,9 +5025,12 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
>  		break;
>  
>  	default:
> -		if (port->pwr_role == TYPEC_SINK &&
> -		    port->attached)
> -			tcpm_set_state(port, SNK_UNATTACHED, 0);
> +		if (port->pwr_role == TYPEC_SINK && port->attached) {
> +			if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> +				tcpm_set_state(port, VBUS_DISCHARGE, 0);
> +			else
> +				tcpm_set_state(port, SNK_UNATTACHED, 0);
> +		}
>  		break;
>  	}
>  }
> @@ -5012,6 +5052,12 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
>  			tcpm_set_state(port, tcpm_try_snk(port) ? SNK_TRY : SRC_ATTACHED,
>  				       PD_T_CC_DEBOUNCE);
>  		break;
> +	case VBUS_DISCHARGE:
> +		if (port->port_type == TYPEC_PORT_SRC)
> +			tcpm_set_state(port, SRC_UNATTACHED, 0);
> +		else
> +			tcpm_set_state(port, SNK_UNATTACHED, 0);
> +		break;
>  	default:
>  		break;
>  	}
> 

