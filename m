Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92BE27B0DD
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 17:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgI1PYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 11:24:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:5963 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgI1PYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 11:24:34 -0400
IronPort-SDR: bsLW0TZYuwku2RqoCLWj30hKy2PRubiORVIASahMuUg1k07J36oRmSLRvey7ZQHXiUwqaesI4j
 Cz/ZCknzu91w==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162069047"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="162069047"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:24:32 -0700
IronPort-SDR: 1psaqP+XFbyJbm7SOWmz85uX4oOAJ/3vo7nJHq/HfWFZmwxaelbGk+I4QVxBiH4BXEthPLUoRf
 UvMrRm5jTzfw==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="488620669"
Received: from dprzyby-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.31])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:24:30 -0700
Date:   Mon, 28 Sep 2020 18:24:31 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Kent Yoder <key@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: trusted: Fix incorrect handling of
 tpm_get_random()
Message-ID: <20200928152431.GA93932@linux.intel.com>
References: <20200928132405.68624-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928132405.68624-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 04:24:04PM +0300, Jarkko Sakkinen wrote:
> When tpm_get_random() was introduced, it defined the following API for the
> return value:
> 
> 1. A positive value tells how many bytes of random data was generated.
> 2. A negative value on error.
> 
> However, in the call sites the API was used incorrectly, i.e. as it would
> only return negative values and otherwise zero. Returning he positive read
> counts to the user space does not make any possible sense.
> 
> Fix this by returning -EIO when tpm_get_random() returns a positive value.
> 
> Fixes: 41ab999c80f1 ("tpm: Move tpm_get_random api into the TPM device driver")
> Cc: Kent Yoder <key@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  security/keys/trusted-keys/trusted_tpm1.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
> index b9fe02e5f84f..0f2e893c6b5f 100644
> --- a/security/keys/trusted-keys/trusted_tpm1.c
> +++ b/security/keys/trusted-keys/trusted_tpm1.c
> @@ -403,9 +403,12 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
>  	int ret;
>  
>  	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
> -	if (ret != TPM_NONCE_SIZE)
> +	if (ret < 0)
>  		return ret;
>  
> +	if (ret != TPM_NONCE_SIZE)
> +		return -EIO;
> +
>  	tpm_buf_reset(tb, TPM_TAG_RQU_COMMAND, TPM_ORD_OSAP);
>  	tpm_buf_append_u16(tb, type);
>  	tpm_buf_append_u32(tb, handle);
> @@ -496,8 +499,12 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
>  		goto out;
>  
>  	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
> +	if (ret < 0)
> +		return ret;
> +
>  	if (ret != TPM_NONCE_SIZE)
> -		goto out;
> +		return -EIO;
> +
>  	ordinal = htonl(TPM_ORD_SEAL);
>  	datsize = htonl(datalen);
>  	pcrsize = htonl(pcrinfosize);
> @@ -601,6 +608,9 @@ static int tpm_unseal(struct tpm_buf *tb,
>  
>  	ordinal = htonl(TPM_ORD_UNSEAL);
>  	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
> +	if (ret < 0)
> +		return -EIO;
> +
>  	if (ret != TPM_NONCE_SIZE) {
>  		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
>  		return ret;
> @@ -1013,6 +1023,11 @@ static int trusted_instantiate(struct key *key,
>  	case Opt_new:
>  		key_len = payload->key_len;
>  		ret = tpm_get_random(chip, payload->key, key_len);
> +		if (ret < 0) {
> +			ret = -EIO;
> +			goto out;
> +		}
> +
>  		if (ret != key_len) {
>  			pr_info("trusted_key: key_create failed (%d)\n", ret);
>  			goto out;

Ugh. I'll send an update (was not the final version, had unstaged
changes).

/Jarkko
