Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FE1382288
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 03:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhEQBbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 21:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhEQBbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 May 2021 21:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F1ED611BE;
        Mon, 17 May 2021 01:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621215019;
        bh=gHAmi2NHDTka4+Zc5zDL0ZgHOqdFezotAMp/Y6iLG0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D/fUFDAfNTgNx1wTUlZP9+Y/0Z/URWZUnXquRQ6GF6lM3L8jYjImPX34oza8xz082
         lrdy5Aim1fxYC86l4EDM/y3pnkZ1VnwzBHbPlbtFMBYvWl/xMD5mE/0T9qvK6CAUBs
         S8TilG0rhiPul1TCQUKO9iPD9m87N7PhTH94J6uCNK4mTYrggTajKM6V4Bf6cGIa4T
         U5ixj4lKUC8y0XZmWqqLvhj6jDxDXk++kfXEjFt+LCWCA1tjgov20LtZSvFOtj+9Wt
         WHKZ5O9/G4eMoVYj1Ru3ILkwY3UoC+N5xnuEd+NRnou/7NXOsufF6xM3tMi5P8rzKk
         d2A7dewgCWZhw==
Date:   Mon, 17 May 2021 09:30:11 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/4] usb: typec: tcpm: Fix up PR_SWAP when vsafe0v is
 signalled
Message-ID: <20210517013011.GA27963@nchen>
References: <20210515052613.3261340-1-badhri@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210515052613.3261340-1-badhri@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-05-14 22:26:10, Badhri Jagan Sridharan wrote:
> During PR_SWAP, When TCPM is in PR_SWAP_SNK_SRC_SINK_OFF, vbus is
> expected to reach VSAFE0V when source turns of vbus. Do not move

%s/of/off

Peter

> to SNK_UNATTACHED state when this happens.
> 
> Fixes: 28b43d3d746b ("usb: typec: tcpm: Introduce vsafe0v for vbus")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
>  drivers/usb/typec/tcpm/tcpm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index c4fdc00a3bc8..b93c4c8d7b15 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5114,6 +5114,9 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
>  				tcpm_set_state(port, SNK_UNATTACHED, 0);
>  		}
>  		break;
> +	case PR_SWAP_SNK_SRC_SINK_OFF:
> +		/* Do nothing, vsafe0v is expected during transition */
> +		break;
>  	default:
>  		if (port->pwr_role == TYPEC_SINK && port->auto_vbus_discharge_enabled)
>  			tcpm_set_state(port, SNK_UNATTACHED, 0);
> -- 
> 2.31.1.751.gd2f1c929bd-goog
> 

-- 

Thanks,
Peter Chen

