Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C856D17D6
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 08:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjCaGxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 02:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCaGxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 02:53:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BDD171E;
        Thu, 30 Mar 2023 23:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680245591; x=1711781591;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R+AJz0WdWGL1LWdc8q+nVGj5eIhBLWtb4iQl8vjevik=;
  b=WM6Nxy9pSwBFyd0oRmzAVzhx9bHeQMj0Zj+Lt0N0hDhQur5YT0zo0Owr
   DIAf6z9DjjOjgDE1+WTwfFLPlMjFTkrU+tFd9fy6Q2sQO6sBXW6UjVhFW
   9xGW9p9XcAerZBf+J0OxA+HCaRPf6YQtdIOgtdxKeh5RoDwCAwXD/b9kZ
   xLb6g9Cw4iOWhEwvGUNLNgCMbBYHP8SDdG9t05786I7mca4f4xA4gL1n9
   K8Q1dLT2bkwhdJqrCruP6qvKv1sgSmaSAqi2QioIGE/j8LtDZUKq41KFI
   i+ZK7vfPp46yzoax3fO7t8wYshMMV/9xc65hU2kfQZrVGI6j4CbHRBEmz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="369167450"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="369167450"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 23:53:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="828605299"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="828605299"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 30 Mar 2023 23:53:08 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Fri, 31 Mar 2023 09:53:08 +0300
Date:   Fri, 31 Mar 2023 09:53:08 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     RD Babiera <rdbabiera@google.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: altmodes/displayport: Fix configure
 initial pin assignment
Message-ID: <ZCaDVAH7oszQRMIZ@kuha.fi.intel.com>
References: <20230329215159.2046932-1-rdbabiera@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329215159.2046932-1-rdbabiera@google.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 09:51:59PM +0000, RD Babiera wrote:
> While determining the initial pin assignment to be sent in the configure
> message, using the DP_PIN_ASSIGN_DP_ONLY_MASK mask causes the DFP_U to
> send both Pin Assignment C and E when both are supported by the DFP_U and
> UFP_U. The spec (Table 5-7 DFP_U Pin Assignment Selection Mandates,
> VESA DisplayPort Alt Mode Standard v2.0) indicates that the DFP_U never
> selects Pin Assignment E when Pin Assignment C is offered.
> 
> Update the DP_PIN_ASSIGN_DP_ONLY_MASK conditional to intially select only
> Pin Assignment C if it is available.
> 
> Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: RD Babiera <rdbabiera@google.com>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/altmodes/displayport.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
> index 662cd043b50e..8f3e884222ad 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -112,8 +112,12 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
>  		if (dp->data.status & DP_STATUS_PREFER_MULTI_FUNC &&
>  		    pin_assign & DP_PIN_ASSIGN_MULTI_FUNC_MASK)
>  			pin_assign &= DP_PIN_ASSIGN_MULTI_FUNC_MASK;
> -		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK)
> +		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK) {
>  			pin_assign &= DP_PIN_ASSIGN_DP_ONLY_MASK;
> +			/* Default to pin assign C if available */
> +			if (pin_assign & BIT(DP_PIN_ASSIGN_C))
> +				pin_assign = BIT(DP_PIN_ASSIGN_C);
> +		}
>  
>  		if (!pin_assign)
>  			return -EINVAL;
> 
> base-commit: 97318d6427f62b723c89f4150f8f48126ef74961
> -- 
> 2.40.0.348.gf938b09366-goog

-- 
heikki
