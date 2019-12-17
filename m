Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF350122B09
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 13:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfLQMPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 07:15:17 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37105 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726690AbfLQMPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 07:15:17 -0500
Received: from [192.168.0.5] (ip5f5bf3f4.dynamic.kabel-deutschland.de [95.91.243.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D2D6B206441CD;
        Tue, 17 Dec 2019 13:15:14 +0100 (CET)
Subject: Re: [PATCH] tpm: Don't make log failures fatal
To:     Matthew Garrett <matthewgarrett@google.com>
Cc:     linux-integrity@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Matthew Garrett <mjg59@google.com>, stable@vger.kernel.org
References: <20191213225748.11256-1-matthewgarrett@google.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <3a472005-83a7-9787-0bfc-35673702be09@molgen.mpg.de>
Date:   Tue, 17 Dec 2019 13:15:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191213225748.11256-1-matthewgarrett@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Matthew,


Am 13.12.19 um 23:57 schrieb Matthew Garrett:
> If a TPM is in disabled state, it's reasonable for it to have an empty
> log. Bailing out of probe in this case means that the PPI interface
> isn't available, so there's no way to then enable the TPM from the OS.
> In general it seems reasonable to ignore log errors - they shouldn't
> itnerfere with any other TPM functionality.

interfere

Can this be tested with QEMU somehow?

> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/char/tpm/tpm-chip.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 3d6d394a8661..58073836b555 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -596,9 +596,7 @@ int tpm_chip_register(struct tpm_chip *chip)
>   
>   	tpm_sysfs_add_device(chip);
>   
> -	rc = tpm_bios_log_setup(chip);
> -	if (rc != 0 && rc != -ENODEV)
> -		return rc;
> +	tpm_bios_log_setup(chip);
>   
>   	tpm_add_ppi(chip);

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
