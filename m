Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9CA45D47D
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 07:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346562AbhKYGFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 01:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345878AbhKYGDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 01:03:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24FAE6108F;
        Thu, 25 Nov 2021 06:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637820025;
        bh=3ctKRzNkGfDKJL56FA56OZ8Yhk44PDb09vDAtnXuLAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bIQ0MHxqaQsVL5k7lRYiC3s76TtwMsSRV3bFb/vxi6rmDEbyA+NdeAfFDrFpVIfjF
         Mf5SlMoBcoTPs8xx5Y9t3fP3UpwiEHetgxYaKPFJjsj8EueEgtFVNURebt1e9LwrKc
         7t2PJOqdkVrlspfU5FdYcJtr1KHuU/irIfI/GXms=
Date:   Thu, 25 Nov 2021 07:00:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpm: Wait in SNK_DEBOUNCED until
 disconnect
Message-ID: <YZ8mdjPn39ekClLq@kroah.com>
References: <20211124224036.734679-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124224036.734679-1-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 02:40:36PM -0800, Badhri Jagan Sridharan wrote:
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
> Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 4 ----
>  1 file changed, 4 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
