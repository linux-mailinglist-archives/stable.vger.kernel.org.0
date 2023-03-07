Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3549A6AD86C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 08:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjCGHr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 02:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjCGHrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 02:47:24 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE284ECC3;
        Mon,  6 Mar 2023 23:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678175242; x=1709711242;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bmkHX6xdSGHHz0LOUX9EjOWoDXOEIHWzas9YES7KBoY=;
  b=dj3e+katl4dMqDv3ErWKnPySlCiyeBClx3qEOKwyrAYIYJOoGKQK/Bp8
   qoFst7qF4JsJ1IHDSR78KuRiORRVN1Ze9ATJ/deE/XWRTtuBhJDStGR8O
   DxizkokbphsSLrjg9ZzXNR1sWgv2BWRjPyP/exC4vW5d5doYUbwr/tL5U
   oEEC8YajCA7VeBXaN0YOf+0PLrFm8j8k+khvOdOmaKu6aZa2TV4utR9OB
   sC1SKX/3q5G/Fu54jYAW0B4carvLmXs5zLZHGjp0+HYSTU2WN1XPbpx3S
   EF1haxw6iBySWagYgjenk2d0D0YPrdtr7fYB7zw6GgR/DCZpahKAqwqwI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="400608375"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="400608375"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 23:47:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="819648944"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="819648944"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 06 Mar 2023 23:47:19 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 07 Mar 2023 09:47:19 +0200
Date:   Tue, 7 Mar 2023 09:47:19 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] usb: ucsi_acpi: Increase the command completion
 timeout
Message-ID: <ZAbsBzOWilYzF61D@kuha.fi.intel.com>
References: <20230306103359.6591-1-hdegoede@redhat.com>
 <20230306103359.6591-4-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306103359.6591-4-hdegoede@redhat.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 11:33:59AM +0100, Hans de Goede wrote:
> Commit 130a96d698d7 ("usb: typec: ucsi: acpi: Increase command
> completion timeout value") increased the timeout from 5 seconds
> to 60 seconds due to issues related to alternate mode discovery.
> 
> After the alternate mode discovery switch to polled mode
> the timeout was reduced, but instead of being set back to
> 5 seconds it was reduced to 1 second.
> 
> This is causing problems when using a Lenovo ThinkPad X1 yoga gen7
> connected over Type-C to a LG 27UL850-W (charging DP over Type-C).
> 
> When the monitor is already connected at boot the following error
> is logged: "PPM init failed (-110)", /sys/class/typec is empty and
> on unplugging the NULL pointer deref fixed earlier in this series
> happens.
> 
> When the monitor is connected after boot the following error
> is logged instead: "GET_CONNECTOR_STATUS failed (-110)".
> 
> Setting the timeout back to 5 seconds fixes both cases.
> 
> Fixes: e08065069fc7 ("usb: typec: ucsi: acpi: Reduce the command completion timeout")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/ucsi/ucsi_acpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
> index ce0c8ef80c04..62206a6b8ea7 100644
> --- a/drivers/usb/typec/ucsi/ucsi_acpi.c
> +++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
> @@ -78,7 +78,7 @@ static int ucsi_acpi_sync_write(struct ucsi *ucsi, unsigned int offset,
>  	if (ret)
>  		goto out_clear_bit;
>  
> -	if (!wait_for_completion_timeout(&ua->complete, HZ))
> +	if (!wait_for_completion_timeout(&ua->complete, 5 * HZ))
>  		ret = -ETIMEDOUT;
>  
>  out_clear_bit:
> -- 
> 2.39.1

-- 
heikki
