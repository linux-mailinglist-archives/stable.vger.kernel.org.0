Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4578249B005
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355269AbiAYJZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:25:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:12212 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1456817AbiAYJNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 04:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643101984; x=1674637984;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hPcnFwQ5EIleBYS17H6mw711aNUx7ZkEMpr7D4Wkijw=;
  b=adiD69KokN6cxOfHDI0hKZURYKj04JmfqyDvxJE4VnQeZYQOzNkExs4u
   btOaPfnEmuG2eS5uAyQnVxCvPMfUSf7yLB9mQiCH6sAFwVxc2oqXoPki6
   AUg31hU5s91fHIx2me7/UPLlEHIan5Oxp8fGcE/buBBzvquyMpK9YiwKH
   kEsbO8kAkLWsM9jwpd4DBRhHAvacUTKpdqxP9BS1PzEpus3uN11bkO1Qh
   TnbU+U1p0oDY7kEyVXSdcuX1qkzV0KT8wvGcF79EuXmLcps2e2uAS1dXE
   pd0bwcx74/X8kugy6/NJvSow4kWCF5oZI6SsrnMW8S+pONRXdIuvdPNJ6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="270703135"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="270703135"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 01:01:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="673927372"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 25 Jan 2022 01:01:48 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 25 Jan 2022 11:01:47 +0200
Date:   Tue, 25 Jan 2022 11:01:47 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] usb: typec: tcpm: Do not disconnect while
 receiving VBUS off
Message-ID: <Ye+8exwtqAqs4bNg@kuha.fi.intel.com>
References: <20220122015520.332507-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122015520.332507-1-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 05:55:19PM -0800, Badhri Jagan Sridharan wrote:
> With some chargers, vbus might momentarily raise above VSAFE5V and fall
> back to 0V before tcpm gets to read port->tcpc->get_vbus. This will
> will report a VBUS off event causing TCPM to transition to
> SNK_UNATTACHED where it should be waiting in either SNK_ATTACH_WAIT
> or SNK_DEBOUNCED state. This patch makes TCPM avoid vbus off events
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
> Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/tcpm/tcpm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 59d4fa2443f2..b8afe3d8c882 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5156,7 +5156,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
>  	case SNK_TRYWAIT_DEBOUNCE:
>  		break;
>  	case SNK_ATTACH_WAIT:
> -		tcpm_set_state(port, SNK_UNATTACHED, 0);
> +	case SNK_DEBOUNCED:
> +		/* Do nothing, as TCPM is still waiting for vbus to reaach VSAFE5V to connect */
>  		break;
>  
>  	case SNK_NEGOTIATE_CAPABILITIES:
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog

-- 
heikki
