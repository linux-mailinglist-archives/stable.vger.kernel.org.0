Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449835E769D
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 11:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIWJQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 05:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiIWJQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 05:16:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7152D12E43B;
        Fri, 23 Sep 2022 02:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663924593; x=1695460593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HfmuNTF9PCvY3XjUF0ERD/w3l40lUTylJCwpgx7Bsdo=;
  b=PqFXmmGXPvHqcXBC5IEf1lnoIhDWnFBJ0W9hD4NNTucPatCV4boflG3a
   5fB+mEo4etJOBo1X7D0zZ9PlkvIJwB42rfHLh9oo54VpD4vBZZPZoO01O
   eQxzSYS6Im7+P9CDIjbn3xqqvzUuEkLoC1Xc/ZiK6uQ1pZ7FOklhZMNea
   n2Tq+Qg6xY/i6pBsg7f51Gcmax5hOezzcQrnewFjv/fhbJxPaZOHb0iVa
   QgAxyKERxUv2kHNIeYa4HONpMiA0B7Thr1YK2+04+fCDd+Ieo58m1Fa2D
   5CiGppF28q1joiFNerB61uGE/Ir/C8qJidpUkvdr6Tdx0PCAzkQTYD+K7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="300537200"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="300537200"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 02:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="865230721"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 23 Sep 2022 02:16:31 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id F3082F7; Fri, 23 Sep 2022 12:16:48 +0300 (EEST)
Date:   Fri, 23 Sep 2022 12:16:48 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mehta Sanju <Sanju.Mehta@amd.com>, stable@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Message-ID: <Yy15gKzHyMcitY/N@black.fi.intel.com>
References: <20220922160730.898-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922160730.898-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mario,

On Thu, Sep 22, 2022 at 11:07:29AM -0500, Mario Limonciello wrote:
> Software that has run before the USB4 CM in Linux runs may have disabled
> hotplug events for a given lane adapter.
> 
> Other CMs such as that one distributed with Windows 11 will enable hotplug
> events. Do the same thing in the Linux CM which fixes hotplug events on
> "AMD Pink Sardine".
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v1->v2:
>  * Only send second patch as first was merged already
>  * s/usb4_enable_hotplug/usb4_port_hotplug_enable/
>  * Clarify intended users in documentation comment
>  * Only call for lane adapters
>  * Add stable tag
> 
>  drivers/thunderbolt/switch.c  |  4 ++++
>  drivers/thunderbolt/tb.h      |  1 +
>  drivers/thunderbolt/tb_regs.h |  1 +
>  drivers/thunderbolt/usb4.c    | 20 ++++++++++++++++++++
>  4 files changed, 26 insertions(+)
> 
> diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
> index 77d7f07ca075..3213239d12c8 100644
> --- a/drivers/thunderbolt/switch.c
> +++ b/drivers/thunderbolt/switch.c
> @@ -778,6 +778,10 @@ static int tb_init_port(struct tb_port *port)
>  
>  			if (!tb_port_read(port, &hop, TB_CFG_HOPS, 0, 2))
>  				port->ctl_credits = hop.initial_credits;
> +
> +			res = usb4_port_hotplug_enable(port);
> +			if (res)

I think this does not belong here in tb_init_port(). This is called from
both FW and SW CM paths and we don't want to confuse the FW CM more than
necessary ;-)

So instead I think this should be added to tb_plug_events_active().

Otherwise looks good to me.

> +				return res;
>  		}
>  		if (!port->ctl_credits)
>  			port->ctl_credits = 2;
> diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
> index 5db76de40cc1..332159f984fc 100644
> --- a/drivers/thunderbolt/tb.h
> +++ b/drivers/thunderbolt/tb.h
> @@ -1174,6 +1174,7 @@ int usb4_switch_add_ports(struct tb_switch *sw);
>  void usb4_switch_remove_ports(struct tb_switch *sw);
>  
>  int usb4_port_unlock(struct tb_port *port);
> +int usb4_port_hotplug_enable(struct tb_port *port);
>  int usb4_port_configure(struct tb_port *port);
>  void usb4_port_unconfigure(struct tb_port *port);
>  int usb4_port_configure_xdomain(struct tb_port *port);
> diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
> index 166054110388..bbe38b2d9057 100644
> --- a/drivers/thunderbolt/tb_regs.h
> +++ b/drivers/thunderbolt/tb_regs.h
> @@ -308,6 +308,7 @@ struct tb_regs_port_header {
>  #define ADP_CS_5				0x05
>  #define ADP_CS_5_LCA_MASK			GENMASK(28, 22)
>  #define ADP_CS_5_LCA_SHIFT			22
> +#define ADP_CS_5_DHP				BIT(31)
>  
>  /* TMU adapter registers */
>  #define TMU_ADP_CS_3				0x03
> diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
> index 3a2e7126db9d..f0b5a8f1ed3a 100644
> --- a/drivers/thunderbolt/usb4.c
> +++ b/drivers/thunderbolt/usb4.c
> @@ -1046,6 +1046,26 @@ int usb4_port_unlock(struct tb_port *port)
>  	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
>  }
>  
> +/**
> + * usb4_port_hotplug_enable() - Enables hotplug for a port
> + * @port: USB4 port to operate on
> + *
> + * Enables hot plug events on a given port. This is only intended
> + * to be used on lane, DP-IN, and DP-OUT adapters.
> + */
> +int usb4_port_hotplug_enable(struct tb_port *port)
> +{
> +	int ret;
> +	u32 val;
> +
> +	ret = tb_port_read(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
> +	if (ret)
> +		return ret;
> +
> +	val &= ~ADP_CS_5_DHP;
> +	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_5, 1);
> +}
> +
>  static int usb4_port_set_configured(struct tb_port *port, bool configured)
>  {
>  	int ret;
> -- 
> 2.34.1
