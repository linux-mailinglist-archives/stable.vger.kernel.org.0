Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF6336DD2
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCKI1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:27:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:50994 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhCKI1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 03:27:32 -0500
IronPort-SDR: nsN+Jwgzo9vKGf/76IbnYy/VGzjLyTdQyVk0OXYFMI67YQUEVFEMVpDjYGCfhVAcFxQHZKf7CT
 IDUETTq4vEWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="175744168"
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="175744168"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 00:27:31 -0800
IronPort-SDR: pJTjStgHCnmv5a1kWffP+57JbDpIvmrdwDCAF6kvP/wMpFTNU3qOkaI8NObhjmdaZAjYTGEE8y
 xnriS9luJGow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="509955082"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 11 Mar 2021 00:27:28 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 11 Mar 2021 10:27:27 +0200
Date:   Thu, 11 Mar 2021 10:27:27 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpci: Refactor tcpc_presenting_cc1_rd
 macro
Message-ID: <YEnUb/hBh63Bql76@kuha.fi.intel.com>
References: <20210310223536.3471243-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310223536.3471243-1-badhri@google.com>
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

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

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

thanks,

-- 
heikki
