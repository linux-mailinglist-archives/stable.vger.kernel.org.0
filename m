Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1571D6A55C8
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 10:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjB1J3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 04:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjB1J3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 04:29:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3D327986;
        Tue, 28 Feb 2023 01:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8E1161027;
        Tue, 28 Feb 2023 09:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9632C433EF;
        Tue, 28 Feb 2023 09:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677576507;
        bh=Bk0pb5f9j29eGYdkkPlQXhqebgMIKsDEE9KRrgKws2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xXvFQGTuazFb4fTHQ/7HIvUGjjS0eHxRBmWa/x2gfq6J/TRZrEUcnvJwYnYC8S3G3
         0A3SmA76KSdiNnR5hq6kSsEazZTPAMaM+s1Kh6SmJxqoOP3MeCoJ1x0ndmm6+PDbmz
         zeS4ESoWtY1jjeDrfeQDq9BMN/ml0LtIcFF/ejeg=
Date:   Tue, 28 Feb 2023 10:28:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: ucsi: Fix NULL pointer deref in
 ucsi_connector_change()
Message-ID: <Y/3JOPgw4ru0Ztd2@kroah.com>
References: <20230228090305.9335-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228090305.9335-1-hdegoede@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 10:03:03AM +0100, Hans de Goede wrote:
> When ucsi_init() fails, ucsi->connector is NULL, yet in case of
> ucsi_acpi we may still get events which cause the ucs_acpi code to call
> ucsi_connector_change(), which then derefs the NULL ucsi->connector
> pointer.
> 
> Fix this by adding a check for ucsi->connector being NULL, as is
> already done in ucsi_resume() for similar reasons.
> 
> Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/typec/ucsi/ucsi.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> index 1cf8947c6d66..e762897cb25a 100644
> --- a/drivers/usb/typec/ucsi/ucsi.c
> +++ b/drivers/usb/typec/ucsi/ucsi.c
> @@ -842,7 +842,13 @@ static void ucsi_handle_connector_change(struct work_struct *work)
>   */
>  void ucsi_connector_change(struct ucsi *ucsi, u8 num)
>  {
> -	struct ucsi_connector *con = &ucsi->connector[num - 1];
> +	struct ucsi_connector *con;
> +
> +	/* Check for ucsi_init() failure */
> +	if (!ucsi->connector)
> +		return;
> +
> +	con = &ucsi->connector[num - 1];

What prevents ->connector from changing to NULL right after you check
this and before you dereference it again?

thanks,

greg k-h
