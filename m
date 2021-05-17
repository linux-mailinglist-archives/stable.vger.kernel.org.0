Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A618B383DE5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhEQT6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbhEQT6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:58:17 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78143C061573;
        Mon, 17 May 2021 12:56:59 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id k127so7039988qkc.6;
        Mon, 17 May 2021 12:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mv+UuGwx/I+xDoJHvzbkeTSAGHZzskp6kcl8GOvP2VY=;
        b=eSevaz58Az4Sdv1pdgXMZFwyR5/cM828oj8NiOUbpCt8PQOLHtxnfLoFoilxvUO0Vx
         Hs0SvTPyBkPZN2LGURDpcFOsRYkTLzoVdqskoLd3nqSoDjtpbAcoVCWEsgY8xhKOb8Uv
         j0AJQd/fvOlpNA4RpX/+lejFeGsZyoO7iIPYiksSHV5ZSkDU0uneanC1OTVSOltmrn3c
         fPBmN1Daka2Z33Sz/ZURzYvgMdtizu7FZ+/ZyXspyFG/F8cUgJfeQSxabWr/E6lGakXT
         /cPEx6odZ5VTdbYJ2qssy9LzxjgkGkggxP7demgYRyhP1jRFKP/I/0Z5h+qIhooKtgnX
         BscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mv+UuGwx/I+xDoJHvzbkeTSAGHZzskp6kcl8GOvP2VY=;
        b=L5ITtebLOHSKvLpPB5lZs+7Ao6zZKlQyEAVYhtrWsowC4Ihv8qBeBgj42qs+t0fXLK
         KcstfEg3bIu42/SvTGx4P/KKIdR1M4U3TRLfTIKpm+bxVCATt/EkeeiE14jmCTobjkP/
         KHCh8eAzf/27OnJSL/5cJ0gigXMkaP/Qy7iYozC/UyKaNt/xUpGrgUfgBevCQysv6vhV
         WTGBpZzX/vl8C2kSma4FQ2G0Sjb2MBejpAcUxuCC7wjkiTjCvpY3zVlgh9R4e0ql3aS+
         VkN9QAXCPP6W7+jbUWyvXl0MluY+a7QAw1OV1U8Qt+CJzJkAfF9eEVN0GyAAywuUKy9a
         1BRw==
X-Gm-Message-State: AOAM530+H0jHXP7xPO7e2qd8IvQCJmhdsKLApZHJrjYUeupU8FFNOnR0
        lVBIwd9iilei9rpEUQ0TsUA=
X-Google-Smtp-Source: ABdhPJwon3jZXf5+/H4DoK+pOjSca4iKzpJYBO3oeO05HVyRByWWsgJxO+XdgeLZIZ4hv31Cje0S+g==
X-Received: by 2002:a37:a506:: with SMTP id o6mr1600085qke.462.1621281418599;
        Mon, 17 May 2021 12:56:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r62sm3419021qkc.128.2021.05.17.12.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:56:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 17 May 2021 12:56:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] usb: typec: tcpm: Move TCPC to APPLY_RC state
 during PR_SWAP
Message-ID: <20210517195656.GA3619138@roeck-us.net>
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

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

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
> 
