Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC05122946
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLQKyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:54:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:1665 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbfLQKyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 05:54:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 02:54:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="416784382"
Received: from pbroex-mobl1.ger.corp.intel.com ([10.251.85.107])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2019 02:54:37 -0800
Message-ID: <71bb3bdebe302fcc8254ba9e8b607001bb87aa1b.camel@linux.intel.com>
Subject: Re: [PATCH] tpm: Don't make log failures fatal
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Matthew Garrett <matthewgarrett@google.com>,
        linux-integrity@vger.kernel.org
Cc:     Matthew Garrett <mjg59@google.com>, stable@vger.kernel.org
Date:   Tue, 17 Dec 2019 12:54:35 +0200
In-Reply-To: <20191213225748.11256-1-matthewgarrett@google.com>
References: <20191213225748.11256-1-matthewgarrett@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-12-13 at 14:57 -0800, Matthew Garrett wrote:
> If a TPM is in disabled state, it's reasonable for it to have an empty
> log. Bailing out of probe in this case means that the PPI interface
> isn't available, so there's no way to then enable the TPM from the OS.
> In general it seems reasonable to ignore log errors - they shouldn't
> itnerfere with any other TPM functionality.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Cc: stable@vger.kernel.org

Otherwise looks great but maybe it would make sense to change
tpm_bios_log_setup() as void as part of the change?

> ---
>  drivers/char/tpm/tpm-chip.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 3d6d394a8661..58073836b555 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -596,9 +596,7 @@ int tpm_chip_register(struct tpm_chip *chip)
>  
>  	tpm_sysfs_add_device(chip);
>  
> -	rc = tpm_bios_log_setup(chip);
> -	if (rc != 0 && rc != -ENODEV)
> -		return rc;
> +	tpm_bios_log_setup(chip);
>  
>  	tpm_add_ppi(chip);
>  

/Jarkko

