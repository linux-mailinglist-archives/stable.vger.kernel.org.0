Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555834ED658
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 11:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiCaJCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 05:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiCaJCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 05:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C88051585;
        Thu, 31 Mar 2022 02:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EFC4B82000;
        Thu, 31 Mar 2022 09:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF93C340ED;
        Thu, 31 Mar 2022 09:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648717253;
        bh=wNwVnTnwlRKd3pJ0yCmXSRbxpRcvTX29e7Vo18OTPDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDrtMRinc/Io8nwpaMAlnKMwo7KOwwzcQZtzCTP0gXme0LJrstd7O6KZAlIc/V1qK
         O6bDp0AX0GKRl7ZClO1pDz0aftDdiWPqyS5WeH1XysqeQPDpoKj2LFoUAiXF4jM1Fy
         xPtyc4mVxczZYluNFs5AqQFlzhuyV5c6I1kqUlTU=
Date:   Thu, 31 Mar 2022 11:00:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Won Chung <wonchung@google.com>
Cc:     Tomas Winkler <tomas.winkler@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] misc/mei: Add NULL check to component match callback
 functions
Message-ID: <YkVtvhC0n9B994/A@kroah.com>
References: <20220331084918.2592699-1-wonchung@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331084918.2592699-1-wonchung@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 08:49:18AM +0000, Won Chung wrote:
> Component match callback functions need to check if expected data is
> passed to them. Without this check, it can cause a NULL pointer
> dereference when another driver registers a component before i915
> drivers have their component master fully bind.

How can that happen in a real system?  Or does this just happen for when
you are doing development and testing?

> 
> Fixes: 1e8d19d9b0dfc ("mei: hdcp: bind only with i915 on the same PCH")
> Fixes: c2004ce99ed73 ("mei: pxp: export pavp client to me client bus")
> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Won Chung <wonchung@google.com>
> Cc: stable@vger.kernel.org

Why does this need to go to stable?  How can this be triggered in older
kernels?

> ---
> Changes from v2:
> - Correctly add "Suggested-by" tag
> - Add "Cc: stable@vger.kernel.org"
> 
> Changes from v1:
> - Add "Fixes" tag
> - Send to stable@vger.kernel.org
> 
>  drivers/misc/mei/hdcp/mei_hdcp.c | 2 +-
>  drivers/misc/mei/pxp/mei_pxp.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
> index ec2a4fce8581..843dbc2b21b1 100644
> --- a/drivers/misc/mei/hdcp/mei_hdcp.c
> +++ b/drivers/misc/mei/hdcp/mei_hdcp.c
> @@ -784,7 +784,7 @@ static int mei_hdcp_component_match(struct device *dev, int subcomponent,
>  {
>  	struct device *base = data;
>  
> -	if (strcmp(dev->driver->name, "i915") ||
> +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||

How can base be NULL?


>  	    subcomponent != I915_COMPONENT_HDCP)
>  		return 0;
>  
> diff --git a/drivers/misc/mei/pxp/mei_pxp.c b/drivers/misc/mei/pxp/mei_pxp.c
> index f7380d387bab..e32a81da8af6 100644
> --- a/drivers/misc/mei/pxp/mei_pxp.c
> +++ b/drivers/misc/mei/pxp/mei_pxp.c
> @@ -131,7 +131,7 @@ static int mei_pxp_component_match(struct device *dev, int subcomponent,
>  {
>  	struct device *base = data;
>  
> -	if (strcmp(dev->driver->name, "i915") ||
> +	if (!base || !dev->driver || strcmp(dev->driver->name, "i915") ||

Same here, shouldn't this be caught by the driver core or bus and match
should not be called?

Why not fix this in the component/driver core instead?

thanks,

greg k-h
