Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B285A38382F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240312AbhEQPui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244029AbhEQPqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:46:25 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B1EC06129F;
        Mon, 17 May 2021 07:37:19 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id v4so4993809qtp.1;
        Mon, 17 May 2021 07:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bWeAu9wBo7kEhJ8ZStrR0ZAYvo5nI5VtERiHciMCBA8=;
        b=NdVhL73umarpt9VVRmR6S6XJmePnn8ZpCs6bdZb345TVyDE6JW+DAF1vwN/GrxWK4O
         n/Dw9moK5NVPhWuEfVaKyi2fV5y96Diz4WCjOZEelVGaZXORELzDPbad168GBH6uYgaT
         R/DGNg7+47WGYFRFNsFmA7fWJuRcgfEVer4IXebeYU20E7MM9GH6PevzPjhEdJb/0y/q
         SK8OhSTpMvo93zkISg5kY1CXDb+LBanCUfoBT9RPZvi4ZK/XK3LT+ksQX0GuTe2eoVfA
         ZRFwmd7u72oI0EYGo56FmrZmIzh8hFw2EXpRyDOitKpqgj+0x2nq8v6jWl73fOdtwI7d
         QcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bWeAu9wBo7kEhJ8ZStrR0ZAYvo5nI5VtERiHciMCBA8=;
        b=gug3TVx44c8nDYeUo5nDKSvti1+ykOFWxxxvKLB3NAVnr32TjfKSomW+kUX+peRGOu
         gZuGcHBtcmcIUYU45do7I/024y8v/XIwNKwPpRCwAlaaxvqrFIXnB2oBZ2+TqeCZUp9C
         7QnpEvJ7/RASvoWW93C9IHnjqfxaBdXONecQNkrJytEQmeeCYbYYjqNTJnOxXZG1lqXf
         wirwD1u06zRdIAroIQY55yrihxuvz9oqEmFh6eMpoCXX7Ebmxp6gUPHY83SyGKpIEkv5
         fmtpFQB9wmhumVu/4czZWkZsPjTz2a/W3pwCTR8yqfoJy3oLUqCAAgbpzW7DJ1Fr4Qck
         8ndw==
X-Gm-Message-State: AOAM532xvpv2wTMmR3x4FKwwBPAO+YAwOv3YgDhfdhCgnQtG2utNILdt
        7vHFOerHfZymZgnfCnbe/nACFenlLBY=
X-Google-Smtp-Source: ABdhPJy7AKPheNgCfhXoaNmTgZV/adbyZtCzhr9tt1LxBv4uvXvG01pLehadn3xQND6GJG0fWq5VBA==
X-Received: by 2002:ac8:7ed2:: with SMTP id x18mr57448266qtj.26.1621262237924;
        Mon, 17 May 2021 07:37:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y1sm10228992qkp.21.2021.05.17.07.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 07:37:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v1 3/4] usb: typec: tcpm: Move TCPC to APPLY_RC state
 during PR_SWAP
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
References: <20210515052613.3261340-1-badhri@google.com>
 <20210515052613.3261340-3-badhri@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <752b5b58-03a4-7f53-adc5-97d2aa2d6784@roeck-us.net>
Date:   Mon, 17 May 2021 07:37:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210515052613.3261340-3-badhri@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/14/21 10:26 PM, Badhri Jagan Sridharan wrote:
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
> ---
>   drivers/usb/typec/tcpm/tcpm.c | 16 ++++++++++++++++
>   include/linux/usb/tcpm.h      |  4 ++++
>   2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index b475d9b9d38d..5bac4978efb3 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -786,6 +786,19 @@ static int tcpm_enable_auto_vbus_discharge(struct tcpm_port *port, bool enable)
>   	return ret;
>   }
>   
> +static void tcpm_apply_rc(struct tcpm_port *port)
> +{
> +	/*
> +	 * TCPCI: Move to APPLY_RC state to prevent disconnect during PR_SWAP
> +	 * when Vbus auto discharge on disconnect is enabled.
> +	 */
> +	if (port->tcpc->enable_auto_vbus_discharge) {
> +		tcpm_log(port, "Apply_RC");
> +		port->tcpc->apply_rc(port->tcpc, port->cc_req, port->polarity);

This is called unconditionally. I think you'll need an additional
		&& port->tcpc->apply_rc
in the if statement above.

> +		tcpm_enable_auto_vbus_discharge(port, false);
> +	}
> +}
> +
>   /*
>    * Determine RP value to set based on maximum current supported
>    * by a port if configured as source.
> @@ -4428,6 +4441,7 @@ static void run_state_machine(struct tcpm_port *port)
>   		tcpm_set_state(port, ready_state(port), 0);
>   		break;
>   	case PR_SWAP_START:
> +		tcpm_apply_rc(port);
>   		if (port->pwr_role == TYPEC_SOURCE)
>   			tcpm_set_state(port, PR_SWAP_SRC_SNK_TRANSITION_OFF,
>   				       PD_T_SRC_TRANSITION);
> @@ -4467,6 +4481,7 @@ static void run_state_machine(struct tcpm_port *port)
>   		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_ON_PRS);
>   		break;
>   	case PR_SWAP_SRC_SNK_SINK_ON:
> +		tcpm_enable_auto_vbus_discharge(port, true);
>   		/* Set the vbus disconnect threshold for implicit contract */
>   		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
>   		tcpm_set_state(port, SNK_STARTUP, 0);
> @@ -4483,6 +4498,7 @@ static void run_state_machine(struct tcpm_port *port)
>   			       PD_T_PS_SOURCE_OFF);
>   		break;
>   	case PR_SWAP_SNK_SRC_SOURCE_ON:
> +		tcpm_enable_auto_vbus_discharge(port, true);
>   		tcpm_set_cc(port, tcpm_rp_cc(port));
>   		tcpm_set_vbus(port, true);
>   		/*
> diff --git a/include/linux/usb/tcpm.h b/include/linux/usb/tcpm.h
> index 42fcfbe10590..bffc8d3e14ad 100644
> --- a/include/linux/usb/tcpm.h
> +++ b/include/linux/usb/tcpm.h
> @@ -66,6 +66,8 @@ enum tcpm_transmit_type {
>    *		For example, some tcpcs may include BC1.2 charger detection
>    *		and use that in this case.
>    * @set_cc:	Called to set value of CC pins
> + * @apply_rc:	Optional; Needed to move TCPCI based chipset to APPLY_RC state
> + *		as stated by the TCPCI specification.
>    * @get_cc:	Called to read current CC pin values
>    * @set_polarity:
>    *		Called to set polarity
> @@ -120,6 +122,8 @@ struct tcpc_dev {
>   	int (*get_vbus)(struct tcpc_dev *dev);
>   	int (*get_current_limit)(struct tcpc_dev *dev);
>   	int (*set_cc)(struct tcpc_dev *dev, enum typec_cc_status cc);
> +	int (*apply_rc)(struct tcpc_dev *dev, enum typec_cc_status cc,
> +			enum typec_cc_polarity polarity);
>   	int (*get_cc)(struct tcpc_dev *dev, enum typec_cc_status *cc1,
>   		      enum typec_cc_status *cc2);
>   	int (*set_polarity)(struct tcpc_dev *dev,
> 

