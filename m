Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C43A1B58EF
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgDWKTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:19:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:29833 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgDWKTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 06:19:44 -0400
IronPort-SDR: TC88eBxm469uo44iVhzRyCaK1OwYEZ+KJRohid+U5Tnkr4YHgQHkOJDIb3jXhpAnIeb8XMTeHn
 sk8oNkYsL4+w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 03:19:43 -0700
IronPort-SDR: rcIskyk6nKvlN2GAWkh1/9Dyc0RneQxqJWAa7jtqbzZNgub/bIh7ytz6vk0u81XppObMID7o6D
 yKgKBxTWIO3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="365963385"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 23 Apr 2020 03:19:41 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 23 Apr 2020 13:19:40 +0300
Date:   Thu, 23 Apr 2020 13:19:40 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Naoki Kiryu <naonaokiryu2@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: typec: altmode: Fix typec_altmode_get_partner
 sometimes returning an invalid pointer
Message-ID: <20200423101940.GA1286704@kuha.fi.intel.com>
References: <20200422144345.43262-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422144345.43262-1-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 04:43:45PM +0200, Hans de Goede wrote:
> From: Naoki Kiryu <naonaokiryu2@gmail.com>
> 
> Before this commit, typec_altmode_get_partner would return a
> const struct typec_altmode * pointing to address 0x08 when
> to_altmode(adev)->partner was NULL.
> 
> Add a check for to_altmode(adev)->partner being NULL to fix this.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206365
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1785972
> Fixes: 5f54a85db5df ("usb: typec: Make sure an alt mode exist before getting its partner")
> Cc: stable@vger.kernel.org
> Signed-off-by: Naoki Kiryu <naonaokiryu2@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/typec/bus.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
> index c823122f9cb7..e8ddb81cb6df 100644
> --- a/drivers/usb/typec/bus.c
> +++ b/drivers/usb/typec/bus.c
> @@ -198,7 +198,10 @@ EXPORT_SYMBOL_GPL(typec_altmode_vdm);
>  const struct typec_altmode *
>  typec_altmode_get_partner(struct typec_altmode *adev)
>  {
> -	return adev ? &to_altmode(adev)->partner->adev : NULL;
> +	if (!adev || !to_altmode(adev)->partner)
> +		return NULL;
> +
> +	return &to_altmode(adev)->partner->adev;
>  }
>  EXPORT_SYMBOL_GPL(typec_altmode_get_partner);
>  
> -- 
> 2.26.0

thanks,

-- 
heikki
