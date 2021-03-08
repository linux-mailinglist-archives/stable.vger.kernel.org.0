Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5C1331607
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 19:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCHS2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 13:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhCHS2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 13:28:05 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028DEC06174A;
        Mon,  8 Mar 2021 10:28:05 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id r24so2053332otp.12;
        Mon, 08 Mar 2021 10:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZYeDqqz9KrmiEcAGJt+n9VTedd2rQHNdQORQqGYHMxE=;
        b=Wbe4xb7OkQgloKbgMu5V7fGmgMxtRdWlRSjAqgcnhVBRX5QJtmwBjcbezt9yRGLHJg
         MuzBbayZKZR7Bon5zUiq20BAXlgsp/mRg/AO9E/6dZP01MPutkme/N5tHsGKKQBGSuhc
         oL9wIgpXgPlgSYt4c84+/P+VA9euPJjOZAvE73vB8J+L/uUcV9f9O4DtszeHQ4wzq7Rn
         Md8hiZ2lPmXndpRScAYWiXwz9o/aRafhRxefo9PeKbrdK14wzBhTzZaS4DwTwVSrJ8DW
         /1uzwx9MvJMBw2OJQgAoYfvdwyKspW874Kbjc4RQoJUyODC5hErZ38MaOD7fJ20jbWg2
         G84Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZYeDqqz9KrmiEcAGJt+n9VTedd2rQHNdQORQqGYHMxE=;
        b=c7TfBhYUUm56wfwbiyJ6PdObzlS6QPEobEf1ntjk7CHB/LiVsJCbV4mggcXeF/Vpaj
         Zc2VAZKsqk6TFa6FF0HbxsR97OvW5sm1jmtbgAMD6fXTKO0XYxoqaB12uHSJ7vJ3Qh3O
         7ccsYV4zq9+4zh1qsnfKQz/Kubhs7Lme+H8Nm1Z6a+dgbjou0so+l7msIMzpTqHxLKFv
         TFHA8Hd3tgmvRQWASFlNO/hTQhpV+CaYvsCYMU9q5i9YC9b8rBqvaf5det0UtnAjohFj
         BgNwLkFTzjf+CK5Cgy/K5APiFats84wQ/T0rVBFJRqDRDJazQD/+r37wXwfNx/S8/3ok
         u7QQ==
X-Gm-Message-State: AOAM5338pKxvz72ERWuvC5drhk0mPFvTRd76QP06eDGguya7DVSMqDN7
        VpSzYOegUbwA2Ylr5B0wsJr4SPRRIFE=
X-Google-Smtp-Source: ABdhPJx6oU7X51l7s+KsY5TPRrP8STZHMX9TOtA9mNH/p7G+r6nwUxn9VGd8Stx4fego3ImFkm8bdQ==
X-Received: by 2002:a9d:1ca1:: with SMTP id l33mr19879167ota.368.1615228084433;
        Mon, 08 Mar 2021 10:28:04 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f29sm2901108ots.22.2021.03.08.10.28.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 10:28:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 8 Mar 2021 10:28:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpci: Check ROLE_CONTROL while
 interpreting CC_STATUS
Message-ID: <20210308182801.GA225316@roeck-us.net>
References: <20210304070931.1947316-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304070931.1947316-1-badhri@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 11:09:31PM -0800, Badhri Jagan Sridharan wrote:
> While interpreting CC_STATUS, ROLE_CONTROL has to be read to make
> sure that CC1/CC2 is not forced presenting Rp/Rd.
> 
> From the TCPCI spec:
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

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

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
> 
