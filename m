Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067216AD856
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 08:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCGHcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 02:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjCGHcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 02:32:21 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57CD532B4;
        Mon,  6 Mar 2023 23:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678174340; x=1709710340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wl9MoUmMuJ+7jVWUFfl7AzE258BuhpcXmmPQpcbuO2s=;
  b=FwzPYfnaOqTHRnVffAWreCdwxK+TUHsESkvjc2Buq0Fo8MHybEFV7HsT
   JH7Cz128wYqtiphU3KPpKZtlJkctkNIjIMq1Iy2V0AMe1i0njSv8egD7I
   EcV6eLmSN2L69Zp3BCWh/SXHPyHkbpSUjGOU4lLh/YkeN6irSsZt7dS1j
   +b4z5qmINMIO9/2nrZ1wUDp8bTuaH62OEYzcccG9zM5/V1yZGV4cBp8oG
   DHXUvfETM6InBKCxr85nzOjsNPh8/yg+elzpmwFg7X++PmmSjCdUhfNId
   7cH2MDWzgAnYeJhiTMywPwxVzJ0XXISgSLSm8G8DQzwtkahhAZeJA8PJW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="363404160"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="363404160"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 23:32:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="819644163"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="819644163"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 06 Mar 2023 23:32:18 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 07 Mar 2023 09:32:17 +0200
Date:   Tue, 7 Mar 2023 09:32:17 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] usb: ucsi: Fix NULL pointer deref in
 ucsi_connector_change()
Message-ID: <ZAbogXNU1D7Qapme@kuha.fi.intel.com>
References: <20230306103359.6591-1-hdegoede@redhat.com>
 <20230306103359.6591-2-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306103359.6591-2-hdegoede@redhat.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 11:33:57AM +0100, Hans de Goede wrote:
> When ucsi_init() fails, ucsi->connector is NULL, yet in case of
> ucsi_acpi we may still get events which cause the ucs_acpi code to call
> ucsi_connector_change(), which then derefs the NULL ucsi->connector
> pointer.
> 
> Fix this by not setting ucsi->ntfy inside ucsi_init() until ucsi_init()
> has succeeded, so that ucsi_connector_change() ignores the events
> because UCSI_ENABLE_NTFY_CONNECTOR_CHANGE is not set in the ntfy mask.
> 
> Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
> Changes in v2:
> -Delay setting ucsi->ntfy in ucsi_init() instead of adding a NULL pointer
>  check to ucsi_connector_change()
> ---
>  drivers/usb/typec/ucsi/ucsi.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> index 1cf8947c6d66..8cbbb002fefe 100644
> --- a/drivers/usb/typec/ucsi/ucsi.c
> +++ b/drivers/usb/typec/ucsi/ucsi.c
> @@ -1205,7 +1205,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
>  static int ucsi_init(struct ucsi *ucsi)
>  {
>  	struct ucsi_connector *con;
> -	u64 command;
> +	u64 command, ntfy;
>  	int ret;
>  	int i;
>  
> @@ -1217,8 +1217,8 @@ static int ucsi_init(struct ucsi *ucsi)
>  	}
>  
>  	/* Enable basic notifications */
> -	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
> -	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
> +	ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
> +	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
>  	ret = ucsi_send_command(ucsi, command, NULL, 0);
>  	if (ret < 0)
>  		goto err_reset;
> @@ -1250,12 +1250,13 @@ static int ucsi_init(struct ucsi *ucsi)
>  	}
>  
>  	/* Enable all notifications */
> -	ucsi->ntfy = UCSI_ENABLE_NTFY_ALL;
> -	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
> +	ntfy = UCSI_ENABLE_NTFY_ALL;
> +	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
>  	ret = ucsi_send_command(ucsi, command, NULL, 0);
>  	if (ret < 0)
>  		goto err_unregister;
>  
> +	ucsi->ntfy = ntfy;
>  	return 0;
>  
>  err_unregister:
> -- 
> 2.39.1

-- 
heikki
