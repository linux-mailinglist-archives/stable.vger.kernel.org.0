Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE51698C57
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjBPFtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBPFtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:49:10 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CA627D6E;
        Wed, 15 Feb 2023 21:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676526549; x=1708062549;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=02DmWapRv96DfLbRgUMaYDNcw8lOqY8xdF9Gy5/72BA=;
  b=iy1STufC2I12EM/vOujsciKcUWp/xiza3UE2KXUXXn2lbEDr4HvQbHdb
   acZ7cxJoNyGfit6QtJqqGBqK0KfaYxQRHkl8kX24xCRqFQtmDJeSy/Cqu
   Qus056UgwZXyOTBF4MfDs9OCXlMVxAf6gfbJS5M9tfrC/uguT9cpgb4JT
   YEgmOGqbTCuwdU+kwLDxfAY0xhXk4LaIPfG1cE28rMJhOOZ0/ro8C0ea0
   HmtpOVh/jIz5HNegPTd6jCzKSbUgK1HLnEMuAb2mg+Il4GuyE4V3T/4ql
   cEOvND7mYsHWviHvsx4pfttDO0D3DIiR4Cg08QhcnV5fozb6oWxUAjYoP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359060288"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="359060288"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 21:49:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="812847031"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="812847031"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 15 Feb 2023 21:49:06 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id EB5681A6; Thu, 16 Feb 2023 07:49:46 +0200 (EET)
Date:   Thu, 16 Feb 2023 07:49:46 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, Sanju.Mehta@amd.com,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] thunderbolt: Adjust how NVM reading works
Message-ID: <Y+3D+nRCXM4xhtwv@black.fi.intel.com>
References: <20230215172520.8925-1-mario.limonciello@amd.com>
 <20230215172520.8925-2-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230215172520.8925-2-mario.limonciello@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mario,

On Wed, Feb 15, 2023 at 11:25:19AM -0600, Mario Limonciello wrote:
> Some TBT3 devices have a hard time reliably responding to bit banging
> requests correctly when connected to AMD USB4 hosts running Linux.
> 
> These problems are not reported in any other CM supported on AMD platforms,
> and comparing the Windows and Pre-OS implementations the Linux CM is the
> only one that utilizes bit banging to access the DROM.
> Other CM implementations access the DROM directly from the NVM instead of
> bit banging.
> 
> Adjust the flow to use this method to fetch the NVM when the downstream
> device is Thunderbolt 3 and only use bit banging to access TBT 2 or TBT 1
> devices. As the flow is modified, also remove the retry sequence that was
> introduced from commit f022ff7bf377 ("thunderbolt: Retry DROM read once
> if parsing fails") as it will not be necessary if the NVM is fetched this
> way.
> 
> Cc: stable@vger.kernel.org
> Fixes: f022ff7bf377 ("thunderbolt: Retry DROM read once if parsing fails")

I don't think it fixes a regression of above commit and I don't think
this is stable material because it is quite a big change. I would rather
let it sit in -rcX for a while to make sure no user visible changes are
accidentally introduced. Is this OK for you?

Did you check that the UUID of these (and other possible) devices stay
the same before and after the patch?

> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v1->v2:
>  * Update commit message to indicate which CMs are tested
>  * Adjust flow to only fetch DROM from NVM on TBT3 and bit bang on TBT1/2
> ---
>  drivers/thunderbolt/eeprom.c | 145 +++++++++++++++++++----------------
>  1 file changed, 80 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
> index c90d22f56d4e..d1be72b6afdb 100644
> --- a/drivers/thunderbolt/eeprom.c
> +++ b/drivers/thunderbolt/eeprom.c
> @@ -416,7 +416,7 @@ static int tb_drom_parse_entries(struct tb_switch *sw, size_t header_size)
>  		if (pos + 1 == drom_size || pos + entry->len > drom_size
>  				|| !entry->len) {
>  			tb_sw_warn(sw, "DROM buffer overrun\n");
> -			return -EILSEQ;
> +			return -EIO;
>  		}
>  
>  		switch (entry->type) {
> @@ -544,7 +544,37 @@ static int tb_drom_read_n(struct tb_switch *sw, u16 offset, u8 *val,
>  	return tb_eeprom_read_n(sw, offset, val, count);
>  }
>  
> -static int tb_drom_parse(struct tb_switch *sw)
> +static int tb_drom_bit_bang(struct tb_switch *sw, u16 *size)
> +{
> +	int res;
> +
> +	res = tb_drom_read_n(sw, 14, (u8 *) size, 2);
> +	if (res)
> +		return res;
> +	*size &= 0x3ff;
> +	*size += TB_DROM_DATA_START;
> +	tb_sw_dbg(sw, "reading drom (length: %#x)\n", *size);
> +	if (*size < sizeof(struct tb_drom_header)) {
> +		tb_sw_warn(sw, "drom too small, aborting\n");
> +		return -EIO;
> +	}
> +
> +	sw->drom = kzalloc(*size, GFP_KERNEL);
> +	if (!sw->drom)
> +		return -ENOMEM;
> +
> +	res = tb_drom_read_n(sw, 0, sw->drom, *size);
> +	if (res)
> +		goto err;
> +
> +	return 0;
> +err:
> +	kfree(sw->drom);
> +	sw->drom = NULL;
> +	return res;
> +}

Can you split the refactoring part into a separate patch?

> +
> +static int tb_drom_parse_v1(struct tb_switch *sw)
>  {
>  	const struct tb_drom_header *header =
>  		(const struct tb_drom_header *)sw->drom;
> @@ -555,7 +585,7 @@ static int tb_drom_parse(struct tb_switch *sw)
>  		tb_sw_warn(sw,
>  			"DROM UID CRC8 mismatch (expected: %#x, got: %#x)\n",
>  			header->uid_crc8, crc);
> -		return -EILSEQ;
> +		return -EIO;
>  	}
>  	if (!sw->uid)
>  		sw->uid = header->uid;
> @@ -589,6 +619,43 @@ static int usb4_drom_parse(struct tb_switch *sw)
>  	return tb_drom_parse_entries(sw, USB4_DROM_HEADER_SIZE);
>  }
>  
> +static int tb_drom_parse(struct tb_switch *sw, u16 *size)
> +{
> +	struct tb_drom_header *header = (void *) sw->drom;
> +	int res;
> +
> +	if (header->data_len + TB_DROM_DATA_START != *size) {
> +		tb_sw_warn(sw, "drom size mismatch\n");
> +		goto err;
> +	}
> +
> +	tb_sw_dbg(sw, "DROM version: %d\n", header->device_rom_revision);
> +
> +	switch (header->device_rom_revision) {
> +	case 3:
> +		res = usb4_drom_parse(sw);
> +		break;
> +	default:
> +		tb_sw_warn(sw, "DROM device_rom_revision %#x unknown\n",
> +			   header->device_rom_revision);
> +		fallthrough;
> +	case 1:
> +		res = tb_drom_parse_v1(sw);
> +		break;
> +	}
> +
> +	if (res) {
> +		tb_sw_warn(sw, "parsing DROM failed\n");
> +		goto err;
> +	}
> +
> +	return 0;
> +err:
> +	kfree(sw->drom);
> +	sw->drom = NULL;
> +	return -EIO;
> +}
> +
>  /**
>   * tb_drom_read() - Copy DROM to sw->drom and parse it
>   * @sw: Router whose DROM to read and parse
> @@ -602,8 +669,7 @@ static int usb4_drom_parse(struct tb_switch *sw)
>  int tb_drom_read(struct tb_switch *sw)
>  {
>  	u16 size;
> -	struct tb_drom_header *header;
> -	int res, retries = 1;
> +	int res;
>  
>  	if (sw->drom)
>  		return 0;
> @@ -614,11 +680,11 @@ int tb_drom_read(struct tb_switch *sw)
>  		 * in a device property. Use it if available.
>  		 */
>  		if (tb_drom_copy_efi(sw, &size) == 0)
> -			goto parse;
> +			return tb_drom_parse(sw, &size);
>  
>  		/* Non-Apple hardware has the DROM as part of NVM */
>  		if (tb_drom_copy_nvm(sw, &size) == 0)
> -			goto parse;
> +			return tb_drom_parse(sw, &size);
>  
>  		/*
>  		 * USB4 hosts may support reading DROM through router
> @@ -627,7 +693,7 @@ int tb_drom_read(struct tb_switch *sw)
>  		if (tb_switch_is_usb4(sw)) {
>  			usb4_switch_read_uid(sw, &sw->uid);
>  			if (!usb4_copy_host_drom(sw, &size))
> -				goto parse;
> +				return tb_drom_parse(sw, &size);
>  		} else {
>  			/*
>  			 * The root switch contains only a dummy drom
> @@ -640,64 +706,13 @@ int tb_drom_read(struct tb_switch *sw)
>  		return 0;
>  	}
>  
> -	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
> +	/* TBT3 devices have the DROM as part of NVM */
> +	if (sw->generation < 3)

This is true for TBT2 devices too. I think you want to check for the
sw->cap_lc here instead. If it is set the device has LC and therefore we
can use the LC UUID registers to figure out the UUID in later stages.
Otherwise we need to read it through bitbanging.

> +		res = tb_drom_bit_bang(sw, &size);
> +	else
> +		res = tb_drom_copy_nvm(sw, &size);
>  	if (res)
>  		return res;
> -	size &= 0x3ff;
> -	size += TB_DROM_DATA_START;
> -	tb_sw_dbg(sw, "reading drom (length: %#x)\n", size);
> -	if (size < sizeof(*header)) {
> -		tb_sw_warn(sw, "drom too small, aborting\n");
> -		return -EIO;
> -	}
> -
> -	sw->drom = kzalloc(size, GFP_KERNEL);
> -	if (!sw->drom)
> -		return -ENOMEM;
> -read:
> -	res = tb_drom_read_n(sw, 0, sw->drom, size);
> -	if (res)
> -		goto err;
> -
> -parse:
> -	header = (void *) sw->drom;
> -
> -	if (header->data_len + TB_DROM_DATA_START != size) {
> -		tb_sw_warn(sw, "drom size mismatch\n");
> -		if (retries--) {
> -			msleep(100);
> -			goto read;
> -		}
> -		goto err;
> -	}
>  
> -	tb_sw_dbg(sw, "DROM version: %d\n", header->device_rom_revision);
> -
> -	switch (header->device_rom_revision) {
> -	case 3:
> -		res = usb4_drom_parse(sw);
> -		break;
> -	default:
> -		tb_sw_warn(sw, "DROM device_rom_revision %#x unknown\n",
> -			   header->device_rom_revision);
> -		fallthrough;
> -	case 1:
> -		res = tb_drom_parse(sw);
> -		break;
> -	}
> -
> -	/* If the DROM parsing fails, wait a moment and retry once */
> -	if (res == -EILSEQ && retries--) {
> -		tb_sw_warn(sw, "parsing DROM failed\n");
> -		msleep(100);
> -		goto read;
> -	}
> -
> -	if (!res)
> -		return 0;
> -
> -err:
> -	kfree(sw->drom);
> -	sw->drom = NULL;
> -	return -EIO;
> +	return tb_drom_parse(sw, &size);
>  }
> -- 
> 2.34.1
