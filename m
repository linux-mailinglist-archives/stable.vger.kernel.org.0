Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC408FCB38
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 17:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKNQ7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 11:59:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:8587 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfKNQ7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 11:59:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 08:59:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="235745047"
Received: from pkamlakx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.10.73])
  by fmsmga002.fm.intel.com with ESMTP; 14 Nov 2019 08:59:28 -0800
Date:   Thu, 14 Nov 2019 18:59:27 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     linux-integrity@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Christian Bundy <christianbundy@fraction.io>
Subject: Re: [PATCH v3] tpm_tis: turn on TPM before calling tpm_get_timeouts
Message-ID: <20191114165927.GB11107@linux.intel.com>
References: <20191111233418.17676-1-jsnitsel@redhat.com>
 <20191113000243.16611-1-jsnitsel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113000243.16611-1-jsnitsel@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 05:02:43PM -0700, Jerry Snitselaar wrote:
> With power gating moved out of the tpm_transmit code we need
> to power on the TPM prior to calling tpm_get_timeouts.
> 
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Peter Huewe <peterhuewe@gmx.de>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> Reported-by: Christian Bundy <christianbundy@fraction.io>
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
> ---
> v3: call tpm_chip_stop in error path
> v2: fix stable cc to correct address
> 
>  drivers/char/tpm/tpm_tis_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 270f43acbb77..806acc666696 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -974,13 +974,14 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  		 * to make sure it works. May as well use that command to set the
>  		 * proper timeouts for the driver.
>  		 */
> +		tpm_chip_start(chip);
>  		if (tpm_get_timeouts(chip)) {
>  			dev_err(dev, "Could not get TPM timeouts and durations\n");
>  			rc = -ENODEV;
> +			tpm_chip_stop(chip);
>  			goto out_err;
>  		}
>  
> -		tpm_chip_start(chip);

As the commit describes the call is not there for any other reason than
pinging the TPM.

/Jarkko
