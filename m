Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195673A9C42
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 15:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhFPNnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 09:43:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:6739 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhFPNnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 09:43:08 -0400
IronPort-SDR: cdU14Jz4ghW37p3YToV4VZ6GisTpFme2FHdyaZnZtrUiXn4Wy2093K/aXaJcDV8SkwqQmRREzE
 EQmp2IvMVgNg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="203154409"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="203154409"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 06:40:42 -0700
IronPort-SDR: Lt07RJrdxe5oOrfZmM+ZpHT4AIw0XB/Z9/g/TyrMb9KXvSXMSRmUpNkEjbqEWfdRgR1Xmgw7lu
 mCQBv1C0BtBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="scan'208";a="554809828"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 16 Jun 2021 06:40:39 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 16 Jun 2021 16:40:39 +0300
Date:   Wed, 16 Jun 2021 16:40:38 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpci: Fix up sink disconnect thresholds
 for PD
Message-ID: <YMn/Vu13ApE1t024@kuha.fi.intel.com>
References: <20210615174323.1160132-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615174323.1160132-1-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 10:43:23AM -0700, Badhri Jagan Sridharan wrote:
> "Table 4-3 VBUS Sink Characteristics" of "Type-C Cable and Connector
> Specification" defines the disconnect voltage thresholds of various
> configurations. This change fixes the disconnect threshold voltage
> calculation based on vSinkPD_min and vSinkDisconnectPD as defined
> by the table.
> 
> Fixes: e1a97bf80a022 ("usb: typec: tcpci: Implement Auto discharge disconnect callbacks")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/tcpm/tcpci.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index 22862345d1ab..9858716698df 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -21,8 +21,12 @@
>  #define	PD_RETRY_COUNT_DEFAULT			3
>  #define	PD_RETRY_COUNT_3_0_OR_HIGHER		2
>  #define	AUTO_DISCHARGE_DEFAULT_THRESHOLD_MV	3500
> -#define	AUTO_DISCHARGE_PD_HEADROOM_MV		850
> -#define	AUTO_DISCHARGE_PPS_HEADROOM_MV		1250
> +#define	VSINKPD_MIN_IR_DROP_MV			750
> +#define	VSRC_NEW_MIN_PERCENT			95
> +#define	VSRC_VALID_MIN_MV			500
> +#define	VPPS_NEW_MIN_PERCENT			95
> +#define	VPPS_VALID_MIN_MV			100
> +#define	VSINKDISCONNECT_PD_MIN_PERCENT		90
>  
>  #define tcpc_presenting_rd(reg, cc) \
>  	(!(TCPC_ROLE_CTRL_DRP & (reg)) && \
> @@ -351,11 +355,13 @@ static int tcpci_set_auto_vbus_discharge_threshold(struct tcpc_dev *dev, enum ty
>  		threshold = AUTO_DISCHARGE_DEFAULT_THRESHOLD_MV;
>  	} else if (mode == TYPEC_PWR_MODE_PD) {
>  		if (pps_active)
> -			threshold = (95 * requested_vbus_voltage_mv / 100) -
> -				AUTO_DISCHARGE_PD_HEADROOM_MV;
> +			threshold = ((VPPS_NEW_MIN_PERCENT * requested_vbus_voltage_mv / 100) -
> +				     VSINKPD_MIN_IR_DROP_MV - VPPS_VALID_MIN_MV) *
> +				     VSINKDISCONNECT_PD_MIN_PERCENT / 100;
>  		else
> -			threshold = (95 * requested_vbus_voltage_mv / 100) -
> -				AUTO_DISCHARGE_PPS_HEADROOM_MV;
> +			threshold = ((VSRC_NEW_MIN_PERCENT * requested_vbus_voltage_mv / 100) -
> +				     VSINKPD_MIN_IR_DROP_MV - VSRC_VALID_MIN_MV) *
> +				     VSINKDISCONNECT_PD_MIN_PERCENT / 100;
>  	} else {
>  		/* 3.5V for non-pd sink */
>  		threshold = AUTO_DISCHARGE_DEFAULT_THRESHOLD_MV;
> -- 
> 2.32.0.272.g935e593368-goog

-- 
heikki
