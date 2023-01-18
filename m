Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA28E67190B
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 11:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjARKgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 05:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjARKdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 05:33:14 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8128385A;
        Wed, 18 Jan 2023 01:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674034801; x=1705570801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Dim/XHdZNOWgoQEmO/2DDcF5rOun4Mijg9kltai7M+A=;
  b=CLZgMcab6anhctRCx8aH3DanqI9LA5BgnpmJMtcwrViPtefrAS3iQ3ot
   WZgBR3JtYjwnwLMmOvmvrHziMhvxFrJ8FryGnDo2kTmwxYVCzBzx27FTm
   lUGXwrcqExwnS06XEs0SeG9YpwdPLUCv939CmpPS6kD33M+kYMJc92CW+
   CW4s+3Xl5LsOowulxPn2HfdQ4vPNrtGGj7cEpKZaRlgpNbZ5DpwxIs6o4
   B1XOLt4d194kx0dgI/wcBmV0lEl96wozMZpkpkpZK6czS0Hu73A6Exgwy
   9vtRq3u5/VHJZBt8SSlaelyFvozTeq53vHu53cWU4QQ2b8dBWsH24HLmX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="305317435"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="305317435"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 01:39:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="802120538"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="802120538"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 18 Jan 2023 01:39:47 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 18 Jan 2023 11:39:46 +0200
Date:   Wed, 18 Jan 2023 11:39:46 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Update active state
Message-ID: <Y8e+YlKiC6FHdQ5s@kuha.fi.intel.com>
References: <20230118031514.1278139-1-pmalani@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118031514.1278139-1-pmalani@chromium.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 03:15:15AM +0000, Prashant Malani wrote:
> Update the altmode "active" state when we receive Acks for Enter and
> Exit Mode commands. Having the right state is necessary to change Pin
> Assignments using the 'pin_assignment" sysfs file.

The idea was that the port drivers take care of this, not the altmode
drivers.

thanks,

> Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
> Cc: stable@vger.kernel.org
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> ---
>  drivers/usb/typec/altmodes/displayport.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
> index 06fb4732f8cd..bc1c556944d6 100644
> --- a/drivers/usb/typec/altmodes/displayport.c
> +++ b/drivers/usb/typec/altmodes/displayport.c
> @@ -277,9 +277,11 @@ static int dp_altmode_vdm(struct typec_altmode *alt,
>  	case CMDT_RSP_ACK:
>  		switch (cmd) {
>  		case CMD_ENTER_MODE:
> +			typec_altmode_update_active(alt, true);
>  			dp->state = DP_STATE_UPDATE;
>  			break;
>  		case CMD_EXIT_MODE:
> +			typec_altmode_update_active(alt, false);
>  			dp->data.status = 0;
>  			dp->data.conf = 0;
>  			break;
> -- 
> 2.39.0.314.g84b9a713c41-goog

-- 
heikki
