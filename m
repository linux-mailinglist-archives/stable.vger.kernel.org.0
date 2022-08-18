Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47C0597FAE
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 10:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243986AbiHRIA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 04:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243928AbiHRIA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 04:00:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB23BAEDA7;
        Thu, 18 Aug 2022 01:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660809656; x=1692345656;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eAy8aSdTk5OKQzWybqKrFUdpqxDntwotIfbfSmRhmTA=;
  b=g5eQIHXjIB9t2q0ujnBvPrbIkft1sS5QTKuqQowNKbHzZ2jdd/mvn0i8
   g66pwiRsU4n4KgRGxyU+UlUAMxUt0X4vR1OAg6VR0lYfKYqWBNyHJa6B1
   LAIM9Qfa2wggmTiYL5okJzYkYcNw4isRk4i0v9Q0peBBjjMvhiZskRiS8
   6QQ/fu3bQzbt1eZacX0teZvq3x4lIscdbJDePBP0RM7diSTUV5v8RvSyj
   ov16n9F93IwtVnyv8Uq70YiXBo6UU+uPiqGsaQErR2KlMrkdoAmLkHZz7
   yNVfAKDe/vOdKT+RkJW+hYv0zz6XJ+1b58NTAstuK3ctAhpZJofsgQJQU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="292692798"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="292692798"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 01:00:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="750014755"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 18 Aug 2022 01:00:40 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 18 Aug 2022 11:00:40 +0300
Date:   Thu, 18 Aug 2022 11:00:40 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] usb: typec: tcpm: Return ENOTSUPP for power supply
 prop writes
Message-ID: <Yv3xqCCmIeSnsQDz@kuha.fi.intel.com>
References: <20220817215410.1807477-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817215410.1807477-1-badhri@google.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 02:54:10PM -0700, Badhri Jagan Sridharan wrote:
> When the port does not support USB PD, prevent transition to PD
> only states when power supply property is written. In this case,
> TCPM transitions to SNK_NEGOTIATE_CAPABILITIES
> which should not be the case given that the port is not pd_capable.
> 
> [   84.308251] state change SNK_READY -> SNK_NEGOTIATE_CAPABILITIES [rev3 NONE_AMS]
> [   84.308335] Setting usb_comm capable false
> [   84.323367] set_auto_vbus_discharge_threshold mode:3 pps_active:n vbus:5000 ret:0
> [   84.323376] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_WAIT_CAPABILITIES [rev3 NONE_AMS]
> 
> Fixes: e9e6e164ed8f6 ("usb: typec: tcpm: Support non-PD mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> Changes since v1:
> - Add Fixes tag.
> Changes since v2:
> - CCed stable
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index ea5a917c51b1..904c7b4ce2f0 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -6320,6 +6320,13 @@ static int tcpm_psy_set_prop(struct power_supply *psy,
>  	struct tcpm_port *port = power_supply_get_drvdata(psy);
>  	int ret;
>  
> +	/*
> +	 * All the properties below are related to USB PD. The check needs to be
> +	 * property specific when a non-pd related property is added.
> +	 */
> +	if (!port->pd_supported)
> +		return -EOPNOTSUPP;
> +
>  	switch (psp) {
>  	case POWER_SUPPLY_PROP_ONLINE:
>  		ret = tcpm_psy_set_online(port, val);
> -- 
> 2.37.1.595.g718a3a8f04-goog

-- 
heikki
