Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4DA2489F6
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgHRPgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 11:36:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:45697 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbgHRPgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 11:36:05 -0400
IronPort-SDR: 8ZHthcML3nNH8jY3sar1sMG0Skgryk/aqfUEE3WnKrDVvLeA8CMd3GI502uwWAqXZbAXfV0Cqv
 src3yvnFwB4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="134451438"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="134451438"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 08:36:04 -0700
IronPort-SDR: k0729j/64Nojw6qqEFlOkaNR7Eph6Y6yS8XDC/CqFnVtSbNxbFvuYe9ZL6kIZLRa5GvoTDOXzJ
 +Cb408QG4y8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="497408127"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by fmsmga005.fm.intel.com with ESMTP; 18 Aug 2020 08:36:03 -0700
Date:   Tue, 18 Aug 2020 18:36:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     gregkh@linuxfoundation.org, stefanb@linux.ibm.com
Cc:     jsnitsel@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tpm: Unify the mismatching TPM space
 buffer sizes" failed to apply to 4.14-stable tree
Message-ID: <20200818153602.GA137059@linux.intel.com>
References: <1597659249143217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597659249143217@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stefan, are you concerned of not having this in 4.14 and 4.19?

/Jarkko

On Mon, Aug 17, 2020 at 12:14:09PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 6c4e79d99e6f42b79040f1a33cd4018f5425030b Mon Sep 17 00:00:00 2001
> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Date: Fri, 3 Jul 2020 01:55:59 +0300
> Subject: [PATCH] tpm: Unify the mismatching TPM space buffer sizes
> 
> The size of the buffers for storing context's and sessions can vary from
> arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
> maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
> enough for most use with three handles (that is how many we allow at the
> moment). Parametrize the buffer size while doing this, so that it is easier
> to revisit this later on if required.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Stefan Berger <stefanb@linux.ibm.com>
> Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 8c77e88012e9..ddaeceb7e109 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -386,13 +386,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->cdev.owner = THIS_MODULE;
>  	chip->cdevs.owner = THIS_MODULE;
>  
> -	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!chip->work_space.context_buf) {
> -		rc = -ENOMEM;
> -		goto out;
> -	}
> -	chip->work_space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!chip->work_space.session_buf) {
> +	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
> +	if (rc) {
>  		rc = -ENOMEM;
>  		goto out;
>  	}
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 0fbcede241ea..947d1db0a5cc 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -59,6 +59,9 @@ enum tpm_addr {
>  
>  #define TPM_TAG_RQU_COMMAND 193
>  
> +/* TPM2 specific constants. */
> +#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
> +
>  struct	stclear_flags_t {
>  	__be16	tag;
>  	u8	deactivated;
> @@ -228,7 +231,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
>  int tpm2_probe(struct tpm_chip *chip);
>  int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip);
>  int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
> -int tpm2_init_space(struct tpm_space *space);
> +int tpm2_init_space(struct tpm_space *space, unsigned int buf_size);
>  void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
>  void tpm2_flush_space(struct tpm_chip *chip);
>  int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index 982d341d8837..784b8b3cb903 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -38,18 +38,21 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
>  	}
>  }
>  
> -int tpm2_init_space(struct tpm_space *space)
> +int tpm2_init_space(struct tpm_space *space, unsigned int buf_size)
>  {
> -	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	space->context_buf = kzalloc(buf_size, GFP_KERNEL);
>  	if (!space->context_buf)
>  		return -ENOMEM;
>  
> -	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	space->session_buf = kzalloc(buf_size, GFP_KERNEL);
>  	if (space->session_buf == NULL) {
>  		kfree(space->context_buf);
> +		/* Prevent caller getting a dangling pointer. */
> +		space->context_buf = NULL;
>  		return -ENOMEM;
>  	}
>  
> +	space->buf_size = buf_size;
>  	return 0;
>  }
>  
> @@ -311,8 +314,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
>  	       sizeof(space->context_tbl));
>  	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
>  	       sizeof(space->session_tbl));
> -	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
> -	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
> +	memcpy(chip->work_space.context_buf, space->context_buf,
> +	       space->buf_size);
> +	memcpy(chip->work_space.session_buf, space->session_buf,
> +	       space->buf_size);
>  
>  	rc = tpm2_load_space(chip);
>  	if (rc) {
> @@ -492,7 +497,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
>  			continue;
>  
>  		rc = tpm2_save_context(chip, space->context_tbl[i],
> -				       space->context_buf, PAGE_SIZE,
> +				       space->context_buf, space->buf_size,
>  				       &offset);
>  		if (rc == -ENOENT) {
>  			space->context_tbl[i] = 0;
> @@ -509,9 +514,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
>  			continue;
>  
>  		rc = tpm2_save_context(chip, space->session_tbl[i],
> -				       space->session_buf, PAGE_SIZE,
> +				       space->session_buf, space->buf_size,
>  				       &offset);
> -
>  		if (rc == -ENOENT) {
>  			/* handle error saving session, just forget it */
>  			space->session_tbl[i] = 0;
> @@ -557,8 +561,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>  	       sizeof(space->context_tbl));
>  	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
>  	       sizeof(space->session_tbl));
> -	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
> -	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
> +	memcpy(space->context_buf, chip->work_space.context_buf,
> +	       space->buf_size);
> +	memcpy(space->session_buf, chip->work_space.session_buf,
> +	       space->buf_size);
>  
>  	return 0;
>  out:
> diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
> index 7a0a7051a06f..eef0fb06ea83 100644
> --- a/drivers/char/tpm/tpmrm-dev.c
> +++ b/drivers/char/tpm/tpmrm-dev.c
> @@ -21,7 +21,7 @@ static int tpmrm_open(struct inode *inode, struct file *file)
>  	if (priv == NULL)
>  		return -ENOMEM;
>  
> -	rc = tpm2_init_space(&priv->space);
> +	rc = tpm2_init_space(&priv->space, TPM2_SPACE_BUFFER_SIZE);
>  	if (rc) {
>  		kfree(priv);
>  		return -ENOMEM;
> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
> index 03e9b184411b..8f4ff39f51e7 100644
> --- a/include/linux/tpm.h
> +++ b/include/linux/tpm.h
> @@ -96,6 +96,7 @@ struct tpm_space {
>  	u8 *context_buf;
>  	u32 session_tbl[3];
>  	u8 *session_buf;
> +	u32 buf_size;
>  };
>  
>  struct tpm_bios_log {
> 
