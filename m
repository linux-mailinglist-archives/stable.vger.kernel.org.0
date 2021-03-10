Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD4A336831
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhCJXym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhCJXy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:54:26 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92371C061574;
        Wed, 10 Mar 2021 15:54:26 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id w195so14539623oif.11;
        Wed, 10 Mar 2021 15:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JuK/sN4ilqsFYnA0CHr8J6wR9fQZpX7FXlX6y+oCGXE=;
        b=kJd7FVEmctmtg1zxQTcC3h7PiO18ucOaPjAhDH4Qeye20ivrqEj31Cd7BRFgVx+YvY
         iR/0WZqMOnNBDh4rhbq5hBYc6lPPni0BHD6p8KSaJxVZ5fdpTodxYfriFPuvyNlNCyMD
         G4Co90qjHgNPwh8U4L/w9aQlU2jtCFBcAKoosSPR8W29qx3jADXmpaM7TNqWGwuuPL/W
         kyZp+V8C8JMgOhYs+/m8HEUUBtwPXgPmY5XzJApeTU7inl8n9CqMl9G/pfVvpJTEtPgi
         jmyX9qcPyWkcnmn8Y0FvBrqdjW1omVwVZYlKC0E5XyC9x5gW3C/oH3EmYTNaY/f347Ca
         dKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=JuK/sN4ilqsFYnA0CHr8J6wR9fQZpX7FXlX6y+oCGXE=;
        b=p+ayWGYV584ODQn7lgZsV58FU6/prFowIRxf4EBVyL8gG5G9x8h4/NjRsc3XCwjWcl
         tk94E/TB5I1Ixd9rKUiJbvTfqaL8bmAKyTMDdaLzL00KfgX1Nc7dcD7glskpeOJuDvMP
         GWyScCdxeMj7oCyajYALWcM3fRsVI69O2oSDaha0w/vbSlq1YqiDpd2+Uc8ra58hDfOC
         5+TKfHAh74zP83eOPtqlnX10kEtzoXKl8fk1EdAvIiTIgr7Agx6v9MVmuDIZoV0+n2tn
         rz71tzE6KTsYBeIhuM29Fo46vft0NY6j+aScRHcEiX6b1U7UCIBmKBIlncHU0tHL/RKf
         xjOQ==
X-Gm-Message-State: AOAM533qVtPeV44f9QuYdssweoEBXG1bIZa7N1qZqSh/Ocf9suS7SvnB
        5hUEDEP2xb1cp+2jrw8EoaU=
X-Google-Smtp-Source: ABdhPJxXn35OQUolMNep0R7ZJGDC3u+UhiWGWSaakVI/RUOJEzIcn8UDnoOwQKwNVgumUnd64HjqMw==
X-Received: by 2002:aca:4a95:: with SMTP id x143mr4162701oia.59.1615420466059;
        Wed, 10 Mar 2021 15:54:26 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y11sm181212oov.9.2021.03.10.15.54.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:54:25 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:54:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpci: Refactor tcpc_presenting_cc1_rd
 macro
Message-ID: <20210310235424.GH195769@roeck-us.net>
References: <20210310223536.3471243-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310223536.3471243-1-badhri@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:35:36PM -0800, Badhri Jagan Sridharan wrote:
> Defining one macro instead of two for tcpc_presenting_*_rd.
> This is a follow up of the comment left by Heikki Krogerus.
> 
> https://patchwork.kernel.org/project/linux-usb/patch/
> 20210304070931.1947316-1-badhri@google.com/
> 
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter

> ---
>  drivers/usb/typec/tcpm/tcpci.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index 027afd7dfdce..25b480752266 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -24,14 +24,10 @@
>  #define	AUTO_DISCHARGE_PD_HEADROOM_MV		850
>  #define	AUTO_DISCHARGE_PPS_HEADROOM_MV		1250
>  
> -#define tcpc_presenting_cc1_rd(reg) \
> +#define tcpc_presenting_rd(reg, cc) \
>  	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
> -	 (((reg) & (TCPC_ROLE_CTRL_CC1_MASK << TCPC_ROLE_CTRL_CC1_SHIFT)) == \
> -	  (TCPC_ROLE_CTRL_CC_RD << TCPC_ROLE_CTRL_CC1_SHIFT)))
> -#define tcpc_presenting_cc2_rd(reg) \
> -	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
> -	 (((reg) & (TCPC_ROLE_CTRL_CC2_MASK << TCPC_ROLE_CTRL_CC2_SHIFT)) == \
> -	  (TCPC_ROLE_CTRL_CC_RD << TCPC_ROLE_CTRL_CC2_SHIFT)))
> +	 (((reg) & (TCPC_ROLE_CTRL_## cc ##_MASK << TCPC_ROLE_CTRL_## cc ##_SHIFT)) == \
> +	  (TCPC_ROLE_CTRL_CC_RD << TCPC_ROLE_CTRL_## cc ##_SHIFT)))
>  
>  struct tcpci {
>  	struct device *dev;
> @@ -201,11 +197,11 @@ static int tcpci_get_cc(struct tcpc_dev *tcpc,
>  	*cc1 = tcpci_to_typec_cc((reg >> TCPC_CC_STATUS_CC1_SHIFT) &
>  				 TCPC_CC_STATUS_CC1_MASK,
>  				 reg & TCPC_CC_STATUS_TERM ||
> -				 tcpc_presenting_cc1_rd(role_control));
> +				 tcpc_presenting_rd(role_control, CC1));
>  	*cc2 = tcpci_to_typec_cc((reg >> TCPC_CC_STATUS_CC2_SHIFT) &
>  				 TCPC_CC_STATUS_CC2_MASK,
>  				 reg & TCPC_CC_STATUS_TERM ||
> -				 tcpc_presenting_cc2_rd(role_control));
> +				 tcpc_presenting_rd(role_control, CC2));
>  
>  	return 0;
>  }
> -- 
> 2.31.0.rc1.246.gcd05c9c855-goog
> 
