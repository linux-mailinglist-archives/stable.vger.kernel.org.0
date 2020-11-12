Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D732B050B
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 13:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgKLMiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 07:38:21 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50051 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgKLMiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 07:38:20 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2020 07:38:19 EST
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id dBkmkUJ9GlMRadBkqks5yQ; Thu, 12 Nov 2020 13:31:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1605184271; bh=9onKt8PsxxxHPi9pt4aWFWWnV0wip3PDrR3ylVPB8eo=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=Z56WVTTSKHFkKcBuLuKiwRLIXgPuxFstGWtrsHwBDF1MOmgKf49pdVvOaTvQnVoIs
         XD3h84wRcaHCJP1wHRiwLzHp5u7n/jgCEfx89cv4zUaqwmporVzmPK3NhjFXjY31KB
         xgk873x7cUnT/LWyNVcVYONQEeOFtalKtevRKkwFC5Sk67O3WCh0NUYTev12+1DFws
         I9G50FwA+XiQS54KJxvtqikzMHfMmZFxDLZ/mRuUTNU2kXQb8XMsY9PQZZCGe4SgGu
         aw0oeQtxRD+T3T4VLP8ENhpf9MyoXppQRJ4pwzjyP8wH71oye4OgmzHazqm8S825ov
         aOqhLP/cruqiA==
Subject: Re: [PATCH 1/2] media: sunxi-cir: ensure IR is handled when it is
 continuous
To:     Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <mripard@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org
References: <20201110091557.25680-1-sean@mess.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6ea783d6-dcf0-eb40-891a-35112fd9bf8a@xs4all.nl>
Date:   Thu, 12 Nov 2020 13:31:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201110091557.25680-1-sean@mess.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfDKs49XeI+i/zv2wibBZSiGY7jRtTKTLZ8Fz0ifsc38yJs2dS55EAhWvWPRIfmudjGZ29SmLbiV2vRCPI943pq9UrbaeKonx2CL3Up8CyBtTVcMPJ9wo
 4UjFizn8o48ybLRDNUCInl5dXLiZxLEpx1jPHswZA7crt4ugzEn7pBOfIIGaZ6lyCacbuRC5ynhm/QaBTHeNkmpsSNckMpaRcE+qVghnUv0im/Nx52uhSf7S
 00rk5Y1zzrUlAY5yDdvf+zNIeNpSwaRLMqtxkcOheTlK80eFb886kSpN1KsO9008owwcIN+ZU4PIf0IRzofbDWsZoA79TKVdLEZI5OI5hEg0tAI3Ul5cGaWn
 /fYGi0es
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/2020 10:15, Sean Young wrote:
> If a user holds a button down on a remote, then no ir idle interrupt will
> be generated until the user releases the button, depending on how quickly
> the remote repeats. No IR is processed until that point, which means that
> holding down a button may not do anything.
> 
> This also resolves an issue on a Cubieboard 1 where the IR receiver is
> picking up ambient infrared as IR and spews out endless
> "rc rc0: IR event FIFO is full!" messages unless you choose to live in
> the dark.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Sean Young <sean@mess.org>

Tested-by: Hans Verkuil <hverkuil@xs4all.nl>

Nice! No more spam in the kernel log for my Cubieboard 1!

Thank you,

	Hans

> ---
>  drivers/media/rc/sunxi-cir.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
> index ddee6ee37bab1..4afc5895bee74 100644
> --- a/drivers/media/rc/sunxi-cir.c
> +++ b/drivers/media/rc/sunxi-cir.c
> @@ -137,6 +137,8 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
>  	} else if (status & REG_RXSTA_RPE) {
>  		ir_raw_event_set_idle(ir->rc, true);
>  		ir_raw_event_handle(ir->rc);
> +	} else {
> +		ir_raw_event_handle(ir->rc);
>  	}
>  
>  	spin_unlock(&ir->ir_lock);
> 

