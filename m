Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA80D141681
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 09:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgARIWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 03:22:10 -0500
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:57383 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgARIWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 03:22:10 -0500
Subject: Re: [PATCH] tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before
 probing for interrupts"
To:     Miaohe Lin <linmiaohe@huawei.com>
CC:     Stefan Berger <stefanb@linux.ibm.com>, <stable@vger.kernel.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
References: <20200118202544.14523-1-linmiaohe@huawei.com>
From:   Thomas Backlund <tmb@mageia.org>
Message-ID: <36bebb77-95b8-49b4-ad55-73f6c0ddf9b2@mageia.org>
Date:   Sat, 18 Jan 2020 10:22:06 +0200
MIME-Version: 1.0
In-Reply-To: <20200118202544.14523-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-WatchGuard-Spam-ID: str=0001.0A0C0213.5E22C031.0042,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-WatchGuard-Spam-Score: 0, clean; 0, virus threat unknown
X-WatchGuard-Mail-Client-IP: 85.134.45.194
X-WatchGuard-Mail-From: tmb@mageia.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 18-01-2020 kl. 22:25, skrev Miaohe Lin:
> From: Stefan Berger <stefanb@linux.ibm.com>
> 
> There has been a bunch of reports (one from kernel bugzilla linked)
> reporting that when this commit is applied it causes on some machines
> boot freezes.
> 
> Unfortunately hardware where this commit causes a failure is not widely
> available (only one I'm aware is Lenovo T490), which means we cannot
> predict yet how long it will take to properly fix tpm_tis interrupt
> probing.
> 
> Thus, the least worst short term action is to revert the code to the
> state before this commit. In long term we need fix the tpm_tis probing
> code to work on machines that Stefan's fix was supposed to fix.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=205935
> Fixes: 1ea32c83c699 ("tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts")
> Cc: stable@vger.kernel.org
> Cc: Jerry Snitselaar <jsnitsel@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
> Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
> Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>   drivers/char/tpm/tpm_tis_core.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 8af2cee1a762..5dc52c4e2292 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -1060,7 +1060,6 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>   		}
>   
>   		tpm_chip_start(chip);
> -		chip->flags |= TPM_CHIP_FLAG_IRQ;
>   		if (irq) {
>   			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
>   						 irq);
> 

Please check before posting...

This is already reverted in 5.4.12 relased ~4 days ago..


--
Thomas
