Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533342D76FD
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 14:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgLKNyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 08:54:17 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50602 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbgLKNxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 08:53:46 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0BBDpswo066026;
        Fri, 11 Dec 2020 07:51:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1607694714;
        bh=qhUy6T1tzktns2p4haE3iBZHGYFn1qMsVGij1z6lae0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=liHm7or+bpfNiM2anw47uag59dxlDqxG98m5v0Ei7Pr0YtKD3oXqT9YLtKUG2IHxI
         50Qh9l9SRWBp3ue0u4z65HHi19nH27fwHc8KjMml9MgEsgPAyNia4wdqB54aOX7urv
         WIPo3IpKbWOIkpg1DlTOlh6FdTMs5mCepSrIpF20=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0BBDpsXX024937
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Dec 2020 07:51:54 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 11
 Dec 2020 07:51:54 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 11 Dec 2020 07:51:54 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0BBDppf2123942;
        Fri, 11 Dec 2020 07:51:52 -0600
Subject: Re: [PATCH] serial: 8250_omap: Avoid FIFO corruption caused by MDR1
 access
To:     Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        <linux-serial@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20201210055257.1053028-1-alexander.sverdlin@gmail.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <b6bc434b-d75d-1f04-9bb2-457333c46a92@ti.com>
Date:   Fri, 11 Dec 2020 19:21:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201210055257.1053028-1-alexander.sverdlin@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/10/20 11:22 AM, Alexander Sverdlin wrote:
> It has been observed that once per 300-1300 port openings the first
> transmitted byte is being corrupted on AM3352 ("v" written to FIFO appeared
> as "e" on the wire). It only happened if single byte has been transmitted
> right after port open, which means, DMA is not used for this transfer and
> the corruption never happened afterwards.
> 
> Therefore I've carefully re-read the MDR1 errata (link below), which says
> "when accessing the MDR1 registers that causes a dummy under-run condition
> that will freeze the UART in IrDA transmission. In UART mode, this may
> corrupt the transferred data". Strictly speaking,
> omap_8250_mdr1_errataset() performs a read access and if the value is the
> same as should be written, exits without errata-recommended FIFO reset.
> 
> A brief check of the serial_omap_mdr1_errataset() from the competing
> omap-serial driver showed it has no read access of MDR1. After removing the
> read access from omap_8250_mdr1_errataset() the data corruption never
> happened any more.
> 
> Link: https://www.ti.com/lit/er/sprz360i/sprz360i.pdf
> Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>

Thanks for the fix.

Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>

> ---
>  drivers/tty/serial/8250/8250_omap.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
> index 562087df7d33..0cc6d35a0815 100644
> --- a/drivers/tty/serial/8250/8250_omap.c
> +++ b/drivers/tty/serial/8250/8250_omap.c
> @@ -184,11 +184,6 @@ static void omap_8250_mdr1_errataset(struct uart_8250_port *up,
>  				     struct omap8250_priv *priv)
>  {
>  	u8 timeout = 255;
> -	u8 old_mdr1;
> -
> -	old_mdr1 = serial_in(up, UART_OMAP_MDR1);
> -	if (old_mdr1 == priv->mdr1)
> -		return;
>  
>  	serial_out(up, UART_OMAP_MDR1, priv->mdr1);
>  	udelay(2);
> 
