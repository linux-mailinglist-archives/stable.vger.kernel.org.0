Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A334A340061
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 08:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhCRHqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 03:46:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:56852 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhCRHqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 03:46:46 -0400
IronPort-SDR: hZSCAXDf4+xCl2M1dURLAuNY9zQ9fmTKxj3QX4oywcgvqOYZmkuppBMZ8RiL/xj70Boo4pVBPf
 OpToGRsMw+fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="176754624"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="176754624"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 00:46:45 -0700
IronPort-SDR: bJY+i5jTopDL5s+varut7NkUmH/LGg42WFaFyk/Osa8R/Au8lCvllNkyG3XAcjl6OAjxf/rsAF
 Dtawzqnkt9tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="512018798"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 18 Mar 2021 00:46:42 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 18 Mar 2021 09:46:42 +0200
Date:   Thu, 18 Mar 2021 09:46:42 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] usb: typec: tcpm: Skip sink_cap query only when VDM
 sm is busy
Message-ID: <YFMFYoWBpBSrr5xg@kuha.fi.intel.com>
References: <20210318064805.3747831-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318064805.3747831-1-badhri@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 11:48:05PM -0700, Badhri Jagan Sridharan wrote:
> When port partner responds "Not supported" to the DiscIdentity command,
> VDM state machine can remain in NVDM_STATE_ERR_TMOUT and this causes
> querying sink cap to be skipped indefinitely. Hence check for
> vdm_sm_running instead of checking for VDM_STATE_DONE.
> 
> Fixes: 8dc4bd073663f ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/tcpm/tcpm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 11d0c40bc47d..39e068d60755 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5219,7 +5219,7 @@ static void tcpm_enable_frs_work(struct kthread_work *work)
>  		goto unlock;
>  
>  	/* Send when the state machine is idle */
> -	if (port->state != SNK_READY || port->vdm_state != VDM_STATE_DONE || port->send_discover)
> +	if (port->state != SNK_READY || port->vdm_sm_running || port->send_discover)
>  		goto resched;
>  
>  	port->upcoming_state = GET_SINK_CAP;
> -- 
> 2.31.0.rc2.261.g7f71774620-goog

thanks,

-- 
heikki
