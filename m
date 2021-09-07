Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA1740244B
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 09:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhIGH3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 03:29:47 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49966 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhIGH3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 03:29:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1877Sa0Y005653;
        Tue, 7 Sep 2021 02:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1630999716;
        bh=2kavq6nJdZBNNM94n6MDZBgCMxqFqFaFHgQiAgBTqFk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dGNV9gIgmZz/+VuTqpQiFWnhqUvbVwNzvD+vW5Cpz0VIYUF318qYhHU9XaYXBe5dk
         3MnPZnC2OfmkvgPuX1RrS1l66LXrmL8wzbkJ0SCFwEdDKjHmv11NTFNOzEgw53kjdV
         jmuFMPbMzMz5NTPDNYO92dJCk7pOMWz9izkuzBQI=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1877SaQp123467
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 7 Sep 2021 02:28:36 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 7
 Sep 2021 02:28:35 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 7 Sep 2021 02:28:35 -0500
Received: from [10.250.232.51] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1877SWW6054093;
        Tue, 7 Sep 2021 02:28:33 -0500
Subject: Re: [PATCH] usb: cdns3: fix race condition before setting doorbell
To:     Pawel Laszczak <pawell@cadence.com>, <peter.chen@kernel.org>
CC:     <rogerq@kernel.org>, <gregkh@linuxfoundation.org>,
        <felipe.balbi@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210907062619.34622-1-pawell@gli-login.cadence.com>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <774df0ea-76e5-b8e2-9bd6-55e4b1cc09f4@ti.com>
Date:   Tue, 7 Sep 2021 12:58:32 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210907062619.34622-1-pawell@gli-login.cadence.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/09/21 11:56 am, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> For DEV_VER_V3 version there exist race condition between clearing
> ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
> Setting EP_CMD_DRDY will be ignored by controller when
> EP_STS_TRBERR is set. So, between these two instructions we have
> a small time gap in which the EP_STSS_TRBERR can be set. In such case
> the transfer will not start after setting doorbell.
> 
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> cc: <stable@vger.kernel.org> # 5.12.x
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---

Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Tested-by: Aswath Govindraju <a-govindraju@ti.com>

>  drivers/usb/cdns3/cdns3-gadget.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
> index 80aaab159e58..e9769fab21ea 100644
> --- a/drivers/usb/cdns3/cdns3-gadget.c
> +++ b/drivers/usb/cdns3/cdns3-gadget.c
> @@ -1100,6 +1100,19 @@ static int cdns3_ep_run_stream_transfer(struct cdns3_endpoint *priv_ep,
>  	return 0;
>  }
>  
> +static void cdns3_rearm_drdy_if_needed(struct cdns3_endpoint *priv_ep)
> +{
> +	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
> +
> +	if (priv_dev->dev_ver < DEV_VER_V3)
> +		return;
> +
> +	if (readl(&priv_dev->regs->ep_sts) & EP_STS_TRBERR) {
> +		writel(EP_STS_TRBERR, &priv_dev->regs->ep_sts);
> +		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
> +	}
> +}
> +
>  /**
>   * cdns3_ep_run_transfer - start transfer on no-default endpoint hardware
>   * @priv_ep: endpoint object
> @@ -1351,6 +1364,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
>  		/*clearing TRBERR and EP_STS_DESCMIS before seting DRDY*/
>  		writel(EP_STS_TRBERR | EP_STS_DESCMIS, &priv_dev->regs->ep_sts);
>  		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
> +		cdns3_rearm_drdy_if_needed(priv_ep);
>  		trace_cdns3_doorbell_epx(priv_ep->name,
>  					 readl(&priv_dev->regs->ep_traddr));
>  	}
> 

