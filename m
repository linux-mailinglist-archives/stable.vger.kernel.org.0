Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4B369B539
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 23:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBQWF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 17:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBQWF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 17:05:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2EB64B19;
        Fri, 17 Feb 2023 14:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1108EB82B45;
        Fri, 17 Feb 2023 22:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BB3C433EF;
        Fri, 17 Feb 2023 22:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676671520;
        bh=rvwbMc7UtbeDFPAPiqKfh0di31mOV8zk+Vkgf9kqo9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+iAq0nNES+YgbQHKdW2bQljZVU9aRu3RdsBSGqHaF3OSzKaNtCQuvfRmj9LJtsL5
         /ZrPRBlZC9uHDS/TYtIf4aATaBuRWgpLsT9LnyvdlveaLHIsMImD0GAcrtcBADPBw1
         7Ye8hNH6XtMo5655Dff3cv2kbS+jLFnoSYfZ3+A3Au32iYf6QVoT/CMDApIM1WiNEw
         Uwm2z1ya2owVhf1yLjwHnv7HbiLBn5qpYcIJErAvKoaNCvUOZXA+A00Kas6LKMxQVd
         Rxz+KwPBsfGEw1PWAhRtrhEjtQ+ItE6wpqqAXW/y192kwr6R9SiQ2I/Ou/NXk47kP9
         X3xv/Nz+NeEcg==
Date:   Sat, 18 Feb 2023 00:05:15 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jason@zx2c4.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] tpm: disable hwrng for fTPM on some AMD designs
Message-ID: <Y+/6G+UlTI7GpW6o@kernel.org>
References: <20230214201955.7461-1-mario.limonciello@amd.com>
 <20230214201955.7461-2-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214201955.7461-2-mario.limonciello@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 02:19:55PM -0600, Mario Limonciello wrote:
> AMD has issued an advisory indicating that having fTPM enabled in
> BIOS can cause "stuttering" in the OS.  This issue has been fixed
> in newer versions of the fTPM firmware, but it's up to system
> designers to decide whether to distribute it.
> 
> This issue has existed for a while, but is more prevalent starting
> with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
> hwrng kthread also for untrusted sources") started to use the fTPM
> for hwrng by default. However, all uses of /dev/hwrng result in
> unacceptable stuttering.
> 
> So, simply disable registration of the defective hwrng when detecting
> these faulty fTPM versions.
> 
> Link: https://www.amd.com/en/support/kb/faq/pa-410
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
> Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
> Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
> Cc: stable@vger.kernel.org
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/char/tpm/tpm-chip.c | 62 ++++++++++++++++++++++++++++++-
>  drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 134 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 741d8f3e8fb3a..348dd5705fbb6 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -512,6 +512,65 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>  	return 0;
>  }
>  
> +static bool tpm_is_rng_defective(struct tpm_chip *chip)

Perhaps tpm_amd_* ?

Also, just a question: is there any legit use for fTPM's, which are not
updated? I.e. why would want tpm_crb to initialize with a dysfunctional
firmware?

I.e. the existential question is: is it better to workaround the issue and
let pass through, or make the user aware that the firmware would really
need an update.

> +{
> +	int ret;
> +	u64 version;
> +	u32 val1, val2;

I'd use reverse christmas tree order here.

> +
> +	/* No known-broken TPM1 chips. */
> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
> +		return false;
> +
> +	ret = tpm_request_locality(chip);
> +	if (ret)
> +		return false;
> +
> +	/* Some AMD fTPM versions may cause stutter */
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
> +	if (ret)
> +		goto release;
> +	if (val1 != 0x414D4400U /* AMD */) {
> +		ret = -ENODEV;
> +		goto release;
> +	}
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
> +	if (ret)
> +		goto release;
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
> +	if (ret)
> +		goto release;
> +
> +release:
> +	tpm_relinquish_locality(chip);
> +
> +	if (ret)
> +		return false;
> +
> +	version = ((u64)val1 << 32) | val2;
> +	/*
> +	 * Fixes for stutter as described in
> +	 * https://www.amd.com/en/support/kb/faq/pa-410
> +	 * are available in two series of fTPM firmware:
> +	 *   6.x.y.z series: 6.0.18.6 +
> +	 *   3.x.y.z series: 3.57.x.5 +
> +	 */
> +	if ((version >> 48) == 6) {
> +		if (version >= 0x0006000000180006ULL)
> +			return false;
> +	} else if ((version >> 48) == 3) {
> +		if (version >= 0x0003005700000005ULL)
> +			return false;
> +	} else {
> +		return false;
> +	}

You can drop the curly braces here.

> +	dev_warn(&chip->dev,
> +		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
> +		 version);
> +
> +	return true;
> +}
> +
>  static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  {
>  	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
> @@ -521,7 +580,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  
>  static int tpm_add_hwrng(struct tpm_chip *chip)
>  {
> -	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
> +	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
> +	    tpm_is_rng_defective(chip))
>  		return 0;
>  
>  	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 24ee4e1cc452a..830014a266090 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
>  	TPM_CAP_PROP_TIS_DURATION = 0x120,
>  };
>  
> +enum tpm2_pt_props {
> +	TPM2_PT_NONE = 0x00000000,
> +	TPM2_PT_GROUP = 0x00000100,
> +	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
> +	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
> +	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
> +	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
> +	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
> +	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
> +	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
> +	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
> +	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
> +	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
> +	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
> +	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
> +	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
> +	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
> +	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
> +	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
> +	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
> +	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
> +	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
> +	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
> +	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
> +	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
> +	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
> +	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
> +	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
> +	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
> +	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
> +	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
> +	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
> +	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
> +	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
> +	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
> +	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
> +	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
> +	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
> +	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
> +	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
> +	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
> +	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
> +	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
> +	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
> +	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
> +	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
> +	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
> +	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
> +	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
> +	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
> +	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
> +	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
> +	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
> +	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
> +	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
> +	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
> +	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
> +	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
> +	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
> +	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
> +	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
> +	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
> +	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
> +	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
> +	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
> +	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
> +	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
> +	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
> +	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
> +	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
> +	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
> +	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
> +};
>  
>  /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
>   * bytes, but 128 is still a relatively large number of random bytes and
> -- 
> 2.25.1
> 

BR, Jarkko
