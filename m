Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD419697610
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 06:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjBOF5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 00:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjBOF5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 00:57:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051CD2CC72;
        Tue, 14 Feb 2023 21:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676440652; x=1707976652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e8nh889BjnqXdYZ+OAErY7SDOX2M636IKwDAN8zzEuY=;
  b=llK71/obOGTkOHIdGCNKmfh5v1/gA5otfrGo3kkyadwcpxas1uAoeyn5
   8uNL5BWprKJoiNs54kb/FU/oH6NPiJ54vfBKJ0BCEluIEJDddITtUA2L/
   olszwMSHIBi8AZmBRO7FJ53VinK6VOPecdsJhbibrcXCIYncm/0U01XLG
   CnH2drEasOI/wW8xfCAGibHV6aZ5jieaRfi7oNIglM4MZBETAfrpmpQ08
   J8IP+tmVq1LZu4iT6OpwNzKM/8e5MfhBmeCpBTYK0SjAeZcPSqVI35NzJ
   tb9YaHOCy2/toMOlM0LATiZ8wWNfoJCEIkOB8KshyDBALAqtNELGiJAUG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="311719779"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="311719779"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 21:57:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733152193"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="733152193"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 21:57:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 52BDD1A6; Wed, 15 Feb 2023 07:58:09 +0200 (EET)
Date:   Wed, 15 Feb 2023 07:58:09 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, Sanju.Mehta@amd.com,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] thunderbolt: Read DROM directly from NVM before
 trying bit banging
Message-ID: <Y+x0cbSpnIPYjZJE@black.fi.intel.com>
References: <20230214154647.874-1-mario.limonciello@amd.com>
 <20230214154647.874-2-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230214154647.874-2-mario.limonciello@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Feb 14, 2023 at 09:46:45AM -0600, Mario Limonciello wrote:
> Some TBT3 devices have a hard time reliably responding to bit banging
> requests correctly when connected to AMD USB4 hosts running Linux.
> 
> These problems are not reported in any other CM, and comparing the
> implementations the Linux CM is the only one that utilizes bit banging
> to access the DROM. Other CM implementations access the DROM directly
> from the NVM instead of bit banging.

I'm sure Apple CM uses bitbanging because it is what Andreas reverse
engineered when he added the initial Linux Thunderbolt support ;-) I
guess this is then only Window CM? The problem with reading NVM directly
is that we may lose things like UUID, so I'm wondering if there is
something else going on.

Can you give some details, like what is the device in question?

> Adjust the flow to try this on TBT3 devices before resorting to bit
> banging.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/thunderbolt/eeprom.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
> index c90d22f56d4e1..d9d9567bb938b 100644
> --- a/drivers/thunderbolt/eeprom.c
> +++ b/drivers/thunderbolt/eeprom.c
> @@ -640,6 +640,10 @@ int tb_drom_read(struct tb_switch *sw)
>  		return 0;
>  	}
>  
> +	/* TBT3 devices have the DROM as part of NVM */
> +	if (tb_drom_copy_nvm(sw, &size) == 0)
> +		goto parse;
> +
>  	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
>  	if (res)
>  		return res;
> -- 
> 2.25.1
