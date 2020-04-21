Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21E1B279A
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 15:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgDUNX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 09:23:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728479AbgDUNX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 09:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587475406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ytKxWQADMe1hxsp4ibPZrOFawU10CTLZrsg1UsU9JN0=;
        b=adxVjd+XPa2NFSZpwJImczxLm8Ns4QT4CS1NP56x/ms9UEGwHA9SLEG5fq2JlMvhgN8Wz6
        YKZsKSAZZSICwcmZ249klM51LovVq4THAogR6/OLpTovjnwhYHm8/OTUNPNRUplT2GA6aJ
        BwMOXPThbWJNHch5dZ+yxoJMcqSJzwI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-MthgTUdAOtmX7imy-xlDOg-1; Tue, 21 Apr 2020 09:23:24 -0400
X-MC-Unique: MthgTUdAOtmX7imy-xlDOg-1
Received: by mail-wr1-f71.google.com with SMTP id m5so7463706wru.15
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 06:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ytKxWQADMe1hxsp4ibPZrOFawU10CTLZrsg1UsU9JN0=;
        b=QJO/WsU+uCWYPeYkZLn9CGXQBV5ep9nzyeRiMep2b48EyL+P2kaJjRFgD43VvvbUiX
         MkzZTz3Kgq1eFfiUrtdWFf+f7kiKvzsT9RgwxbqDXLQDM3EO2GD4VPGSkR1/EiNztVMk
         Yxn9YSLvRcZXaEdMaEo1u9obiVn639qr6HFxmasf9wJVO/XBQ9ekwavgMx02yIS4qiYz
         I9Xhb/mEQ/o3ma63RuUYww9aqBfWDeU4bdDgrBeMYcgLzhB3Zf4fTbP31xTQeGQa3UnV
         TgwKYMFrpKSrZbB9bqZGbiufY8rgA8dI3WsaoREl3koYnpaLxFJckzWb11q4zjKeVlT4
         M8ag==
X-Gm-Message-State: AGi0PuY+OGyp4+WX/x39KD4OyplQGm+27a0cgI80BlGmC/GM3Zz9xTAq
        xZ0sHLZCJV3rFbyEz7/p536KdhNk/+0g0Dt4a7/6FvctwOzIdNRASHClPGiu5fUIkDh2mUc7db1
        cDQUF2zurRsoK2ehb
X-Received: by 2002:a5d:4283:: with SMTP id k3mr22796303wrq.238.1587475401065;
        Tue, 21 Apr 2020 06:23:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypIMNn2YfNcf4IPaf9IVmkV32oOcmuFaDha8DPqw36FZ9/e+P6Z7Ojyc8EbM6VEDrhDoQCcs1Q==
X-Received: by 2002:a5d:4283:: with SMTP id k3mr22796294wrq.238.1587475400901;
        Tue, 21 Apr 2020 06:23:20 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id 185sm3947160wmc.32.2020.04.21.06.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:23:20 -0700 (PDT)
Subject: Re: [PATCH v2] tpm/tpm_tis: Free IRQ if probing fails
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200416160751.180791-1-jarkko.sakkinen@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <fa25cd78-2535-d26d-dd66-d64111af857a@redhat.com>
Date:   Tue, 21 Apr 2020 15:23:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200416160751.180791-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/16/20 6:07 PM, Jarkko Sakkinen wrote:
> Call disable_interrupts() if we have to revert to polling in order not to
> unnecessarily reserve the IRQ for the life-cycle of the driver.
> 
> Cc: stable@vger.kernel.org # 4.5.x
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I can confirm that this fixes the "irq 31 nobody cared" oops for me:

Tested-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans




> ---
>   drivers/char/tpm/tpm_tis_core.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 27c6ca031e23..2435216bd10a 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -433,6 +433,9 @@ static void disable_interrupts(struct tpm_chip *chip)
>   	u32 intmask;
>   	int rc;
>   
> +	if (priv->irq == 0)
> +		return;
> +
>   	rc = tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
>   	if (rc < 0)
>   		intmask = 0;
> @@ -1062,9 +1065,12 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>   		if (irq) {
>   			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
>   						 irq);
> -			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
> +			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
>   				dev_err(&chip->dev, FW_BUG
>   					"TPM interrupt not working, polling instead\n");
> +
> +				disable_interrupts(chip);
> +			}
>   		} else {
>   			tpm_tis_probe_irq(chip, intmask);
>   		}
> 

