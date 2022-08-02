Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C265877CE
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 09:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiHBH3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 03:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiHBH27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 03:28:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFBC491C2;
        Tue,  2 Aug 2022 00:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659425338; x=1690961338;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MY1UeVCmTorLiElTkcmSLQfpDa7PBuZ+KvAyO3eFpnw=;
  b=b2WXikC4CPW209uc0F7t4IsWTHPKOw2su0cQKfAX/fVO8AEzH6H/Z9Gt
   Cw+M9C1XnqEbmg2zxwbvd/OMgfwyPXxlVRGzkFbChSJRB4vCwc1hPRbRb
   6h3SvddCPvRhbmTQv01Gpcjp6+Lpcs+6mNYah1X9qEE2YFeo4cMs+uFOK
   ZRsYr3uEFo1RNm2qFA855/q0SJvsSzNoFHU/DaZDNB5KafaV33eTTSHkA
   IikcTJyqODnTjaR7NkV1QWaGa5o5Il3RfM2rE8VlfrOAJgihvyDc84qpa
   XKTfvPnleyLhVEF7i9nhE3qTcHloRuV3sQhnhLKSxtI0zW98fSiznb9Ek
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="353348423"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="353348423"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:28:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="744573684"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 02 Aug 2022 00:28:53 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 02 Aug 2022 10:28:52 +0300
Date:   Tue, 2 Aug 2022 10:28:52 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: altmodes/displayport: correct pin assignment
 for UFP receptacles
Message-ID: <YujSNEGm2ikg3j8a@kuha.fi.intel.com>
References: <20220727110503.5260-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727110503.5260-1-macpaul.lin@mediatek.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi guys,

On Wed, Jul 27, 2022 at 07:05:03PM +0800, Macpaul Lin wrote:
> From: Pablo Sun <pablo.sun@mediatek.com>
> 
> From: Pablo Sun <pablo.sun@mediatek.com>

Looks like there's something wrong with the formating of the patch
here?

> Fix incorrect pin assignment values when connecting to a monitor with
> Type-C receptacle instead of a plug.
> 
> According to specification, an UFP_D receptacle's pin assignment
> should came from the UFP_D pin assignments field (bit 23:16), while
> an UFP_D plug's assignments are described in the DFP_D pin assignments
> (bit 15:8) during Mode Discovery.
> 
> For example the LG 27 UL850-W is a monitor with Type-C receptacle.
> The monitor responds to MODE DISCOVERY command with following
> DisplayPort Capability flag:
> 
>         dp->alt->vdo=0x140045
> 
> The existing logic only take cares of UPF_D plug case,
> and would take the bit 15:8 for this 0x140045 case.
> 
> This results in an non-existing pin assignment 0x0 in
> dp_altmode_configure.
> 
> To fix this problem a new set of macros are introduced
> to take plug/receptacle differences into consideration.
> 
> Co-developed-by: Pablo Sun <pablo.sun@mediatek.com>
> Signed-off-by: Pablo Sun <pablo.sun@mediatek.com>
> Co-developed-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Reviewed-by: Guillaume Ranquet <granquet@baylibre.com>
> Cc: stable@vger.kernel.org

If this is a fix, then you need to have the "Fixes" tag that tells
which commit the patch is fixing.

> ---
>  drivers/usb/typec/altmodes/displayport.c | 4 ++--
>  include/linux/usb/typec_dp.h             | 5 +++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
> index 9360ca177c7d..8dd0e505ef99 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -98,8 +98,8 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
>  	case DP_STATUS_CON_UFP_D:
>  	case DP_STATUS_CON_BOTH: /* NOTE: First acting as DP source */
>  		conf |= DP_CONF_UFP_U_AS_UFP_D;
> -		pin_assign = DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo) &
> -			     DP_CAP_UFP_D_PIN_ASSIGN(dp->port->vdo);
> +		pin_assign = DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo) &
> +				 DP_CAP_PIN_ASSIGN_DFP_D(dp->port->vdo);
>  		break;
>  	default:
>  		break;
> diff --git a/include/linux/usb/typec_dp.h b/include/linux/usb/typec_dp.h
> index cfb916cccd31..8d09c2f0a9b8 100644
> --- a/include/linux/usb/typec_dp.h
> +++ b/include/linux/usb/typec_dp.h
> @@ -73,6 +73,11 @@ enum {
>  #define DP_CAP_USB			BIT(7)
>  #define DP_CAP_DFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(15, 8)) >> 8)
>  #define DP_CAP_UFP_D_PIN_ASSIGN(_cap_)	(((_cap_) & GENMASK(23, 16)) >> 16)
> +/* Get pin assignment taking plug & receptacle into consideration */
> +#define DP_CAP_PIN_ASSIGN_UFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
> +			DP_CAP_UFP_D_PIN_ASSIGN(_cap_) : DP_CAP_DFP_D_PIN_ASSIGN(_cap_))
> +#define DP_CAP_PIN_ASSIGN_DFP_D(_cap_) ((_cap_ & DP_CAP_RECEPTACLE) ? \
> +			DP_CAP_DFP_D_PIN_ASSIGN(_cap_) : DP_CAP_UFP_D_PIN_ASSIGN(_cap_))
>  
>  /* DisplayPort Status Update VDO bits */
>  #define DP_STATUS_CONNECTION(_status_)	((_status_) & 3)
> -- 
> 2.18.0

thanks,

-- 
heikki
