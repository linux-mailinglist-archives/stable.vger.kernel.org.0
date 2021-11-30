Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24FD4631A6
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 11:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhK3K7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 05:59:31 -0500
Received: from mga14.intel.com ([192.55.52.115]:60349 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236505AbhK3K7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 05:59:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="236420346"
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="236420346"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 02:56:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="654117467"
Received: from kuha.fi.intel.com ([10.237.72.166])
  by fmsmga001.fm.intel.com with SMTP; 30 Nov 2021 02:56:07 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 30 Nov 2021 12:56:06 +0200
Date:   Tue, 30 Nov 2021 12:56:06 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: typec: tcpm: Wait in SNK_DEBOUNCED until
 disconnect
Message-ID: <YaYDRs0uvliAwTJZ@kuha.fi.intel.com>
References: <20211130001825.3142830-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130001825.3142830-1-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 04:18:25PM -0800, Badhri Jagan Sridharan wrote:
> Stub from the spec:
> "4.5.2.2.4.2 Exiting from AttachWait.SNK State
> A Sink shall transition to Unattached.SNK when the state of both
> the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
> A DRP shall transition to Unattached.SRC when the state of both
> the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."
> 
> This change makes TCPM to wait in SNK_DEBOUNCED state until
> CC1 and CC2 pins is SNK.Open for at least tPDDebounce. Previously,
> TCPM resets the port if vbus is not present in PD_T_PS_SOURCE_ON.
> This causes TCPM to loop continuously when connected to a
> faulty power source that does not present vbus. Waiting in
> SNK_DEBOUNCED also ensures that TCPM is adherant to
> "4.5.2.2.4.2 Exiting from AttachWait.SNK State" requirements.
> 
> [ 6169.280751] CC1: 0 -> 0, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
> [ 6169.280759] state change TOGGLING -> SNK_ATTACH_WAIT [rev2 NONE_AMS]
> [ 6169.280771] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev2 NONE_AMS]
> [ 6169.282427] CC1: 0 -> 0, CC2: 5 -> 5 [state SNK_ATTACH_WAIT, polarity 0, connected]
> [ 6169.450825] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 170 ms]
> [ 6169.450834] pending state change SNK_DEBOUNCED -> PORT_RESET @ 480 ms [rev2 NONE_AMS]
> [ 6169.930892] state change SNK_DEBOUNCED -> PORT_RESET [delayed 480 ms]
> [ 6169.931296] disable vbus discharge ret:0
> [ 6169.931301] Setting usb_comm capable false
> [ 6169.932783] Setting voltage/current limit 0 mV 0 mA
> [ 6169.932802] polarity 0
> [ 6169.933706] Requesting mux state 0, usb-role 0, orientation 0
> [ 6169.936689] cc:=0
> [ 6169.936812] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev2 NONE_AMS]
> [ 6169.937157] CC1: 0 -> 0, CC2: 5 -> 0 [state PORT_RESET, polarity 0, disconnected]
> [ 6170.036880] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
> [ 6170.036890] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev2 NONE_AMS]
> [ 6170.036896] Start toggling
> [ 6170.041412] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, disconnected]
> [ 6170.042973] CC1: 0 -> 0, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
> [ 6170.042976] state change TOGGLING -> SNK_ATTACH_WAIT [rev2 NONE_AMS]
> [ 6170.042981] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev2 NONE_AMS]
> [ 6170.213014] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 170 ms]
> [ 6170.213019] pending state change SNK_DEBOUNCED -> PORT_RESET @ 480 ms [rev2 NONE_AMS]
> [ 6170.693068] state change SNK_DEBOUNCED -> PORT_RESET [delayed 480 ms]
> [ 6170.693304] disable vbus discharge ret:0
> [ 6170.693308] Setting usb_comm capable false
> [ 6170.695193] Setting voltage/current limit 0 mV 0 mA
> [ 6170.695210] polarity 0
> [ 6170.695990] Requesting mux state 0, usb-role 0, orientation 0
> [ 6170.701896] cc:=0
> [ 6170.702181] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev2 NONE_AMS]
> [ 6170.703343] CC1: 0 -> 0, CC2: 5 -> 0 [state PORT_RESET, polarity 0, disconnected]
> 
> Cc: stable@vger.kernel.org
> Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/tcpm/tcpm.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 7f2f3ff1b391..6010b9901126 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -4110,11 +4110,7 @@ static void run_state_machine(struct tcpm_port *port)
>  				       tcpm_try_src(port) ? SRC_TRY
>  							  : SNK_ATTACHED,
>  				       0);
> -		else
> -			/* Wait for VBUS, but not forever */
> -			tcpm_set_state(port, PORT_RESET, PD_T_PS_SOURCE_ON);
>  		break;
> -
>  	case SRC_TRY:
>  		port->try_src_count++;
>  		tcpm_set_cc(port, tcpm_rp_cc(port));
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog

-- 
heikki
