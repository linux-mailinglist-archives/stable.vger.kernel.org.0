Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E62052F0D2
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 18:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351530AbiETQiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 12:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345218AbiETQiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 12:38:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99BC15EA48
        for <stable@vger.kernel.org>; Fri, 20 May 2022 09:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653064729; x=1684600729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=o9Dz7/gwxD4hO0Dpj5qn0MMbpCk4Nhb9DRdis4zrXWs=;
  b=X5+cuhMHot1rGSM4bPqyIoTPR4pL5Z038TCxnVljwSU0HXsMXQwFXUb9
   bA2pQaXY78CU4C0lmxXNn1teXP3hH52cIBpzi9zD2Y4+n5n+BUxnj9HsW
   pF/B4abnr6IJ+2+fW/g90MxnpWuURh/KKktLrN9olgifo2iBbU5S3j6p6
   xn5cG1kA5CLrBA4hQFym0jold6qUHveCpumhiBLV1GbYB5Xf6FgMdEYkO
   1sh99gxrSSkWs0ULU876bJ22+SYPPbEIAQRSd3ed9eKx2Go8oTzRF4X9e
   cirAXLT+OTc0xW8aBYFtU7+voOPwaEUX2A5a/qrn/oUHS0vRY2Rn6+7kc
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="260244520"
X-IronPort-AV: E=Sophos;i="5.91,239,1647327600"; 
   d="scan'208";a="260244520"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 09:38:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,239,1647327600"; 
   d="scan'208";a="557528998"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.163])
  by orsmga002.jf.intel.com with SMTP; 20 May 2022 09:38:46 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 20 May 2022 19:38:45 +0300
Date:   Fri, 20 May 2022 19:38:45 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/dsi: fix VBT send packet port selection for ICL+
Message-ID: <YofEFRffsOdEcfRO@intel.com>
References: <20220520094600.2066945-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520094600.2066945-1-jani.nikula@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 20, 2022 at 12:46:00PM +0300, Jani Nikula wrote:
> The VBT send packet port selection was never updated for ICL+ where the
> 2nd link is on port B instead of port C as in VLV+ DSI.
> 
> First, single link DSI needs to use the configured port instead of
> relying on the VBT sequence block port. Remove the hard-coded port C
> check here and make it generic. For reference, see commit f915084edc5a
> ("drm/i915: Changes related to the sequence port no for") for the
> original VLV specific fix.
> 
> Second, the sequence block port number is either 0 or 1, where 1
> indicates the 2nd link. Remove the hard-coded port C here for 2nd
> link. (This could be a "find second set bit" on DSI ports, but just
> check the two possible options.)
> 
> Third, sanity check the result with a warning to avoid a NULL pointer
> dereference.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5984
> Cc: stable@vger.kernel.org # v4.19+
> Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dsi_vbt.c | 33 +++++++++++++-------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
> index f370e9c4350d..dd24aef925f2 100644
> --- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
> +++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
> @@ -125,9 +125,25 @@ struct i2c_adapter_lookup {
>  #define  ICL_GPIO_DDPA_CTRLCLK_2	8
>  #define  ICL_GPIO_DDPA_CTRLDATA_2	9
>  
> -static enum port intel_dsi_seq_port_to_port(u8 port)
> +static enum port intel_dsi_seq_port_to_port(struct intel_dsi *intel_dsi,
> +					    u8 seq_port)
>  {
> -	return port ? PORT_C : PORT_A;
> +	/*
> +	 * If single link DSI is being used on any port, the VBT sequence block
> +	 * send packet apparently always has 0 for the port. Just use the port
> +	 * we have configured, and ignore the sequence block port.
> +	 */
> +	if (hweight8(intel_dsi->ports) == 1)
> +		return ffs(intel_dsi->ports) - 1;
> +
> +	if (seq_port) {
> +		if (intel_dsi->ports & PORT_B)
> +			return PORT_B;
> +		else if (intel_dsi->ports & PORT_C)
> +			return PORT_C;
> +	}
> +
> +	return PORT_A;

Hmm. I guess a bit more generic way to express that could be
to just pick the Nth set bit from intel_dsi->ports, where N==seq_port.
Assuming seq_port is just an index. But I guess we're not really
expecting to grow more DSI ports any time soon, so this seems
sufficient for the current situation.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

>  }
>  
>  static const u8 *mipi_exec_send_packet(struct intel_dsi *intel_dsi,
> @@ -149,15 +165,10 @@ static const u8 *mipi_exec_send_packet(struct intel_dsi *intel_dsi,
>  
>  	seq_port = (flags >> MIPI_PORT_SHIFT) & 3;
>  
> -	/* For DSI single link on Port A & C, the seq_port value which is
> -	 * parsed from Sequence Block#53 of VBT has been set to 0
> -	 * Now, read/write of packets for the DSI single link on Port A and
> -	 * Port C will based on the DVO port from VBT block 2.
> -	 */
> -	if (intel_dsi->ports == (1 << PORT_C))
> -		port = PORT_C;
> -	else
> -		port = intel_dsi_seq_port_to_port(seq_port);
> +	port = intel_dsi_seq_port_to_port(intel_dsi, seq_port);
> +
> +	if (drm_WARN_ON(&dev_priv->drm, !intel_dsi->dsi_hosts[port]))
> +		goto out;
>  
>  	dsi_device = intel_dsi->dsi_hosts[port]->device;
>  	if (!dsi_device) {
> -- 
> 2.30.2

-- 
Ville Syrjälä
Intel
