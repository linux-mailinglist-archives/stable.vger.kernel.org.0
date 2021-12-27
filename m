Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EEE48015A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 17:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhL0QB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 11:01:29 -0500
Received: from lithium.sammserver.com ([168.119.122.30]:43566 "EHLO
        lithium.sammserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239880AbhL0QB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 11:01:28 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Dec 2021 11:01:28 EST
Received: from mail.sammserver.com (sammserver.wg [10.32.40.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by lithium.sammserver.com (Postfix) with ESMTPS id 0244331181C2;
        Mon, 27 Dec 2021 16:53:38 +0100 (CET)
Received: from mail.sammserver.com (localhost.localdomain [127.0.0.1])
        by mail.sammserver.com (Postfix) with ESMTP id A9A7C38E94;
        Mon, 27 Dec 2021 16:53:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cavoj.net; s=email;
        t=1640620418; bh=ZHCOAfzGIR740kz8id/jXF6SGoFuUAS+EQvfXYXa4Xw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cKUpt0UaAKoaDYjGB08kTArZCBLceomiKaakxt9amx6aKSkmMWrmun2MR6+fJkPcD
         yGpzj3lQcAsMp+R9U5UEtS8FPs4M4iM2Tyri0iWDEwhDrg3tCuaMQQ+NHNjQZydNI8
         VDFQWKWiAHsQGWl4TO7ndRljsijjOSzAEmDHhdNI=
MIME-Version: 1.0
Date:   Mon, 27 Dec 2021 16:53:38 +0100
From:   =?UTF-8?Q?Samuel_=C4=8Cavoj?= <samuel@cavoj.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 5.15 114/128] Input: i8042 - enable deferred probe quirk
 for ASUS UM325UA
In-Reply-To: <20211227151335.325998991@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
 <20211227151335.325998991@linuxfoundation.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <a0258f0acbe50d4ea3c73724eafd4ed1@cavoj.net>
X-Sender: samuel@cavoj.net
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

it seems this patch is misapplied -- please see the context in the 
original
diff. The quirk in question itself was only added in a recent patch 
which
is not present in stable:
commit 9222ba68c3f406 -- 
https://lore.kernel.org/all/20211117063757.11380-1-tiwai@suse.de/

This seems to be the case for all stable branches.

Thanks

On 2021-12-27 16:31, Greg Kroah-Hartman wrote:
> From: Samuel Čavoj <samuel@cavoj.net>
> 
> commit 44ee250aeeabb28b52a10397ac17ffb8bfe94839 upstream.
> 
> The ASUS UM325UA suffers from the same issue as the ASUS UX425UA, which
> is a very similar laptop. The i8042 device is not usable immediately
> after boot and fails to initialize, requiring a deferred retry.
> 
> Enable the deferred probe quirk for the UM325UA.
> 
> BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1190256
> Signed-off-by: Samuel Čavoj <samuel@cavoj.net>
> Link: 
> https://lore.kernel.org/r/20211204015615.232948-1-samuel@cavoj.net
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -992,6 +992,13 @@ static const struct dmi_system_id __init
>  			DMI_MATCH(DMI_PRODUCT_NAME, "C504"),
It doesn't match here.

>  		},
>  	},
> +	{
> +		/* ASUS ZenBook UM325UA */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
> +		},
> +	},
>  	{ }
>  };

Regards,
Samuel
