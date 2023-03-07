Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04886AD866
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 08:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjCGHqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 02:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCGHqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 02:46:53 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306EF2B637;
        Mon,  6 Mar 2023 23:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678175210; x=1709711210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kH64sJupPEHNBWJxD3ZfP4di5PHVCmMzSb1arEKTRUE=;
  b=mlxs3t9LxvCbrehybMsCNEoPZ9Y8qNGYGQewYZdP8yoS58t3aPa6lr5e
   y2LnqQH3NvJ+qXSc2h6o6BUqPmIBegZsuQ61YZdyhwFEBNo0oRXt8b1lz
   2+DsLedCLNfAOBF7vWiBlKHOBre6WRo0A3ra3VFI64XV3SQy7sW+8dQtS
   vQnLUwNh2bRu0bll2TgnG7SKLluC5oGSPMw6jbSxpxDd3odVE4SoWGC8m
   X1OjHKsGsmcnDRd/Y8J67lD2mgtVfml0t2BMJPhQ5FyBzkilX5iVanOwn
   D8JoHd0D0YzXrBOCVKSj7C0jlDTxMwFNFBXiP7SH2ORAyONSsfHrHD+O1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="400608262"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="400608262"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 23:46:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="819648765"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="819648765"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 06 Mar 2023 23:46:47 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 07 Mar 2023 09:46:46 +0200
Date:   Tue, 7 Mar 2023 09:46:46 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] usb: ucsi: Fix ucsi->connector race
Message-ID: <ZAbr5hdNf/jChLF0@kuha.fi.intel.com>
References: <20230306103359.6591-1-hdegoede@redhat.com>
 <20230306103359.6591-3-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306103359.6591-3-hdegoede@redhat.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

On Mon, Mar 06, 2023 at 11:33:58AM +0100, Hans de Goede wrote:
> ucsi_init() which runs from a workqueue sets ucsi->connector and
> on an error will clear it again.
> 
> ucsi->connector gets dereferenced by ucsi_resume(), this checks for
> ucsi->connector being NULL in case ucsi_init() has not finished yet;
> or in case ucsi_init() has failed.
> 
> ucsi_init() setting ucsi->connector and then clearing it again on
> an error creates a race where the check in ucsi_resume() may pass,
> only to have ucsi->connector free-ed underneath it when ucsi_init()
> hits an error.
> 
> Fix this race by making ucsi_init() store the connector array in
> a local variable and only assign it to ucsi->connector on success.
> 
> Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

This does not apply anymore on top of Greg's usb-next. I think you
need to rebase. While at it, I have one nit below...

> ---
>  drivers/usb/typec/ucsi/ucsi.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> index 8cbbb002fefe..15a2c91581a8 100644
> --- a/drivers/usb/typec/ucsi/ucsi.c
> +++ b/drivers/usb/typec/ucsi/ucsi.c
> @@ -1039,9 +1039,8 @@ static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
>  	return NULL;
>  }
>  
> -static int ucsi_register_port(struct ucsi *ucsi, int index)
> +static int ucsi_register_port(struct ucsi *ucsi, int index, struct ucsi_connector *con)

If con->num was set before this function is called, you don't need
"index" at all:

static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)

>  {
> -	struct ucsi_connector *con = &ucsi->connector[index];
>  	struct typec_capability *cap = &con->typec_cap;
>  	enum typec_accessory *accessory = cap->accessory;
>  	enum usb_role u_role = USB_ROLE_NONE;
> @@ -1204,7 +1203,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
>   */
>  static int ucsi_init(struct ucsi *ucsi)
>  {
> -	struct ucsi_connector *con;
> +	struct ucsi_connector *con, *connector;
>  	u64 command, ntfy;
>  	int ret;
>  	int i;
> @@ -1235,16 +1234,15 @@ static int ucsi_init(struct ucsi *ucsi)
>  	}
>  
>  	/* Allocate the connectors. Released in ucsi_unregister() */
> -	ucsi->connector = kcalloc(ucsi->cap.num_connectors + 1,
> -				  sizeof(*ucsi->connector), GFP_KERNEL);
> -	if (!ucsi->connector) {
> +	connector = kcalloc(ucsi->cap.num_connectors + 1, sizeof(*connector), GFP_KERNEL);
> +	if (!connector) {
>  		ret = -ENOMEM;
>  		goto err_reset;
>  	}
>  
>  	/* Register all connectors */
>  	for (i = 0; i < ucsi->cap.num_connectors; i++) {
> -		ret = ucsi_register_port(ucsi, i);

Assign it here:

                connector[i].num = i + 1;

> +		ret = ucsi_register_port(ucsi, i, &connector[i]);
>  		if (ret)
>  			goto err_unregister;
>  	}
> @@ -1256,11 +1254,12 @@ static int ucsi_init(struct ucsi *ucsi)
>  	if (ret < 0)
>  		goto err_unregister;
>  
> +	ucsi->connector = connector;
>  	ucsi->ntfy = ntfy;
>  	return 0;
>  
>  err_unregister:
> -	for (con = ucsi->connector; con->port; con++) {
> +	for (con = connector; con->port; con++) {
>  		ucsi_unregister_partner(con);
>  		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
>  		ucsi_unregister_port_psy(con);
> @@ -1269,10 +1268,7 @@ static int ucsi_init(struct ucsi *ucsi)
>  		typec_unregister_port(con->port);
>  		con->port = NULL;
>  	}
> -
> -	kfree(ucsi->connector);
> -	ucsi->connector = NULL;
> -
> +	kfree(connector);
>  err_reset:
>  	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
>  	ucsi_reset_ppm(ucsi);

thanks,

-- 
heikki
