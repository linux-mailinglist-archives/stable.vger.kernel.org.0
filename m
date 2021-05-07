Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E0E375F7D
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 06:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhEGEfb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 7 May 2021 00:35:31 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]:35503 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhEGEfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 00:35:31 -0400
Received: by mail-qk1-f176.google.com with SMTP id x8so7324383qkl.2;
        Thu, 06 May 2021 21:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ny/T7GETCcZsveAc22eept4j8pRJh4Gka9m8hkhoVOo=;
        b=K5NjoWuw90PKfs1J1nz3OQNFKjKleCp07sBguSZkuTYqzt+yg/fO5zt4XUICM0gT8W
         IS7M0jLVsw5cYDwtgMJvoJcGK9d/975rxPDybYXAMYGIDUJfM5L3Igc2Fj1iWQisLTlq
         4pEIC8M9ASWGb3p/9c0S9cWitHqnFxaXtQhpufvE+KeU9cG8RlATUNYUFqVMx7faOFq8
         IfVM9Gx99ujka7OXlgTrDLj8uLsRSos/HCV1kcigj8UYoYhxExNi/68GmmGPQC7kbarE
         B38MIx2QdEMzt5Tew3XMuQzCQdeCniovpFPDB426wPLotcdS+8/h7c5d+q7b4ztM1JMl
         8Kzw==
X-Gm-Message-State: AOAM533Uk6/oASDQEoR5rKZjgd1DXftiOmDBrBB4MVZ5ESJJTLeQUAXE
        N3vVyZZe2g4g6BQuM9zKBbw1gxMkLAw=
X-Google-Smtp-Source: ABdhPJx3qDTe8f4kbU5lASQAD88Rzzj+FaRBv1rGnD/PgTTLmOeVLCJClkpxFiby7a4ddyQ2xhrGwQ==
X-Received: by 2002:a37:8744:: with SMTP id j65mr8112694qkd.304.1620362070766;
        Thu, 06 May 2021 21:34:30 -0700 (PDT)
Received: from ?IPv6:2601:184:417f:5b5f::557e:48ed? ([2601:184:417f:5b5f::557e:48ed])
        by smtp.gmail.com with ESMTPSA id p187sm4149487qkd.92.2021.05.06.21.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 21:34:30 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.12 090/116] ASoC: rt286: Generalize support for
 ALC3263 codec
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org
References: <20210505163125.3460440-1-sashal@kernel.org>
 <20210505163125.3460440-90-sashal@kernel.org>
From:   David Ward <david.ward@gatech.edu>
Message-ID: <55cb81cd-4eb9-049a-abf6-d4628ac8cb34@gatech.edu>
Date:   Fri, 7 May 2021 00:34:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210505163125.3460440-90-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 12:30 PM, Sasha Levin wrote:
> From: David Ward <david.ward@gatech.edu>
>
> [ Upstream commit aa2f9c12821e6a4ba1df4fb34a3dbc6a2a1ee7fe ]
>
> The ALC3263 codec on the XPS 13 9343 is also found on the Latitude 13 7350
> and Venue 11 Pro 7140. They require the same handling for the combo jack to
> work with a headset: GPIO pin 6 must be set.
>
> The HDA driver always sets this pin on the ALC3263, which it distinguishes
> by the codec vendor/device ID 0x10ec0288 and PCI subsystem vendor ID 0x1028
> (Dell). The ASoC driver does not use PCI, so adapt this check to use DMI to
> determine if Dell is the system vendor.

For this patch to be useful, commit cd8499d5c03b ("ASoC: rt286: Make 
RT286_SET_GPIO_* readable and writable") from the same series is needed 
as well, which fixed the regmap config.

(The same comment is true for all stable branches.)

Thank you,

David

>
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=150601
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205961
> Signed-off-by: David Ward <david.ward@gatech.edu>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Link: https://lore.kernel.org/r/20210418134658.4333-6-david.ward@gatech.edu
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   sound/soc/codecs/rt286.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/sound/soc/codecs/rt286.c b/sound/soc/codecs/rt286.c
> index 8abe232ca4a4..2f18f5114f7e 100644
> --- a/sound/soc/codecs/rt286.c
> +++ b/sound/soc/codecs/rt286.c
> @@ -1117,12 +1117,11 @@ static const struct dmi_system_id force_combo_jack_table[] = {
>   	{ }
>   };
>   
> -static const struct dmi_system_id dmi_dell_dino[] = {
> +static const struct dmi_system_id dmi_dell[] = {
>   	{
> -		.ident = "Dell Dino",
> +		.ident = "Dell",
>   		.matches = {
>   			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "XPS 13 9343")
>   		}
>   	},
>   	{ }
> @@ -1133,7 +1132,7 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
>   {
>   	struct rt286_platform_data *pdata = dev_get_platdata(&i2c->dev);
>   	struct rt286_priv *rt286;
> -	int i, ret, val;
> +	int i, ret, vendor_id;
>   
>   	rt286 = devm_kzalloc(&i2c->dev,	sizeof(*rt286),
>   				GFP_KERNEL);
> @@ -1149,14 +1148,15 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
>   	}
>   
>   	ret = regmap_read(rt286->regmap,
> -		RT286_GET_PARAM(AC_NODE_ROOT, AC_PAR_VENDOR_ID), &val);
> +		RT286_GET_PARAM(AC_NODE_ROOT, AC_PAR_VENDOR_ID), &vendor_id);
>   	if (ret != 0) {
>   		dev_err(&i2c->dev, "I2C error %d\n", ret);
>   		return ret;
>   	}
> -	if (val != RT286_VENDOR_ID && val != RT288_VENDOR_ID) {
> +	if (vendor_id != RT286_VENDOR_ID && vendor_id != RT288_VENDOR_ID) {
>   		dev_err(&i2c->dev,
> -			"Device with ID register %#x is not rt286\n", val);
> +			"Device with ID register %#x is not rt286\n",
> +			vendor_id);
>   		return -ENODEV;
>   	}
>   
> @@ -1180,8 +1180,8 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
>   	if (pdata)
>   		rt286->pdata = *pdata;
>   
> -	if (dmi_check_system(force_combo_jack_table) ||
> -		dmi_check_system(dmi_dell_dino))
> +	if ((vendor_id == RT288_VENDOR_ID && dmi_check_system(dmi_dell)) ||
> +		dmi_check_system(force_combo_jack_table))
>   		rt286->pdata.cbj_en = true;
>   
>   	regmap_write(rt286->regmap, RT286_SET_AUDIO_POWER, AC_PWRST_D3);
> @@ -1220,7 +1220,7 @@ static int rt286_i2c_probe(struct i2c_client *i2c,
>   	regmap_update_bits(rt286->regmap, RT286_DEPOP_CTRL3, 0xf777, 0x4737);
>   	regmap_update_bits(rt286->regmap, RT286_DEPOP_CTRL4, 0x00ff, 0x003f);
>   
> -	if (dmi_check_system(dmi_dell_dino)) {
> +	if (vendor_id == RT288_VENDOR_ID && dmi_check_system(dmi_dell)) {
>   		regmap_update_bits(rt286->regmap,
>   			RT286_SET_GPIO_MASK, 0x40, 0x40);
>   		regmap_update_bits(rt286->regmap,

