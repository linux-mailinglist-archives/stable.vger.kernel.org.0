Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D37848C2D0
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 12:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbiALLGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 06:06:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:12357 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352721AbiALLGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 06:06:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641985563; x=1673521563;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VuPOLmrsF8cSs6FEO/+gfqFlm4i8tVhcHrfju4W9VSk=;
  b=atkP1DH3haQP44taRdIMAw1kQOThPAqdOOdnICw5CmLPwGl/vAroUNWj
   NVnl4UtdkGcPvwynkRUMD8HFCfUEsfShkVKSoQqDnpy5eDuPP43D2GMXV
   UTeoWiBIUpxG2r9LQr7A/VZbHasim5rHOZKhkNzbwTA5vFw1fp3lhfStm
   /GvcE95JHwrJoL/kgqv3vZsW0Rt7YqteiWbey6tHgtifc4WE+pEjcb1mr
   pgFMxYQ3sam2+s6DmnZtp+TeMsce2kRgTouF9xY5Jy6kkBMJsEkwH/Kbm
   D62U2cIs3EbhBJ2JuRlR39+z7n2phkaAH3zuIexSHEQZOMuO+3rZxMPeb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="243666479"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="243666479"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 03:05:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="670116996"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 12 Jan 2022 03:05:38 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 12 Jan 2022 13:05:37 +0200
Date:   Wed, 12 Jan 2022 13:05:37 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Wayne Chang <waynec@nvidia.com>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, singhanc@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/1] ucsi_ccg: Check DEV_INT bit only when starting
 CCG4
Message-ID: <Yd62AVTwH2pGgk4y@kuha.fi.intel.com>
References: <20220112094143.628610-1-waynec@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112094143.628610-1-waynec@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 05:41:43PM +0800, Wayne Chang wrote:
> From: Sing-Han Chen <singhanc@nvidia.com>
> 
> CCGx clears Bit 0:Device Interrupt in the INTR_REG
> if CCGx is reset successfully. However, there might
> be a chance that other bits in INTR_REG are not
> cleared due to internal data queued in PPM. This case
> misleads the driver that CCGx reset failed.
> 
> The commit checks bit 0 in INTR_REG and ignores other
> bits. The ucsi driver would reset PPM later.
> 
> Fixes: 247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sing-Han Chen <singhanc@nvidia.com>
> Signed-off-by: Wayne Chang <waynec@nvidia.com>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> V4 -> V5: Added Cc tag and revised the commit messages
> V3 -> V4: Updated the Fixes tag
> V2 -> V3: Added the Fixes tag
> V1 -> V2: Fixed the name of Sign-off-by
>  drivers/usb/typec/ucsi/ucsi_ccg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
> index bff96d64dddf..6db7c8ddd51c 100644
> --- a/drivers/usb/typec/ucsi/ucsi_ccg.c
> +++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
> @@ -325,7 +325,7 @@ static int ucsi_ccg_init(struct ucsi_ccg *uc)
>  		if (status < 0)
>  			return status;
>  
> -		if (!data)
> +		if (!(data & DEV_INT))
>  			return 0;
>  
>  		status = ccg_write(uc, CCGX_RAB_INTR_REG, &data, sizeof(data));
> -- 
> 2.25.1

thanks,

-- 
heikki
