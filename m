Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967DB49B00B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346236AbiAYJZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:25:37 -0500
Received: from mga05.intel.com ([192.55.52.43]:4621 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1455982AbiAYJH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 04:07:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643101677; x=1674637677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EXHV5EA/AYibvFLmGk7sya8bHLZVSKVgJE8RlOP/3M4=;
  b=d+Oohpr4xoZ7nJb3hdJ5XGCckgXHLVCVpNvpJQstOIXCcXO2tuYV6ux/
   FvdxkHFqqeRWDU+fmMqcBaXvg1gFaowSepMeflWsEmp6qQ0/eE4nph6vi
   /9sjQq0CUhdTEzXYszc5KSKQTj+LmX5gSicEIYV2dIG4L6/KbFFToENOn
   I8UyXKUPXhcZG6Ry8SlPQTPllx0sTKzR5xFhZgLqyTa8+ya+Q0MRfVEu/
   cBce8rRe3g7nLFpwBic8JcjmQJVvborErJ6qoA+yGA3937HCkoueQaqet
   8B+y/ReOHolUQPWl8nVdAmV22/WsxPCaJTa5sMJAVeSOxgWEDz0wPo9DD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="332613043"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="332613043"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:02:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="673927566"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 25 Jan 2022 01:02:26 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 25 Jan 2022 11:02:25 +0200
Date:   Tue, 25 Jan 2022 11:02:25 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] usb: typec: tcpm: Do not disconnect when
 receiving VSAFE0V
Message-ID: <Ye+8oRlfz8HS2fsB@kuha.fi.intel.com>
References: <20220122015520.332507-1-badhri@google.com>
 <20220122015520.332507-2-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122015520.332507-2-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 05:55:20PM -0800, Badhri Jagan Sridharan wrote:
> With some chargers, vbus might momentarily raise above VSAFE5V and fall
> back to 0V causing VSAFE0V to be triggered. This will
> will report a VBUS off event causing TCPM to transition to
> SNK_UNATTACHED state where it should be waiting in either SNK_ATTACH_WAIT
> or SNK_DEBOUNCED state. This patch makes TCPM avoid VSAFE0V events
> while in SNK_ATTACH_WAIT or SNK_DEBOUNCED state.
> 
> Stub from the spec:
>     "4.5.2.2.4.2 Exiting from AttachWait.SNK State
>     A Sink shall transition to Unattached.SNK when the state of both
>     the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
>     A DRP shall transition to Unattached.SRC when the state of both
>     the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."
> 
> [23.194131] CC1: 0 -> 0, CC2: 0 -> 5 [state SNK_UNATTACHED, polarity 0, connected]
> [23.201777] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
> [23.209949] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev3 NONE_AMS]
> [23.300579] VBUS off
> [23.300668] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [rev3 NONE_AMS]
> [23.301014] VBUS VSAFE0V
> [23.301111] Start toggling
> 
> Fixes: 28b43d3d746b8 ("usb: typec: tcpm: Introduce vsafe0v for vbus")
> Cc: stable@vger.kernel.org
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/tcpm/tcpm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index b8afe3d8c882..5fce795b69c7 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5264,6 +5264,10 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
>  	case PR_SWAP_SNK_SRC_SOURCE_ON:
>  		/* Do nothing, vsafe0v is expected during transition */
>  		break;
> +	case SNK_ATTACH_WAIT:
> +	case SNK_DEBOUNCED:
> +		/*Do nothing, still waiting for VSAFE5V for connect */
> +		break;
>  	default:
>  		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
>  			tcpm_set_state(port, SNK_UNATTACHED, 0);
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog

-- 
heikki
