Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EC23281EC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 16:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhCAPMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 10:12:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:61329 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236976AbhCAPM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 10:12:26 -0500
IronPort-SDR: 5jHpC6rkxwmGn0oAjVmqZm5jKjfDKiCRukWGvwdX4CHDjXUVBmFmfsC8iH98BrpoZ/hkSrpPrh
 6SzWs9Vj4G8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="165725489"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="165725489"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 07:10:39 -0800
IronPort-SDR: ixy11YE67IpJBPDk+MiFCAFmaRxOKAb13L234gqYwXns6Az3YIhZx/gtgP8ReYzcaOrf1rvn+F
 XgA9WaSaltww==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="505098702"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 07:10:37 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lGkBv-009ALW-5R; Mon, 01 Mar 2021 17:10:35 +0200
Date:   Mon, 1 Mar 2021 17:10:35 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] software node: Fix node registration
Message-ID: <YD0D6/NQpDdj1WeX@smile.fi.intel.com>
References: <20210301143012.55118-1-heikki.krogerus@linux.intel.com>
 <20210301143012.55118-2-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301143012.55118-2-heikki.krogerus@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 05:30:11PM +0300, Heikki Krogerus wrote:
> Software node can not be registered before its parent.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

(On Intel Galileo Gen 2 with some custom patches to convert gpio-dwapb et al.
 to use swnodes. Those patches a subject to further submission.)

Thanks!

> Fixes: 80488a6b1d3c ("software node: Add support for static node descriptors")
> Cc: stable@vger.kernel.org
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/base/swnode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
> index 37179a8b1ceba..74db8c971db74 100644
> --- a/drivers/base/swnode.c
> +++ b/drivers/base/swnode.c
> @@ -938,6 +938,9 @@ int software_node_register(const struct software_node *node)
>  	if (software_node_to_swnode(node))
>  		return -EEXIST;
>  
> +	if (node->parent && !parent)
> +		return -EINVAL;
> +
>  	return PTR_ERR_OR_ZERO(swnode_register(node, parent, 0));
>  }
>  EXPORT_SYMBOL_GPL(software_node_register);
> -- 
> 2.30.1
> 

-- 
With Best Regards,
Andy Shevchenko


