Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7236B044B
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 11:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCHK3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 05:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjCHK3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 05:29:19 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD12B95F7;
        Wed,  8 Mar 2023 02:28:51 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pZqJx-00045V-Mp; Wed, 08 Mar 2023 10:42:53 +0100
Message-ID: <5e535bf9-c662-c133-7837-308d67dfac94@leemhuis.info>
Date:   Wed, 8 Mar 2023 10:42:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH v3] tpm: disable hwrng for fTPM on some AMD designs
Content-Language: en-US, de-DE
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        reach622@mailcuk.com, Bell <1138267643@qq.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        Mario Limonciello <mario.limonciello@amd.com>
References: <20230228024439.27156-1-mario.limonciello@amd.com>
 <Y/1wuXbaPcG9olkt@kernel.org>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
In-Reply-To: <Y/1wuXbaPcG9olkt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1678271331;98f23d9e;
X-HE-SMSGID: 1pZqJx-00045V-Mp
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
for once, to make this easily accessible to everyone.

Jarkko, thx for reviewing and picking below fix up. Are you planning to
send this to Linus anytime soon, now that the patch was a few days in
next? It would be good to get this 6.1 regression finally fixed, it
already took way longer then the time frame
Documentation/process/handling-regressions.rst outlines for a case like
this. But well, that's how it is sometimes...

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

On 28.02.23 04:10, Jarkko Sakkinen wrote:
> On Mon, Feb 27, 2023 at 08:44:39PM -0600, Mario Limonciello wrote:
>> AMD has issued an advisory indicating that having fTPM enabled in
>> BIOS can cause "stuttering" in the OS.  This issue has been fixed
>> in newer versions of the fTPM firmware, but it's up to system
>> designers to decide whether to distribute it.
>>
>> This issue has existed for a while, but is more prevalent starting
>> with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
>> hwrng kthread also for untrusted sources") started to use the fTPM
>> for hwrng by default. However, all uses of /dev/hwrng result in
>> unacceptable stuttering.
>>
>> So, simply disable registration of the defective hwrng when detecting
>> these faulty fTPM versions.  As this is caused by faulty firmware, it
>> is plausible that such a problem could also be reproduced by other TPM
>> interactions, but this hasn't been shown by any user's testing or reports.
>>
>> It is hypothesized to be triggered more frequently by the use of the RNG
>> because userspace software will fetch random numbers regularly.
>>
>> Intentionally continue to register other TPM functionality so that users
>> that rely upon PCR measurements or any storage of data will still have
>> access to it.  If it's found later that another TPM functionality is
>> exacerbating this problem a module parameter it can be turned off entirely
>> and a module parameter can be introduced to allow users who rely upon
>> fTPM functionality to turn it on even though this problem is present.
>>
>> Link: https://www.amd.com/en/support/kb/faq/pa-410
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
>> Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
>> Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
>> Cc: stable@vger.kernel.org
>> Cc: Jarkko Sakkinen <jarkko@kernel.org>
>> Cc: Thorsten Leemhuis <regressions@leemhuis.info>
>> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
>> Tested-by: reach622@mailcuk.com
>> Tested-by: Bell <1138267643@qq.com>
>> Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>> v2->v3:
>>  * Revert extra curl braces back to behavior in v1
>>  * Remove needless goto
>>  * Pick up 2 tested tags
>> ---
>>  drivers/char/tpm/tpm-chip.c | 60 +++++++++++++++++++++++++++++-
>>  drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
>>  2 files changed, 132 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index 741d8f3e8fb3..c467eeae9973 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -512,6 +512,63 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Some AMD fTPM versions may cause stutter
>> + * https://www.amd.com/en/support/kb/faq/pa-410
>> + *
>> + * Fixes are available in two series of fTPM firmware:
>> + * 6.x.y.z series: 6.0.18.6 +
>> + * 3.x.y.z series: 3.57.y.5 +
>> + */
>> +static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
>> +{
>> +	u32 val1, val2;
>> +	u64 version;
>> +	int ret;
>> +
>> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
>> +		return false;
>> +
>> +	ret = tpm_request_locality(chip);
>> +	if (ret)
>> +		return false;
>> +
>> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
>> +	if (ret)
>> +		goto release;
>> +	if (val1 != 0x414D4400U /* AMD */) {
>> +		ret = -ENODEV;
>> +		goto release;
>> +	}
>> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
>> +	if (ret)
>> +		goto release;
>> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
>> +
>> +release:
>> +	tpm_relinquish_locality(chip);
>> +
>> +	if (ret)
>> +		return false;
>> +
>> +	version = ((u64)val1 << 32) | val2;
>> +	if ((version >> 48) == 6) {
>> +		if (version >= 0x0006000000180006ULL)
>> +			return false;
>> +	} else if ((version >> 48) == 3) {
>> +		if (version >= 0x0003005700000005ULL)
>> +			return false;
>> +	} else {
>> +		return false;
>> +	}
>> +
>> +	dev_warn(&chip->dev,
>> +		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
>> +		 version);
>> +
>> +	return true;
>> +}
>> +
>>  static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>>  {
>>  	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
>> @@ -521,7 +578,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>>  
>>  static int tpm_add_hwrng(struct tpm_chip *chip)
>>  {
>> -	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
>> +	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
>> +	    tpm_amd_is_rng_defective(chip))
>>  		return 0;
>>  
>>  	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 24ee4e1cc452..830014a26609 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
>>  	TPM_CAP_PROP_TIS_DURATION = 0x120,
>>  };
>>  
>> +enum tpm2_pt_props {
>> +	TPM2_PT_NONE = 0x00000000,
>> +	TPM2_PT_GROUP = 0x00000100,
>> +	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
>> +	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
>> +	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
>> +	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
>> +	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
>> +	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
>> +	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
>> +	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
>> +	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
>> +	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
>> +	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
>> +	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
>> +	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
>> +	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
>> +	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
>> +	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
>> +	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
>> +	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
>> +	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
>> +	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
>> +	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
>> +	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
>> +	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
>> +	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
>> +	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
>> +	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
>> +	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
>> +	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
>> +	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
>> +	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
>> +	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
>> +	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
>> +	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
>> +	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
>> +	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
>> +	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
>> +	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
>> +	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
>> +	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
>> +	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
>> +	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
>> +	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
>> +	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
>> +	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
>> +	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
>> +	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
>> +	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
>> +	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
>> +	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
>> +	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
>> +	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
>> +	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
>> +	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
>> +	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
>> +	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
>> +	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
>> +	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
>> +	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
>> +	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
>> +	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
>> +	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
>> +	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
>> +	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
>> +	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
>> +	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
>> +	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
>> +	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
>> +	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
>> +	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
>> +};
>>  
>>  /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
>>   * bytes, but 128 is still a relatively large number of random bytes and
>> -- 
>> 2.34.1
>>
> 
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> BR, Jarkko
